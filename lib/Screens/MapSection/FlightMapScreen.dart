import 'dart:async';
import 'dart:ui' as ui;
import 'package:avionics_internal/bloc/MapSection/FilterMap/filter_Map_State.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../../Constants/ApiClass/FirebaseAnalytics/analytics_service.dart';
import '../../Constants/ApiClass/FirebaseAnalytics/event_names.dart';
import '../../CustomFiles/Custom_SnackBar.dart';
import '../../Helpers/CustomSegmentController/CustomSegmentController.dart';
import '../../bloc/Home/AllPlanesBloc/AllPlanes_cubit.dart';
import '../../bloc/Home/SavedFlighDetails/savedFlight_repository.dart';
import '../../bloc/MapSection/ParsedPolygon.dart';
import 'AirportStationDetailCard.dart';
import 'FlightDetailCard.dart';
import 'FlightGoogleMapWidget.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'MapHelpers/MapToggleButtons.dart';
import '../../Helpers/SearchBarWidget.dart';
import '../../Constants/constantImages.dart';
import 'MapHelpers/MapTrackingModePopup.dart';
import 'MapHelpers/TrackAndSeacrhFlight.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../Constants/ApiClass/ApiErrorModel.dart';
import '../../bloc/MapSection/flight_map_model.dart';
import '../../bloc/MapSection/flight_map_state.dart';
import '../../bloc/MapSection/flight_Map_Cubit.dart';
import '../../Helpers/MapSection/rotatePlane_icon.dart';
import '../../Helpers/CacheManger/CachedImageFile.dart';
import '../Home/HomeAirbus/ChatSection/ChatBotScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../bloc/MapSection/FilterMap/filter_Map_Cubit.dart';
import '../Home/AppBarFilterAndMapFilter/FilterForMapScreen.dart';
import '../../bloc/MapSection/MapSeacrhAircraftList/map_Search_Aircraft_List_Model.dart';
import '../../bloc/MapSection/MapSeacrhAircraftList/map_Search_Aircraft_List_cubit.dart';

class FlightMapScreen extends StatefulWidget {
  final VoidCallback onGoToFirstTab;
  final bool skipInitialPopup;
  final int? openMode;

  const FlightMapScreen({
    required this.onGoToFirstTab,
    this.skipInitialPopup = false,
    this.openMode,
    super.key,
  });

  @override
  State<FlightMapScreen> createState() => _FlightMapscreenState();
}

class _FlightMapscreenState extends State<FlightMapScreen> {
  FlightMapCubit get _mapCubit => context.read<FlightMapCubit>();

  Timer? _debounce;
  int _activeCard = 0;

  bool isMapViewSelected = true;
  bool _isMapListViewShown = true;
  bool _hasFetchedDetails = false;

  String? selectedFlightId;

  int _isForFlyingInTheArea = 0;
  Marker? _singleSearchMarker;
  GoogleMapController? _mapController;
  bool _isUserInteractingWithMap = true;

  late final ValueNotifier<Set<Polygon>> polygonNotifier;
  final Set<Polygon> cachedPolygons = <Polygon>{};
  bool showPolygon = false;
  String? _selectedPolygonId;
  List<ParsedPolygon> _parsedPolygons = [];

  int selectedSegmentIndex = 0;

  late final TextEditingController _searchController = TextEditingController();
  late final DraggableScrollableController _sheetController =
      DraggableScrollableController();

