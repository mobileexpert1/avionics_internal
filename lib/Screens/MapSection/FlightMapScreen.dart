import 'dart:async';
import 'dart:ui' as ui;

import 'package:avionics_internal/bloc/MapSection/FilterMap/filter_Map_State.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Constants/ApiClass/ApiErrorModel.dart';
import '../../Constants/ApiClass/FirebaseAnalytics/analytics_service.dart';
import '../../Constants/ApiClass/FirebaseAnalytics/event_names.dart';
import '../../Constants/AppColors.dart';
import '../../Constants/constantImages.dart';
import '../../CustomFiles/CustomAppBar.dart';
import '../../CustomFiles/Custom_SnackBar.dart';
import '../../Helpers/AppNavigator.dart';
import '../../Helpers/AppTextStyles/AppTextStyles.dart';
import '../../Helpers/CacheManger/CachedImageFile.dart';
import '../../Helpers/CustomHeaderViewExpandable.dart';
import '../../Helpers/CustomSegmentController/CustomSegmentController.dart';
import '../../Helpers/MapSection/rotatePlane_icon.dart';
import '../../Helpers/SearchBarWidget.dart';
import '../../bloc/Home/AllPlanesBloc/AllPlanes_cubit.dart';
import '../../bloc/MapSection/FilterMap/filter_Map_Cubit.dart';
import '../../bloc/MapSection/MapSeacrhAircraftList/map_Search_Aircraft_List_Model.dart';
import '../../bloc/MapSection/MapSeacrhAircraftList/map_Search_Aircraft_List_cubit.dart';
import '../../bloc/MapSection/ParsedPolygon.dart';
import '../../bloc/MapSection/flight_Map_Cubit.dart';
import '../../bloc/MapSection/flight_map_model.dart';
import '../../bloc/MapSection/flight_map_state.dart';
import '../Home/AppBarFilterAndMapFilter/FilterForMapScreen.dart';
import '../Profile/SettingScreen/SettingScreen.dart';
import '../WilcoBoat/ChatBotScreen.dart';
import 'AirportStationDetailCard/AirportStationDetailCard.dart';
import 'FlightDetailCard/FlightDetailCard.dart';
import 'FlightGoogleMapWidget.dart';
import 'MapHelpers/MapToggleButtons.dart';
import 'MapHelpers/TrackAndSeacrhFlight.dart';

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
  State<FlightMapScreen> createState() => _FlightMapScreenState();
}

class _FlightMapScreenState extends State<FlightMapScreen> {
  FlightMapCubit get _mapCubit => context.read<FlightMapCubit>();

  Timer? _debounce;
  int _activeCard = 0;
  bool _hasTriggeredMapView = false;

  bool? isFirstTimeUserCome = true;
  bool _isProgrammaticMove = false;

  bool isMapViewSelected = true;
  bool _isMapListViewShown = true;

  String? selectedFlightId;

  bool _isUserGesture = true;
  int _isForFlyingInTheArea = 0;

  Marker? _singleSearchMarker;
  GoogleMapController? _mapController;

  bool showPolygon = false;
  String? _selectedPolygonId;
  List<ParsedPolygon> _parsedPolygons = [];
  final Set<Polygon> cachedPolygons = <Polygon>{};
  late final ValueNotifier<Set<Polygon>> polygonNotifier;

  int selectedSegmentIndex = 0;
  final Set<Circle> _circles = {};

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
            _isUserGesture = false;
            isFirstTimeUserCome = false;
            _handleFilterTap(context);

            AnalyticsService.instance.buttonPressed(
              FirebaseEvents.flyingInTheAreaButton,
              FirebaseEvents.trackScreen,
            );
          } else if (widget.openMode == 2) {
            setState(() {
              _activeCard = 0;
              _singleSearchMarker = null;
              _isMapListViewShown = false;
              _isForFlyingInTheArea = 2;
            });
            _handleTextTap(context);
          }
        }
        await _mapCubit.loadFavoritesFlights(context);
      }
    });

    _sheetController.addListener(_sheetListenerForChangeTheTap);
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

    _sheetController.removeListener(_sheetListenerForChangeTheTap);
    _searchController.dispose();
    _sheetController.dispose();
    PaintingBinding.instance.imageCache.clear();
    super.dispose();
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

  // ── STATE / LOGIC ──────────────────────────────────────────────────────────

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

  void _sheetListenerForChangeTheTap() {
    final currentSize = _sheetController.size;
    if (currentSize > 0.15) {
      _hasTriggeredMapView = false;
      return;
    }
    if (_hasTriggeredMapView) return;
    _hasTriggeredMapView = true;
    Future.delayed(const Duration(milliseconds: 300), () {
      if (!mounted) return;
      if (_sheetController.size < 0.15) {
        setState(() {
          isMapViewSelected = true;
          _activeCard = 0;
        });
      }
    });
  }

  void _sheetListener() {
    final flights = _mapCubit.state.flights ?? [];
    if (flights.isNotEmpty) {
      final typeList = flights.map((f) => f.type).toList();
      final callSignList = flights.map((f) => f.callSign).toList();
      _mapCubit.fetchAircraftDetailsFromFlightsList(
        typeList,
        callSignList,
        context,
      );
    }
  }

  void _fetchFlightsWithDebounce(
    BoxConstraints constraints,
    bool isComeFromFilterSection,
  ) {
    if (_activeCard != 0) return;
    if (_mapController == null) return;
    _debounce?.cancel();
    _debounce = Timer(const Duration(seconds: 2), () async {
      if (!mounted) return;

      final visibleRegion = await _mapController!.getVisibleRegion();

      final centerLatLng = LatLng(
        (visibleRegion.northeast.latitude + visibleRegion.southwest.latitude) /
            2,
        (visibleRegion.northeast.longitude +
                visibleRegion.southwest.longitude) /
            2,
      );

      _refreshMapData(
        centerLatLng: centerLatLng,
        bounds: visibleRegion,
        context: context,
        radiusNm: (_mapCubit.state.searchRadius ?? 0) > 0
            ? _mapCubit.state.searchRadius!
            : 5,
        numberOfFlight: (_mapCubit.state.numberOfFlights ?? 0) > 0
            ? _mapCubit.state.numberOfFlights!
            : 50,
        isComeFromFilterSection: isComeFromFilterSection,
      );
    });
  }

  Future<void> _refreshMapData({
    required LatLng centerLatLng,
    required LatLngBounds bounds,
    required BuildContext context,
    required int radiusNm,
    required int numberOfFlight,
    required bool isComeFromFilterSection,
  }) async {
    print("radiusNm-=-=$radiusNm");
    final radiusMeters = convertNmToMeters(radiusNm);

    print("radiusMeters-=-=$radiusMeters");

    final radiusBounds = getBoundsFromRadius(
      center: centerLatLng,
      radiusMeters: radiusMeters,
    );

    print("radiusBounds-=-=$radiusBounds");

    await updateSearchRadius(
      radiusNm: radiusNm,
      center: centerLatLng,
      numberOfFlight: numberOfFlight,
      isComeFromFilterSection: isComeFromFilterSection,
    );

    _mapCubit.fetchFlightsByBounds(
      currentCenterLatLong: centerLatLng,
      bounds: radiusBounds,
      context: context,
      flightLimit: numberOfFlight,
      radiusNm: radiusNm,
    );
  }

  Future<void> updateSearchRadius({
    required int radiusNm,
    required LatLng center,
    required int numberOfFlight,
    required bool isComeFromFilterSection,
  }) async {
    final controller = _mapController;
    if (controller == null) return;

    _isProgrammaticMove = true;

    final visualRadiusNm = radiusNm + getVisualRadiusBufferNm(radiusNm).toInt();
    final visualRadiusMeters = convertNmToMeters(visualRadiusNm);

    _circles.clear();
    _circles.add(
      Circle(
        circleId: const CircleId('radius_circle'),
        center: center,
        radius: visualRadiusMeters,
        strokeWidth: 2,
        strokeColor: Colors.blue,
        fillColor: Colors.blue.withValues(alpha: 0.2),
      ),
    );

    if (mounted) {
      setState(() {
        _isUserGesture = true;
        _mapCubit.updateTheNumberOfFlightAndRadius(
          numberOfFlight.toInt(),
          radiusNm.toInt(),
        );
      });
    }

    if (isComeFromFilterSection == false) return;

    await controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: center,
          zoom: getZoomLevelFromRadius(_mapCubit.state.searchRadius ?? 0),
        ),
      ),
    );
  }

  void handleToggle(bool newIsMapViewSelected) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _safeAnimate(isMapViewSelected ? 0.00 : 0.75);
    });

    setState(() {
      isMapViewSelected = newIsMapViewSelected;
      if (!isMapViewSelected) _activeCard = 0;
    });
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
      if (size > 0.0) {
        _sheetListener();
      }
    } catch (_) {
      debugPrint("_safeAnimate");
    }
  }

  // ── MARKERS ────────────────────────────────────────────────────────────────
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
        return kIsWeb ? 30 : 50;
      case 5:
      case 6:
      case 7:
        return kIsWeb ? 50 : 60;
      case 8:
      case 9:
      case 10:
        return kIsWeb ? 80 : 70;
      default:
        return 100;
    }
  }

  Future<Set<Marker>> _buildAirportMarkers() async {
    final markers = <Marker>{};

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
      assetName: CommonUi.setSvgImage(AssetsPath.airportIcon),
      size: iconSize,
      color: Colors.blue,
    );

    for (final airport in airports) {
      if (airport.latitude == null || airport.longitude == null) continue;
      markers.add(
        Marker(
          markerId: MarkerId(airport.iataCode),
          position: LatLng(airport.latitude, airport.longitude),
          infoWindow: InfoWindow(
            title: airport.name,
            snippet: "${airport.city}, ${airport.country}",
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
        return BitmapDescriptor.bytes(croppedBytes!.buffer.asUint8List());
      }

      final pngBytes = await img.toByteData(format: ui.ImageByteFormat.png);
      return BitmapDescriptor.bytes(pngBytes!.buffer.asUint8List());
    } catch (e) {
      debugPrint('Error loading SVG------------------------------: $e');
      return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue);
    }
  }

  // ── POLYGON ────────────────────────────────────────────────────────────────
  Set<Polygon> _buildPolygon(BuildContext context, dynamic p) {
    final Set<Polygon> polygons = {};
    final bool isSelected = _selectedPolygonId == p.id;

    int index = 0;

    for (final ring in p.polygons) {
      polygons.add(
        Polygon(
          polygonId: PolygonId('${p.id}_$index'),
          points: ring
              .map<LatLng>((e) => LatLng(e[1].clamp(-85.0, 85.0), e[0]))
              .toList(),

          strokeWidth: isSelected ? 2 : 1,
          strokeColor: isSelected ? Colors.purple : Colors.red,
          fillColor: isSelected
              ? Colors.yellow.withValues(alpha: 0.25)
              : Colors.transparent,

          consumeTapEvents: true,

          onTap: () {
            if (_mapCubit.state.mapType != CustomMapType.polygon) return;

            _selectedPolygonId = (_selectedPolygonId == p.id) ? null : p.id;

            final newPolygons = _parsedPolygons
                .expand((poly) => _buildPolygon(context, poly))
                .toSet();

            polygonNotifier.value = newPolygons;

            if (_selectedPolygonId != null) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(p.name)));
            }
          },
        ),
      );
      index++;
    }

    return polygons;
  }

  // ── USER INTERACTION ───────────────────────────────────────────────────────
  void _toggleFlightCard({required String flight}) {
    _mapCubit.clearSelectedFlightDetail();
    _mapCubit.fetchFlightDetails(flightId: flight, context: context);
    setState(() {
      _activeCard = 0;
      _activeCard = 1;
    });
  }

  Future<void> _handleTextTap(BuildContext context) async {
    handleToggle(true);

    AnalyticsService.instance.buttonPressed(
      FirebaseEvents.trackAndSearchFlight,
      FirebaseEvents.trackScreen,
    );

    final result = await AppNavigator.push(
      context,
      TrackAndSearchFlight(),
      multiBlocProviders: [
        BlocProvider(create: (_) => MapSearchAircraftListCubit()),
      ],
      disableSwipeBack: true,
    );

    if (result != null && result is FlightResult) {
      _isProgrammaticMove = true;

      _mapController?.animateCamera(
        CameraUpdate.newLatLngZoom(
          LatLng(
            result.flightDetailResponse?.latitude ?? 0.0,
            result.flightDetailResponse?.longitude ?? 0.0,
          ),
          8,
        ),
      );

      setState(() {
        selectedFlightId = result.flightDetailResponse!.id;
        _isMapListViewShown = false;
      });

      _mapCubit.submitFlightCreditApi(1, 8, context);

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

  void _showInitialTrackingModePopup(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final screenWidth = size.width;
    final screenHeight = size.height;

    showModalBottomSheet(
      context: context,
      useRootNavigator: false,
      isDismissible: false,
      enableDrag: false,
      isScrollControlled: kIsWeb ? true : false,
      backgroundColor: Colors.transparent,
      builder: (context) {
        Widget popupContent = Container(
          width: kIsWeb && screenWidth > 700 ? 650 : double.infinity,

          constraints: kIsWeb
              ? BoxConstraints(maxHeight: screenHeight * 0.9)
              : null,

          margin: kIsWeb ? const EdgeInsets.all(20) : EdgeInsets.zero,

          padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.04,
            vertical: 10,
          ),

          decoration: BoxDecoration(
            color: AppColors.greyForConversionScreen,
            borderRadius: BorderRadius.circular(5),
          ),

          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Center(
                      child: Text(
                        "Choose Your Tracking Mode",
                        style: AppTextStyles.bold(
                          18,
                        ).copyWith(height: 1.0, color: AppColors.black),
                      ),
                    ),
                  ),

                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      widget.onGoToFirstTab();
                    },
                    child: const Icon(
                      Icons.close,
                      color: Colors.black,
                      size: 30,
                    ),
                  ),
                ],
              ),

              SizedBox(height: kIsWeb ? 20 : screenWidth * 0.06),

              /// Flying in Area
              CustomHeaderViewExpandable(
                isNeedToShowLeftRightBottomBorder: false,
                isNeedToShowLeftImage: true,
                isExpanded: false,
                title: "Flying in the Area",
                headerColor: AppColors.primaryBlue,
                arrowBackgroundColor: AppColors.extraDarkYellow,
                arrowFrontColor: Colors.black,
                isExpandedViewAvailable: true,

                fontStyle: AppTextStyles.regular(18).copyWith(
                  height: 1.4,
                  color: AppColors.white,
                  letterSpacing: 0.2,
                ),

                isLeftImage: IconButton(
                  icon: SvgPicture.asset(
                    CommonUi.setSvgImage(AssetsPath.mapPopupAircraft),
                    width: 30,
                    height: 30,
                    fit: BoxFit.cover,
                    color: Colors.white,
                  ),
                  onPressed: () async {},
                ),

                onHeaderTap: () async {
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

                  isFirstTimeUserCome = false;

                  _handleFilterTap(context);
                },
              ),

              SizedBox(height: kIsWeb ? 8 : screenWidth * 0.02),

              Text(
                "Click to view flights currently flying in this area on the map",
                style: AppTextStyles.regular(
                  14,
                ).copyWith(height: 1.4, color: AppColors.textHomeColour),
                textAlign: TextAlign.start,
              ),

              SizedBox(height: kIsWeb ? 20 : screenWidth * 0.06),

              /// Track Flight
              CustomHeaderViewExpandable(
                isNeedToShowLeftRightBottomBorder: false,
                isNeedToShowLeftImage: true,
                isExpanded: false,
                title: "Track a Flight",
                headerColor: AppColors.primaryBlue,
                arrowBackgroundColor: AppColors.extraDarkYellow,
                arrowFrontColor: Colors.black,
                isExpandedViewAvailable: true,

                fontStyle: AppTextStyles.regular(18).copyWith(
                  height: 1.4,
                  color: AppColors.white,
                  letterSpacing: 0.2,
                ),

                isLeftImage: IconButton(
                  icon: SvgPicture.asset(
                    CommonUi.setSvgImage(AssetsPath.homeLiveTracking),
                    width: 30,
                    height: 30,
                    fit: BoxFit.cover,
                    color: Colors.white,
                  ),
                  onPressed: () async {},
                ),

                onHeaderTap: () async {
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
              ),

              SizedBox(height: kIsWeb ? 8 : screenWidth * 0.02),

              Text(
                "View real-time status, route, and updates for a flight",
                style: AppTextStyles.regular(
                  14,
                ).copyWith(height: 1.4, color: AppColors.textHomeColour),
                textAlign: TextAlign.start,
              ),

              SizedBox(height: kIsWeb ? 20 : screenWidth * 0.1),
            ],
          ),
        );

        /// WEB ONLY FIX
        if (kIsWeb) {
          return SafeArea(
            child: SingleChildScrollView(child: Center(child: popupContent)),
          );
        }

        /// MOBILE SAME AS BEFORE
        return popupContent;
      },
    );
  }

  // ── BUILD ──────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        isForHomeScreen: true,
        title: '',
        leftButton: widget.openMode == 1 || widget.openMode == 2
            ? IconButton(
                icon: SvgPicture.asset(
                  CommonUi.setSvgImage(AssetsPath.backArrowButton),
                  fit: BoxFit.cover,
                ),
                onPressed: () => Navigator.of(context).pop(),
              )
            : IconButton(
                icon: SvgPicture.asset(
                  CommonUi.setSvgImage(AssetsPath.homeLeftMainLogo),
                  width: 120,
                  height: 31,
                  fit: BoxFit.cover,
                ),
                onPressed: () {},
              ),
        rightButton: IconButton(
          icon: SvgPicture.asset(
            CommonUi.setSvgImage(AssetsPath.homeRightSetting),
            width: 35,
            height: 31,
            fit: BoxFit.cover,
          ),
          onPressed: () async {
            AppNavigator.push(context, SettingScreen(), disableSwipeBack: true);
          },
        ),
      ),
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
                            builder: (_, polygons, _) {
                              return FlightGoogleMapWidget(
                                isAlreadyFetchedTheKey: (value) {
                                  if (widget.openMode == null) {
                                    _showInitialTrackingModePopup(context);
                                  }
                                },

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

                                circles: _circles,

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
                                  debugPrint(
                                    "🔴 onCameraIdle — isProgrammatic: $_isProgrammaticMove, isUserGesture: $_isUserGesture",
                                  );

                                  if (_isProgrammaticMove) {
                                    _isProgrammaticMove = false;
                                    return;
                                  }

                                  if (!_isUserGesture) return;

                                  _isUserGesture = false;

                                  if (isFirstTimeUserCome == false) {
                                    _fetchFlightsWithDebounce(
                                      constraints,
                                      false,
                                    );
                                  }
                                },

                                onCameraMoveStarted: () {
                                  _isProgrammaticMove = false;
                                  _isUserGesture = true;
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
                      top: kIsWeb ? 100 : 65,
                      right: 10,
                      child: MapToggleButtons(
                        isMapViewSelected: isMapViewSelected,
                        onToggle: handleToggle,
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

  // ── WIDGET BUILDERS ────────────────────────────────────────────────────────
  Widget _buildSearchBar(BuildContext context, FlightMapState state) {
    return Positioned(
      top: kIsWeb ? 10 : 0,
      left: kIsWeb ? 100 : 0,
      right: kIsWeb ? 100 : 0,
      child: SearchBarWidget(
        enableGestureMode: true,
        onTextTap: () => _handleTextTap(context),
        enableBackArrow: false,
        onBackButtonTap: () => _handleBackButton(context),
        enableFilter: _isForFlyingInTheArea != 2,
        enableCloseScreen: false,
        isComeFromMapSection: true,
        controller: _searchController,
        onFilterTap: () => _handleFilterTap(context),
        searchTitle: _isForFlyingInTheArea == 2
            ? 'Track a flight...'
            : 'Search Flight no.,CallSign,...',
      ),
    );
  }

  void _handleBackButton(BuildContext context) {
    if (widget.skipInitialPopup && widget.openMode != null) {
      widget.onGoToFirstTab();
      Navigator.pop(context);
    } else {
      _showInitialTrackingModePopup(context);
    }
  }

  Future<void> _handleFilterTap(BuildContext context) async {
    final currentMapType = _mapCubit.state.mapType;
    final currentCategories = _mapCubit.state.selectedCategories ?? [];
    final currentNumberOfFlight = (_mapCubit.state.numberOfFlights ?? 0) > 0
        ? _mapCubit.state.numberOfFlights!
        : 1;
    final currentSearchRadius = (_mapCubit.state.searchRadius ?? 0) > 0
        ? _mapCubit.state.searchRadius!
        : 1;

    final filterResult = await showModalBottomSheet<FilterResult>(
      isDismissible: false,
      enableDrag: false,
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      backgroundColor: Colors.transparent,
      builder: (context) {
        return BlocProvider(
          create: (_) => FilterMapMainCubit()
            ..setInitialMapType(
              currentMapType,
              currentCategories,
              currentNumberOfFlight,
              currentSearchRadius,
            ),
          child: FractionallySizedBox(
            heightFactor: 0.8,
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(20),
              ),
              child: FilterForMapScreen(
                initialMapType: currentMapType,
                initialCategories: currentCategories,
                numberOfFlights: currentNumberOfFlight,
                searchRadius: currentSearchRadius,
                onTapBackButton: () {
                  _showInitialTrackingModePopup(context);
                },
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

    _mapCubit.changeMapType(filterResult.mapType);

    /* ---------------- FILTERS ---------------- */

    _mapCubit.setFilters(filterResult.categories, filterResult.aircraftIcaos);

    debugPrint(
      "Applied Filters - Categories: ${filterResult.categories}, "
      "aircraftIcaos: ${filterResult.aircraftIcaos}"
      "numberOfFlights : ${filterResult.numberOfFlights}"
      "searchRadius : ${filterResult.searchRadius}",
    );

    if (_mapController == null) return;

    Future.delayed(const Duration(milliseconds: 300), () async {
      try {
        if (!mounted) return;

        final controller = _mapController;

        if (controller == null) return;

        final visibleRegion = await controller.getVisibleRegion();
        final centerLatLng = getBoundsCenter(visibleRegion);
        await _refreshMapData(
          centerLatLng: centerLatLng,
          bounds: visibleRegion,
          context: context,
          numberOfFlight: filterResult.numberOfFlights.toInt(),
          radiusNm: filterResult.searchRadius.toInt(),
          isComeFromFilterSection: true,
        );
      } catch (e) {
        debugPrint('Filter fetch skipped: $e');
      }
    });
    _activeCard = 0;
  }

  Widget _buildFlightsDraggableSheet(
    BuildContext context,
    FlightMapState state,
  ) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: kIsWeb ? 400.0 : 0.0),
      child: DraggableScrollableSheet(
        controller: _sheetController,
        initialChildSize: 0.00,
        minChildSize: 0.00,
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
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Container(
                          height: 4,
                          width: 50,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade400,
                            borderRadius: BorderRadius.circular(10),
                          ),
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
                    final image = aircraft?.manufacturer?.airlineLogo ?? "";
                    final model = aircraft?.aircraftModel ?? "";
                    final icaoCode = aircraft?.icaoTypeCode ?? "";
                    final isFavorite = data.isFavorite;
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
                              : MediaQuery.of(context).size.width * 0.016,
                          horizontal: kIsWeb
                              ? MediaQuery.of(context).size.width * 0.15
                              : 15,
                        ),
                        child: Stack(
                          children: [
                            InkWell(
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

                                _isProgrammaticMove = true;

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
                              },
                              child: LayoutBuilder(
                                builder: (context, constraints) {
                                  final isWide = constraints.maxWidth > 600;
                                  return Container(
                                    clipBehavior: Clip.hardEdge,
                                    decoration: const BoxDecoration(
                                      color: Colors.white,
                                    ),
                                    padding: EdgeInsets.all(isWide ? 14 : 0),
                                    child: Column(
                                      children: [
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(6),
                                              child: (image.isEmpty)
                                                  ? Image.asset(
                                                      CommonUi.setPngImage(
                                                        AssetsPath
                                                            .comparisonPlaceholder,
                                                      ),
                                                      width: isWide ? 120 : 90,
                                                      height: isWide ? 60 : 45,
                                                      fit: BoxFit.cover,
                                                    )
                                                  : CachedAnyImage(
                                                      imagePath: image,
                                                      isForPlaneList: true,
                                                      width: isWide ? 120 : 70,
                                                      height: isWide ? 60 : 50,
                                                      contentImage:
                                                          BoxFit.contain,
                                                    ),
                                            ),
                                            const SizedBox(width: 10),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Expanded(
                                                        child: Wrap(
                                                          crossAxisAlignment:
                                                              WrapCrossAlignment
                                                                  .center,
                                                          spacing: 10,
                                                          runSpacing: 5,
                                                          children: [
                                                            Text(
                                                              model,
                                                              style:
                                                                  AppTextStyles.bold(
                                                                    16,
                                                                  ).copyWith(
                                                                    height: 1.4,
                                                                    color: AppColors
                                                                        .blackForNavTitle,
                                                                    letterSpacing:
                                                                        0.2,
                                                                  ),
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                            ),

                                                            if (icaoCode
                                                                .isNotEmpty)
                                                              Container(
                                                                padding:
                                                                    const EdgeInsets.symmetric(
                                                                      horizontal:
                                                                          6,
                                                                      vertical:
                                                                          3,
                                                                    ),
                                                                decoration: BoxDecoration(
                                                                  color: Colors
                                                                      .white,
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
                                                                  style:
                                                                      AppTextStyles.bold(
                                                                        16,
                                                                      ).copyWith(
                                                                        height:
                                                                            1.0,
                                                                        color: AppColors
                                                                            .textColour,
                                                                      ),
                                                                ),
                                                              ),
                                                          ],
                                                        ),
                                                      ),

                                                      GestureDetector(
                                                        onTap: () async {
                                                          if (aircraft ==
                                                              null) {
                                                            return;
                                                          }

                                                          AnalyticsService
                                                              .instance
                                                              .buttonPressed(
                                                                FirebaseEvents
                                                                    .favOrUnFavFlightButton,
                                                                FirebaseEvents
                                                                    .trackScreen,
                                                              );

                                                          final cubit = context
                                                              .read<
                                                                AllPlanesCubit
                                                              >();
                                                          await cubit
                                                              .planFavOrUnfav1(
                                                                aircraft
                                                                    .aircraftId
                                                                    .toString(),
                                                                data.callSign,
                                                                data.flightNumber
                                                                    .toString(),
                                                                data.id
                                                                    .toString(),
                                                                context,
                                                              );

                                                          context
                                                              .read<
                                                                FlightMapCubit
                                                              >()
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
                                                        child: SizedBox(
                                                          child: SvgPicture.asset(
                                                            CommonUi.setSvgImage(
                                                              isFavorite
                                                                  ? AssetsPath
                                                                        .highlightStar
                                                                  : AssetsPath
                                                                        .unHighlightStar,
                                                            ),
                                                            height: 23,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),

                                                  const SizedBox(height: 10),

                                                  // BOTTOM SECTION
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Expanded(
                                                        child: Row(
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
                                                                            .manufacturerPlaceholder,
                                                                      ),
                                                                      width:
                                                                          isWide
                                                                          ? 40
                                                                          : 30,
                                                                      height:
                                                                          isWide
                                                                          ? 26
                                                                          : 20,
                                                                      fit: BoxFit
                                                                          .contain,
                                                                    )
                                                                  : CachedAnyImage(
                                                                      imagePath:
                                                                          manufacturerLogo,
                                                                      width:
                                                                          isWide
                                                                          ? 40
                                                                          : 50,
                                                                      height:
                                                                          isWide
                                                                          ? 30
                                                                          : 20,
                                                                      contentImage:
                                                                          BoxFit
                                                                              .contain,
                                                                    ),
                                                            ),

                                                            const SizedBox(
                                                              width: 10,
                                                            ),

                                                            // Expanded(
                                                            //   child: Text(
                                                            //     manufacturer,
                                                            //     style:
                                                            //         AppTextStyles.regular(
                                                            //           14,
                                                            //         ).copyWith(
                                                            //           height:
                                                            //               1.0,
                                                            //           color: AppColors
                                                            //               .textColour,
                                                            //         ),
                                                            //     overflow:
                                                            //         TextOverflow
                                                            //             .ellipsis,
                                                            //   ),
                                                            // ),
                                                          ],
                                                        ),
                                                      ),

                                                      const SizedBox(width: 8),

                                                      /// FLIGHT CODE
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
                                                          style:
                                                              AppTextStyles.bold(
                                                                13,
                                                              ).copyWith(
                                                                height: 1.1,
                                                                color: AppColors
                                                                    .white,
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

                                        /// DIVIDER
                                        Padding(
                                          padding: const EdgeInsets.only(
                                            top: 10,
                                          ),
                                          child: Divider(
                                            height: 1,
                                            thickness: 1,
                                            color: Colors.grey.shade300,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
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
            isFavFlightByS: state.isFavFlightByS ?? false,
            isComeFromLiveTracking: false,
            callBackForHideFlightCard: _resetFlightSelection,
          );
        },
      ),
    );
  }

  Widget _buildAnimatedAirportDetailsCard(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final cardHeight = screenHeight * 0.32;
    const segmentHeight = 45.0;

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
          right: kIsWeb ? 540.0 : MediaQuery.of(context).size.width / 3.2,
          bottom: _activeCard == 2 ? cardHeight : -cardHeight,
          child: SizedBox(
            width: 400,
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

              AppNavigator.push(
                context,
                AskWilcoScreen(
                  accessToken: token,
                  isComeFromTab: false,
                  sessionId: '',
                  title: '',
                ),
                disableSwipeBack: true,
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
            CommonUi.setSvgImage(AssetsPath.homeWilco),
            width: 100,
            height: 100,
            fit: BoxFit.cover,
          ),
        ),
      ],
    );
  }
}