  @override
  void initState() {
    super.initState();
    polygonNotifier = ValueNotifier<Set<Polygon>>(<Polygon>{});

    _loadGeoJson(context);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final hasPermission = await _mapCubit.getCurrentLocation(context);

      if (hasPermission) {
        if (widget.skipInitialPopup && widget.openMode != null) {
          if (widget.openMode == 1) {
            setState(() {
              _singleSearchMarker = null;
              _isMapListViewShown = true;
              _isForFlyingInTheArea = 1;
            });
            _resetFlightSelection();
          } else if (widget.openMode == 2) {
            setState(() {
              _activeCard = 0;
              _singleSearchMarker = null;
              _isMapListViewShown = false;
              _isForFlyingInTheArea = 2;
            });
            _handleTextTap(context);
          }
        } else {
          _showInitialTrackingModePopup(context);
        }
        await _loadFavoritesFlights();
      }
    });

    _sheetController.addListener(_sheetListener);
    AnalyticsService.instance.logVisibleScreen(FirebaseEvents.trackScreen);
  }

  @override
  void dispose() {
    _selectedPolygonId = null;
    polygonNotifier.dispose();
    cachedPolygons.clear();
    _debounce?.cancel();
    _debounce = null;

    selectedFlightId = null;
    _singleSearchMarker = null;

    if (!kIsWeb) {
      _mapController?.dispose();
      _mapController = null;
    }

    _resetFlightSelection(cleanupOnly: true);

    _sheetController.removeListener(_sheetListener);
    _searchController.dispose();
    _sheetController.dispose();
    PaintingBinding.instance.imageCache.clear();
    super.dispose();
  }

  Future<void> _loadFavoritesFlights() async {
    final favCallSigns = await SavedFlightRepository().getFavoriteCallSigns();

    debugPrint('Favorite CallSigns: $favCallSigns');

    if (!mounted) return;

    context.read<FlightMapCubit>().FavoriteFlights(favCallSigns);
  }

  Future<void> _loadGeoJson(BuildContext context) async {
    try {
      final jsonStr = await rootBundle.loadString(
        "assets/mapFiles/GeoPolygonMap.json",
      );

      final parsed = await compute(parseGeoJson, jsonStr);

      if (!mounted) return;

      _parsedPolygons = parsed;

      cachedPolygons
        ..clear()
        ..addAll(
          _parsedPolygons.expand((p) => _buildPolygon(context, p)).toSet(),
        );

      if (showPolygon) {
        polygonNotifier.value = cachedPolygons;
      }
    } catch (e, st) {
      debugPrint("GeoJSON load failed: $e");
      debugPrint("$st");
    }
  }

  Set<Polygon> _buildPolygon(BuildContext context, dynamic p) {
    final Set<Polygon> polygons = {};
    final bool isSelected = _selectedPolygonId == p.id;

    int index = 0;

    for (final ring in p.polygons) {
      // p.polygons → List<List<List<double>>>
      polygons.add(
        Polygon(
          polygonId: PolygonId('${p.id}_$index'),
          points: ring
              .map<LatLng>(
                (e) => LatLng(
                  e[1].clamp(-85.0, 85.0), // lat
                  e[0], // lng
                ),
              )
              .toList(),

          strokeWidth: isSelected ? 2 : 1,
          strokeColor: isSelected ? Colors.purple : Colors.red,
          fillColor: isSelected
              ? Colors.yellow.withOpacity(0.25)
              : Colors.transparent,

          consumeTapEvents: true,

          onTap: () {
            if (_mapCubit.state.mapType != CustomMapType.polygon) return;

            _selectedPolygonId =
            (_selectedPolygonId == p.id) ? null : p.id;

            final newPolygons = _parsedPolygons
                .expand((poly) => _buildPolygon(context, poly))
                .toSet();

            polygonNotifier.value = newPolygons;

            if (_selectedPolygonId != null) {
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text(p.name)));
            }
          },
        ),
      );
      index++;
    }

    return polygons;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SizedBox.expand(
        child: BlocBuilder<FlightMapCubit, FlightMapState>(
          builder: (context, state) {
            if (state.isLoading) {
              return const Scaffold(
                backgroundColor: Colors.white,
                body: Center(child: CircularProgressIndicator()),
              );
            }

            if (state.status == CommonApiStatus.failure) {
              return Center(
                child: Text(
                  state.errorMessage ?? 'Failed to get current location',
                ),
              );
            }

            if (state.status == CommonApiStatus.success &&
                state.position != null) {
              return Stack(
                fit: StackFit.expand,
                children: [
                  LayoutBuilder(
                    builder: (context, constraints) {
                      return FutureBuilder<Set<Marker>>(
                        future: _buildFlightMarkers(
                          state.isTracking && state.selectedFlight != null
                              ? [state.selectedFlight!]
                              : state.flights ?? [],
                          false,
                        ),
                        builder: (context, snapshot) {
                          return ValueListenableBuilder<Set<Polygon>>(
                            valueListenable: polygonNotifier,
                            builder: (_, polygons, __) {
                              return FlightGoogleMapWidget(
                                mapType: _mapCubit.state.mapType
                                    .toGoogleMapType(),
                                polygons: polygons,

                                initialCameraPosition: CameraPosition(
                                  target: LatLng(
                                    state.position!.latitude,
                                    state.position!.longitude,
                                  ),
                                  zoom: 8,
                                ),

                                markers: {
                                  Marker(
                                    markerId: const MarkerId("current"),
                                    position: LatLng(
                                      state.position!.latitude,
                                      state.position!.longitude,
                                    ),
                                    infoWindow: const InfoWindow(
                                      title: "Current Location",
                                    ),
                                  ),
                                  if (_singleSearchMarker != null)
                                    _singleSearchMarker!,
                                  if (snapshot.hasData) ...snapshot.data!,
                                },

                                isTracking: state.isTracking,
                                trackingLatLng: state.selectedFlight != null
                                    ? LatLng(
                                        state.selectedFlight!.latitude,
                                        state.selectedFlight!.longitude,
                                      )
                                    : null,

                                onCameraIdle: () {
                                  if (!_isUserInteractingWithMap) return;
                                  _isUserInteractingWithMap = false;
                                  _fetchFlightsWithDebounce(constraints);
                                },

                                onCameraMoveStarted: () {
                                  _isUserInteractingWithMap = true;
                                },

                                onMapCreated: (controller) {
                                  _mapController = controller;
                                },
                              );
                            },
                          );
                        },
                      );
                    },
                  ),

                  if (_isMapListViewShown)
                    Positioned(
                      top: kIsWeb ? 100 : 130,
                      right: 30,
                      child: MapToggleButtons(
                        isMapViewSelected: isMapViewSelected,
                        onToggle: handleToggle, // Passing the callback function
                      ),
                    ),

                  _buildSearchBar(context, state),

                  if (_isMapListViewShown == true)
                    _buildFlightsDraggableSheet(context, state),

                  if (_activeCard == 1 && state.selectedFlightDetail != null)
                    _buildAnimatedFlightCard(context),

                  if (_activeCard == 2 && state.selectedAirport != null)
                    _buildAnimatedAirportDetailsCard(context),
                ],
              );
            }
            return const Center(child: Text('Fetching your location...'));
          },
        ),
      ),
      floatingActionButton: (_activeCard == 1)
          ? (_activeCard == 2
                ? _buildChatFloatingButton(context)
                : SizedBox.shrink())
          : SizedBox.shrink(),
    );
  }

  void _resetFlightSelection({bool cleanupOnly = false}) {
    if (cleanupOnly) {
      _activeCard = 0;
      selectedFlightId = "";
      _isMapListViewShown = true;
      return;
    }

    if (mounted) {
      setState(() {
        _activeCard = 0;
        selectedFlightId = "";
        _isMapListViewShown = true;
      });

      _buildFlightMarkers(
        _mapCubit.state.isTracking && _mapCubit.state.selectedFlight != null
            ? [_mapCubit.state.selectedFlight!]
            : _mapCubit.state.flights ?? [],
        true,
      );
    }
  }

  void _sheetListener() {
    if (!_hasFetchedDetails && _sheetController.size > 0.15) {
      final flights = _mapCubit.state.flights ?? [];
      if (flights.isNotEmpty) {
        _hasFetchedDetails = true;
        final typeList = flights.map((f) => f.type).toList();
        final uniqueTypes = typeList.toSet().toList();
        _mapCubit.fetchAircraftDetailsFromFlightsList(uniqueTypes, context);
      }
    }
  }

  void _fetchFlightsWithDebounce(BoxConstraints constraints) {
    if (_mapController != null && _activeCard != 0) return;
    _hasFetchedDetails = false;
    _debounce?.cancel();
    _debounce = Timer(const Duration(seconds: 2), () async {
      if (!mounted) return;

      final visibleRegion = await _mapController!.getVisibleRegion();

      final screenCenter = ScreenCoordinate(
        x: (constraints.maxWidth ~/ 2),
        y: (constraints.maxHeight ~/ 2),
      );

      final LatLng centerLatLng = await _mapController!.getLatLng(screenCenter);
      _mapCubit.fetchFlightsByBounds(
        currentCenterLatLong: centerLatLng,
        bounds: visibleRegion,
        context: context,
        isNeedToRefresh: true,
      );
    });
  }

  void handleToggle(bool newIsMapViewSelected) {
    setState(() {
      isMapViewSelected = newIsMapViewSelected;
      if (!isMapViewSelected) _activeCard = 0;
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _safeAnimate(isMapViewSelected ? 0.01 : 0.78);
    });

    // _sheetController.animateTo(
    //   isMapViewSelected ? 0.0 : 0.78,
    //   duration: const Duration(milliseconds: 400),
    //   curve: Curves.easeInOut,
    // );
  }

  Future<void> _safeAnimate(double size) async {
    if (!mounted) return;
    if (!_sheetController.isAttached) return;

    try {
      await _sheetController.animateTo(
        size,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } catch (_) {
      debugPrint("_safeAnimate");
    }
  }

  void _showInitialTrackingModePopup(BuildContext context) {
    showModalBottomSheet(
      context: context,
      useRootNavigator: true,
      isDismissible: false,
      enableDrag: false,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return MapTrackingModePopup(
          onCrossButton: () {
            Navigator.pop(context);
            widget.onGoToFirstTab();
          },
          onFlyingSelected: () {
            setState(() {
              _singleSearchMarker = null;
              _isMapListViewShown = true;
              _isForFlyingInTheArea = 1;
              AnalyticsService.instance.buttonPressed(
                FirebaseEvents.flyingInTheAreaButton,
                FirebaseEvents.trackScreen,
              );
            });
            _resetFlightSelection();
            Navigator.pop(context);
          },
          onTrackSelected: () {
            setState(() {
              _activeCard = 0;
              _singleSearchMarker = null;
              _isMapListViewShown = false;
              _isForFlyingInTheArea = 2;
              AnalyticsService.instance.buttonPressed(
                FirebaseEvents.trackAFlightButton,
                FirebaseEvents.trackScreen,
              );
            });
            Navigator.pop(context);
            _handleTextTap(context);
          },
        );
      },
    );
  }

  void _toggleFlightCard({required String flight}) {
    _mapCubit.clearSelectedFlightDetail();
    _mapCubit.fetchFlightDetails(flightId: flight, context: context);
    setState(() {
      _activeCard = 0;
      _activeCard = 1;
    });
  }

  Future<Marker> _createMarker({
    required FlightModel flight,
    required Color color,
    required VoidCallback onTap,
    bool useCallSign = false,
  }) async {
    final icon = await getRotatedPlaneIcon(
      (flight.track).toDouble(),
      color: color,
    );

    return Marker(
      markerId: MarkerId(flight.id.toString()),
      position: LatLng(flight.latitude, flight.longitude),
      icon: icon,
      infoWindow: InfoWindow(
        title: useCallSign ? flight.callSign : flight.flightNumber,
        snippet: "${flight.departureIata} → ${flight.arrivalIata}",
      ),
      onTap: onTap,
    );
  }

  Future<Set<Marker>> _buildFlightMarkers(
    List<FlightModel> flights,
    bool isHideMapColour,
  ) async {
    final markers = <Marker>{};
    if (_isForFlyingInTheArea == 1) {
      for (final flight in flights) {
        final isSelected = selectedFlightId == flight.id;
        final marker = await _createMarker(
          flight: flight,
          color: isHideMapColour == true
              ? Colors.red
              : (isSelected ? Colors.orangeAccent : Colors.red),
          onTap: () {
            if (selectedFlightId != flight.id) {
              _isMapListViewShown = false;
              selectedFlightId = flight.id;
              _mapCubit.setSelectedFlight(flight);
              _toggleFlightCard(flight: flight.id);
            } else {
              _resetFlightSelection();
            }
          },
        );
        markers.add(marker);
      }
      final airportMarkers = await _buildAirportMarkers();
      markers.addAll(airportMarkers);
    }
    return markers;
  }

  double getIconSize(double currentZoom) {
    switch (currentZoom.floor()) {
      case 0:
      case 1:
      case 2:
      case 3:
      case 4:
        return kIsWeb ? 30 : 80;
      case 5:
      case 6:
      case 7:
        return kIsWeb ? 50 : 100;
      case 8:
      case 9:
      case 10:
        return kIsWeb ? 80 : 150;
      default:
        return kIsWeb ? 100 : 180;
    }
  }

  Future<Set<Marker>> _buildAirportMarkers() async {
    final markers = <Marker>{};

    // SAFETY GUARDS
    if (_mapController == null) return markers;

    final airports = _mapCubit.state.airports;
    if (airports == null || airports.isEmpty) return markers;

    double currentZoom;
    try {
      currentZoom = await _mapController!.getZoomLevel();
    } catch (_) {
      return markers;
    }

    final iconSize = getIconSize(currentZoom);

    final customIcon = await _getBitmapDescriptorFromSvgAsset(
      assetName: 'assets/svg_images/Airport1.svg',
      size: iconSize,
      color: Colors.blue,
    );

    for (final airport in airports) {
      // avoid bad backend data
      if (airport.latitude == null || airport.longitude == null) continue;

      markers.add(
        Marker(
          markerId: MarkerId(
            airport.iataCode ?? airport.icao ?? UniqueKey().toString(),
          ),
          position: LatLng(airport.latitude, airport.longitude),
          infoWindow: InfoWindow(
            title: airport.name ?? 'N/A',
            snippet: "${airport.city ?? ''}, ${airport.country ?? ''}",
          ),
          icon: customIcon,
          onTap: () {
            _isMapListViewShown = false;
            _mapCubit.setSelectedAirport(airport);
            _resetFlightSelection();
            setState(() {
              _isMapListViewShown = false;
              selectedSegmentIndex = 0;
              _activeCard = 2;
            });
          },
        ),
      );
    }
    return markers;
  }

  Future<BitmapDescriptor> _getBitmapDescriptorFromSvgAsset({
    required String assetName,
    required double size,
    Color? color,
  }) async {
    try {
      final pictureInfo = await vg.loadPicture(SvgAssetLoader(assetName), null);
      final scale = size / pictureInfo.size.width;
      final recorder = ui.PictureRecorder();
      final canvas = Canvas(recorder);
      canvas.scale(scale, scale);

      if (color != null) {
        final paint = Paint()
          ..colorFilter = ColorFilter.mode(color, BlendMode.srcIn);
        canvas.saveLayer(
          Rect.fromLTWH(0, 0, pictureInfo.size.width, pictureInfo.size.height),
          paint,
        );
        canvas.drawPicture(pictureInfo.picture);
        canvas.restore();
      } else {
        // Draw original svg
        canvas.drawPicture(pictureInfo.picture);
      }

      final picture = recorder.endRecording();
      final img = await picture.toImage(
        (pictureInfo.size.width * scale).round(),
        (pictureInfo.size.height * scale).round(),
      );

      final byteData = await img.toByteData(format: ui.ImageByteFormat.rawRgba);
      if (byteData == null) {
        return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue);
      }
      final pixels = byteData.buffer.asUint32List();

      int top = img.height, bottom = 0;
      for (int y = 0; y < img.height; y++) {
        for (int x = 0; x < img.width; x++) {
          if (pixels[y * img.width + x] != 0) {
            if (y < top) top = y;
            if (y > bottom) bottom = y;
          }
        }
      }

      if (bottom >= top) {
        final croppedHeight = bottom - top + 1;
        final recorder2 = ui.PictureRecorder();
        final canvas2 = Canvas(recorder2);
        final paint = Paint();
        canvas2.drawImageRect(
          img,
          Rect.fromLTWH(
            0,
            top.toDouble(),
            img.width.toDouble(),
            croppedHeight.toDouble(),
          ),
          Rect.fromLTWH(0, 0, img.width.toDouble(), croppedHeight.toDouble()),
          paint,
        );
        final cropped = await recorder2.endRecording().toImage(
          img.width,
          croppedHeight,
        );

        final croppedBytes = await cropped.toByteData(
          format: ui.ImageByteFormat.png,
        );
        return BitmapDescriptor.fromBytes(croppedBytes!.buffer.asUint8List());
      }

      // fallback if crop fails
      final pngBytes = await img.toByteData(format: ui.ImageByteFormat.png);
      return BitmapDescriptor.fromBytes(pngBytes!.buffer.asUint8List());
    } catch (e) {
      debugPrint('Error loading SVG------------------------------: $e');
      return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue);
    }
  }

  Future<Marker> _buildSingleFlightMarker(FlightModel flight) async {
    return _createMarker(
      flight: flight,
      color: Colors.blue,
      useCallSign: true,
      onTap: () {
        _mapCubit.setSelectedFlight(flight);
      },
    );
  }

  Future<void> _handleTextTap(BuildContext context) async {
    handleToggle(true);

    AnalyticsService.instance.buttonPressed(
      FirebaseEvents.trackAndSearchFlight,
      FirebaseEvents.trackScreen,
    );

    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider(
          create: (_) => MapSearchAircraftListCubit(),
          child: const TrackAndSearchFlight(),
        ),
      ),
    );

    if (result != null && result is FlightResult) {
      _mapController?.animateCamera(
        CameraUpdate.newLatLngZoom(
          LatLng(
            result.flightDetailResponse?.latitude ?? 0.0,
            result.flightDetailResponse?.longitude ?? 0.0,
          ),
          8, // Zoom level
        ),
      );

      setState(() {
        selectedFlightId = result.flightDetailResponse!.id;
        _isMapListViewShown = false;
      });

      _toggleFlightCard(flight: result.id);

      _buildSingleFlightMarker(result.flightDetailResponse!).then((marker) {
        setState(() {
          _singleSearchMarker = marker;
        });
      });

      Timer(const Duration(seconds: 2), () {
        if (!mounted) return;
        setState(() {
          _mapCubit.setSelectedFlight(result.flightDetailResponse!);
        });
      });
    }
  }

  Widget _buildFlightsDraggableSheet(
    BuildContext context,
    FlightMapState state,
  ) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: kIsWeb ? 400.0 : 0.0),
      child: DraggableScrollableSheet(
        controller: _sheetController,
        initialChildSize: 0.01,
        minChildSize: 0.01,
        maxChildSize: 0.75,
        snap: true,
        builder: (context, scrollController) {
          return Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: CustomScrollView(
              controller: scrollController,
              slivers: [
                SliverToBoxAdapter(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: Container(
                          height: 4,
                          width: 40,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade400,
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          children: [
                            Icon(Icons.radar, color: Colors.black, size: 30),
                            SizedBox(width: 8),
                            Text(
                              "Flights in the area",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final data = state.flights?[index];
                    if (data == null) return const SizedBox.shrink();

                    final aircraft = data.aircraftDetails;
                    final image = aircraft?.image ?? "";
                    final model = aircraft?.aircraftModel ?? "";
                    final icaoCode = aircraft?.icaoTypeCode ?? "";
                    final manufacturer =
                        aircraft?.manufacturer?.companyName ?? "";
                    final isFavorite = data.isFavorite ?? false;
                    final flightCode =
                        (data?.callSign != null && data!.callSign!.isNotEmpty)
                        ? data.callSign!
                        : "N/A";
                    final manufacturerLogo = aircraft?.manufacturer?.logo ?? "";

                    return SlidableAutoCloseBehavior(
                      child: Padding(
                        key: ValueKey(index),
                        padding: EdgeInsets.symmetric(
                          vertical: kIsWeb
                              ? MediaQuery.of(context).size.width * 0.005
                              : MediaQuery.of(context).size.width * 0.02,
                          horizontal: kIsWeb
                              ? MediaQuery.of(context).size.width * 0.15
                              : 15,
                        ),
                        child: Stack(
                          children: [
                            Positioned.fill(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: const Color(0xFFD2E6FC),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                alignment: Alignment.centerRight,
                                padding: const EdgeInsets.only(right: 15),
                                child: Icon(
                                  Icons.star,
                                  color: isFavorite
                                      ? Colors.black
                                      : Colors.white,
                                  size: kIsWeb ? 24 : 22,
                                ),
                              ),
                            ),
                            Slidable(
                              key: ValueKey(data.id),
                              closeOnScroll: true,
                              endActionPane: ActionPane(
                                motion: const BehindMotion(),
                                extentRatio: 0.15,
                                children: [
                                  CustomSlidableAction(
                                    onPressed: (_) async {
                                      if (aircraft == null || data.id == null) {
                                        debugPrint(
                                          "Aircraft or Flight data is null",
                                        );
                                        return;
                                      }

                                      AnalyticsService.instance.buttonPressed(
                                        FirebaseEvents.favOrUnFavFlightButton,
                                        FirebaseEvents.trackScreen,
                                      );

                                      final cubit = context
                                          .read<AllPlanesCubit>();
                                      await cubit.planFavOrUnfav1(
                                        aircraft.aircraftId.toString(),
                                        data.callSign,
                                        data.flightNumber.toString(),
                                        data.id.toString(),
                                        context,
                                      );

                                      context
                                          .read<FlightMapCubit>()
                                          .toggleFavoriteByCallSign(
                                            data.callSign,
                                          );

                                      AppSnackBar.custom(
                                        context,
                                        message: isFavorite
                                            ? "Airline Unfavorite"
                                            : "Airline Favorite",
                                        svgAsset: "",
                                      );
                                    },
                                    backgroundColor: Colors.transparent,
                                    child: const SizedBox.shrink(),
                                  ),
                                ],
                              ),
                              child: InkWell(
                                borderRadius: BorderRadius.circular(8),
                                onTap: () {
                                  _buildSingleFlightMarker(data).then((marker) {
                                    setState(() {
                                      isMapViewSelected = true;
                                      _isMapListViewShown = false;
                                      _singleSearchMarker = marker;
                                      selectedFlightId = data.id;
                                      _mapCubit.setSelectedFlight(data);
                                    });
                                  });

                                  _mapController?.animateCamera(
                                    CameraUpdate.newLatLngZoom(
                                      LatLng(data.latitude, data.longitude),
                                      8,
                                    ),
                                  );

                                  _toggleFlightCard(flight: data.id);
                                  WidgetsBinding.instance.addPostFrameCallback((
                                    _,
                                  ) {
                                    _safeAnimate(0.01);
                                  });

                                  // _sheetController.animateTo(
                                  //   0.0,
                                  //   duration: const Duration(milliseconds: 400),
                                  //   curve: Curves.easeInOut,
                                  // );
                                },

                                child: LayoutBuilder(
                                  builder: (context, constraints) {
                                    final isWide =
                                        constraints.maxWidth >
                                        600; // breakpoint

                                    return Container(
                                      clipBehavior: Clip.hardEdge,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(8),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withOpacity(
                                              0.08,
                                            ),
                                            blurRadius: 5,
                                            spreadRadius: 1,
                                            offset: const Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                      padding: EdgeInsets.all(isWide ? 14 : 10),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                              6,
                                            ),
                                            child: (image.isEmpty)
                                                ? Image.asset(
                                                    CommonUi.setPngImage(
                                                      AssetsPath
                                                          .aeroplaneComparison,
                                                    ),
                                                    width: isWide ? 120 : 90,
                                                    height: isWide ? 60 : 45,
                                                    fit: BoxFit.cover,
                                                  )
                                                : CachedAnyImage(
                                                    imagePath: image,
                                                    width: isWide ? 120 : 90,
                                                    height: isWide ? 60 : 45,
                                                    contentImage: BoxFit.cover,
                                                  ),
                                          ),
                                          const SizedBox(width: 10),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  children: [
                                                    Flexible(
                                                      child: Text(
                                                        model,
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          fontSize: isWide
                                                              ? 17
                                                              : 15,
                                                          color: const Color(
                                                            0xFF3F3D55,
                                                          ),
                                                        ),
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                    ),
                                                    const SizedBox(width: 6),
                                                    if (icaoCode.isNotEmpty)
                                                      Container(
                                                        padding:
                                                            const EdgeInsets.symmetric(
                                                              horizontal: 6,
                                                              vertical: 2,
                                                            ),
                                                        decoration: BoxDecoration(
                                                          color: Colors.white,
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                6,
                                                              ),
                                                          border: Border.all(
                                                            color: Colors
                                                                .grey
                                                                .shade300,
                                                          ),
                                                        ),
                                                        child: Text(
                                                          icaoCode,
                                                          style: TextStyle(
                                                            fontSize: isWide
                                                                ? 12
                                                                : 10,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          ),
                                                        ),
                                                      ),
                                                  ],
                                                ),
                                                const SizedBox(height: 6),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        ClipRRect(
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                4,
                                                              ),
                                                          child:
                                                              manufacturerLogo
                                                                  .isEmpty
                                                              ? SvgPicture.asset(
                                                                  CommonUi.setSvgImage(
                                                                    AssetsPath
                                                                        .manufacturer,
                                                                  ),
                                                                  width: isWide
                                                                      ? 26
                                                                      : 18,
                                                                  height: isWide
                                                                      ? 26
                                                                      : 18,
                                                                  fit: BoxFit
                                                                      .contain,
                                                                )
                                                              : CachedAnyImage(
                                                                  imagePath:
                                                                      manufacturerLogo,
                                                                  width: isWide
                                                                      ? 40
                                                                      : 28,
                                                                  height: isWide
                                                                      ? 20
                                                                      : 16,
                                                                  contentImage:
                                                                      BoxFit
                                                                          .contain,
                                                                  useCache:
                                                                      true,
                                                                ),
                                                        ),
                                                        const SizedBox(
                                                          width: 6,
                                                        ),
                                                        Text(
                                                          manufacturer,
                                                          style: TextStyle(
                                                            color: Colors.grey,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            fontSize: isWide
                                                                ? 14
                                                                : 12,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Container(
                                                      padding:
                                                          const EdgeInsets.symmetric(
                                                            horizontal: 8,
                                                            vertical: 4,
                                                          ),
                                                      decoration: BoxDecoration(
                                                        color: const Color(
                                                          0xFF3F3D55,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              6,
                                                            ),
                                                      ),
                                                      child: Text(
                                                        flightCode,
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: isWide
                                                              ? 13
                                                              : 11,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }, childCount: state.flights?.length ?? 0),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context, FlightMapState state) {
    return Positioned(
      top: kIsWeb ? 10 : 40,
      left: kIsWeb ? 100 : 5,
      right: kIsWeb ? 100 : 5,
      child: SearchBarWidget(
        enableGestureMode: true,
        onTextTap: () => _handleTextTap(context),
        enableBackArrow: _isForFlyingInTheArea != 0,
        // onBackButtonTap: () => _showInitialTrackingModePopup(context),
        onBackButtonTap: () {
          if (widget.skipInitialPopup && widget.openMode != null) {
            widget.onGoToFirstTab();
            Navigator.pop(context);
          } else {
            _showInitialTrackingModePopup(context);
          }
        },
        // enableFilter: _isMapListViewShown,
        enableFilter: _isForFlyingInTheArea != 2,
        enableCloseScreen: false,
        isComeFromMapSection: true,
        controller: _searchController,
        onFilterTap: () async {
          final currentMapType = _mapCubit.state.mapType;
          final currentCategories = _mapCubit.state.selectedCategories ?? [];
          final filterResult = await showModalBottomSheet<FilterResult>(
            context: context,
            isScrollControlled: true,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            backgroundColor: Colors.transparent,
            builder: (context) {
              return BlocProvider(
                create: (_) => FilterMapMainCubit()
                  ..setInitialMapType(currentMapType)
                  ..setInitialCategories(currentCategories),
                child: FractionallySizedBox(
                  heightFactor: 0.84,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                    child: FilterForMapScreen(
                      initialMapType: currentMapType,
                      initialCategories: currentCategories,
                    ),
                  ),
                ),
              );
            },
          );

          if (filterResult == null) return;

          AnalyticsService.instance.buttonPressed(
            FirebaseEvents.changeMapType,
            FirebaseEvents.trackScreen,
          );

          /* ---------------- MAP TYPE + POLYGON ---------------- */

          final bool shouldShowPolygon =
              filterResult.mapType == CustomMapType.polygon;

          // Only update if changed
          _selectedPolygonId = null;
          showPolygon = shouldShowPolygon;

          if (shouldShowPolygon) {
            cachedPolygons
              ..clear()
              ..addAll(
                _parsedPolygons
                    .expand((poly) => _buildPolygon(context, poly))
                    .toSet(),
              );

            polygonNotifier.value = cachedPolygons;
          } else {
            polygonNotifier.value = {};
          }

          // Change map type (NO API CALL)
          _mapCubit.changeMapType(filterResult.mapType);

          /* ---------------- FILTERS ---------------- */

          _mapCubit.setFilters(
            filterResult.categories,
            filterResult.aircraftIcaos,
          );

          debugPrint(
            "Applied Filters - Categories: ${filterResult.categories}, "
            "Aircraft ICAOs: ${filterResult.aircraftIcaos}",
          );

          /* ---------------- API CALL (SAFE) ---------------- */

          // Only fetch if map is ready
          if (_mapController == null) return;

          // ⏱️ Let map settle after style change
          Future.delayed(const Duration(milliseconds: 300), () async {
            try {
              if (!mounted) return;

              final visibleRegion = await _mapController!.getVisibleRegion();

              final size = MediaQuery.of(context).size;
              final screenCenter = ScreenCoordinate(
                x: (size.width / 2).round(),
                y: (size.height / 2).round(),
              );

              final centerLatLng = await _mapController!.getLatLng(
                screenCenter,
              );

              _mapCubit.fetchFlightsByBounds(
                isNeedToRefresh: true,
                bounds: visibleRegion,
                currentCenterLatLong: centerLatLng,
                context: context,
              );
            } catch (e) {
              debugPrint('Filter fetch skipped: $e');
            }
          });

          _activeCard = 0;
        },
        searchTitle: _isForFlyingInTheArea == 2
            ? 'Track a flight...'
            : 'Search Flight no.,CallSign',
      ),
    );
  }

  Widget _buildChatFloatingButton(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        FloatingActionButton(
          onPressed: () async {
            final prefs = await SharedPreferences.getInstance();
            final token = prefs.getString('UserAccessTokenKey');

            if (token != null && token.isNotEmpty) {
              AnalyticsService.instance.buttonPressed(
                FirebaseEvents.openAskWilcoChatButton,
                FirebaseEvents.trackScreen,
              );

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => AskWilcoScreen(
                    accessToken: token,
                    isComeFromTab: false,
                    sessionId: '',
                    title: '',
                  ),
                ),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Access token not found")),
              );
            }
          },
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: SvgPicture.asset(
            CommonUi.setSvgImage(AssetsPath.Chatbot),
            width: 100,
            height: 100,
            fit: BoxFit.cover,
          ),
        ),
      ],
    );
  }

  Widget _buildAnimatedFlightCard(BuildContext context) {
    return AnimatedPositioned(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      left: 0,
      right: 0,
      bottom: _activeCard == 1 ? 0 : -MediaQuery.of(context).size.height * 0.4,
      child: BlocBuilder<FlightMapCubit, FlightMapState>(
        builder: (context, state) {
          if (state.selectedFlightDetail == null) {
            return const SizedBox.shrink();
          }
          return FlightDetailCard(
            flightDetail: state.selectedFlightDetail,
            isComeFromLiveTracking: false,
            callBackForHideFlightCard: _resetFlightSelection,
            // fromDateTime: state.fromDateTime,
            // toDateTime: state.toDateTime,
          );
        },
      ),
    );
  }

  Widget _buildAnimatedAirportDetailsCard(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final cardHeight = screenHeight * 0.41;
    const segmentHeight = 48.0;

    return Stack(
      alignment: Alignment.bottomLeft,
      children: [
        AnimatedPositioned(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          left: kIsWeb ? 400.0 : 0.0,
          right: kIsWeb ? 400.0 : 0.0,
          bottom: _activeCard == 2 ? 0 : -cardHeight,
          child: SizedBox(
            height: cardHeight,
            child: BlocBuilder<FlightMapCubit, FlightMapState>(
              builder: (context, state) {
                if (state.selectedAirport == null) {
                  return const SizedBox.shrink();
                }

                return AirportStationDetailCard(
                  airportDetail: state.selectedAirport!,
                  isComeFromLiveTracking: false,
                  segmentIndex: selectedSegmentIndex,
                  callBackForHideFlightCard: () {
                    setState(() {
                      _isMapListViewShown = true;
                      _activeCard = 0;
                    });
                  },
                );
              },
            ),
          ),
        ),

        AnimatedPositioned(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          left: kIsWeb ? 400.0 : 0.0,
          right: kIsWeb ? 400.0 : MediaQuery.of(context).size.width / 3,

          bottom: _activeCard == 2 ? cardHeight : -cardHeight,
          child: SizedBox(
            width: 300,
            height: segmentHeight,
            child: CustomSegmentController(
              segments: ["Airport details", "More Details"],
              selectedIndex: selectedSegmentIndex,
              onChanged: (index) {
                setState(() {
                  selectedSegmentIndex = index;
                });
              },
            ),
          ),
        ),
      ],
    );
  }
}
