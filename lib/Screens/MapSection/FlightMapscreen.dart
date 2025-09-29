import 'dart:async';
import 'dart:ui' as ui;
import '../../Helpers/Custom_widget.dart';
import '../../bloc/MapSection/AircraftStationList/aircraft_Station_List_Model.dart';
import 'FlightTrackScreen.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'MapHelpers/LiveBadge.dart';
import 'MapHelpers/MapToggleButtons.dart';
import '../../Helpers/CustomDivider.dart';
import '../../Helpers/SearchBarWidget.dart';
import '../../Constants/constantImages.dart';
import 'MapHelpers/MapTrackingModePopup.dart';
import 'MapHelpers/TrackAndSeacrhFlight.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../Helpers/SelectableAircraftCard.dart';
import '../../Constants/ApiClass/ApiErrorModel.dart';
import '../../bloc/MapSection/flight_map_model.dart';
import '../../bloc/MapSection/flight_map_state.dart';
import '../../bloc/MapSection/flight_Map_Cubit.dart';
import '../../Helpers/MapSection/rotatePlane_icon.dart';
import '../../Helpers/CacheManger/CachedImageFile.dart';
import '../../bloc/MapSection/flight_map_detailModel.dart';
import '../Home/HomeAirbus/ChatSection/ChatBotScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../bloc/MapSection/FilterMap/filter_Map_Cubit.dart';
import '../Home/AppBarFilterAndMapFilter/FilterForMapScreen.dart';
import '../../bloc/MapSection/MapSeacrhAircraftList/map_Search_Aircraft_List_Model.dart';
import '../../bloc/MapSection/MapSeacrhAircraftList/map_Search_Aircraft_List_cubit.dart';

class FlightMapScreen extends StatefulWidget {
  final VoidCallback onGoToFirstTab;

  const FlightMapScreen({required this.onGoToFirstTab, Key? key})
    : super(key: key);

  @override
  State<FlightMapScreen> createState() => _FlightMapscreenState();
}

class _FlightMapscreenState extends State<FlightMapScreen> {
  FlightMapCubit get _mapCubit => context.read<FlightMapCubit>();

  Timer? _debounce;
  int _activeCard = 0; // 0 = none, 1 = flight card, 2 = airport card

  bool isMapViewSelected = true;
  bool _isMapListViewShown = true;
  bool _hasFetchedDetails = false;

  String? selectedFlightId;

  int _isForFlyingInTheArea = 0;
  Marker? _singleSearchMarker;
  GoogleMapController? _mapController;

  late final TextEditingController _searchController = TextEditingController();
  late final DraggableScrollableController _sheetController =
      DraggableScrollableController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final hasPermission = await context
          .read<FlightMapCubit>()
          .getCurrentLocation(context);

      if (hasPermission) {
        _showInitialTrackingModePopup(context);
      }
    });

    _sheetController.addListener(_sheetListener);
  }

  @override
  void dispose() {
    _resetFlightSelection(cleanupOnly: true);
    _debounce?.cancel();
    _singleSearchMarker = null;
    _searchController.dispose();
    _mapController?.dispose();
    _sheetController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SizedBox.expand(
        child: BlocBuilder<FlightMapCubit, FlightMapState>(
          builder: (context, state) {
            if (state.isLoading) {
              return const Center(child: CircularProgressIndicator());
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
                          return GoogleMap(
                            minMaxZoomPreference: MinMaxZoomPreference(4, 10),
                            zoomControlsEnabled: false,
                            myLocationButtonEnabled: false,
                            rotateGesturesEnabled: false,
                            mapType: state.mapType,
                            initialCameraPosition: CameraPosition(
                              target: LatLng(
                                state.position!.latitude,
                                state.position!.longitude,
                              ),
                              zoom: 8,
                            ),
                            myLocationEnabled: true,
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
                            onCameraIdle: () async {
                              _fetchFlightsWithDebounce(constraints);
                            },
                            onMapCreated:
                                (GoogleMapController controller) async {
                                  _mapController = controller;
                                  if (state.isTracking &&
                                      state.selectedFlight != null) {
                                    _mapController!.animateCamera(
                                      CameraUpdate.newLatLng(
                                        LatLng(
                                          state.selectedFlight!.latitude,
                                          state.selectedFlight!.longitude,
                                        ),
                                      ),
                                    );
                                  }
                                },
                          );
                        },
                      );
                    },
                  ),

                  if (_isMapListViewShown)
                    Positioned(
                      top: 130,
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
      return;
    }

    if (mounted) {
      setState(() {
        _activeCard = 0;
        selectedFlightId = "";
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
      final visibleRegion = await _mapController!.getVisibleRegion();

      final screenCenter = ScreenCoordinate(
        x: (constraints.maxWidth ~/ 2),
        y: (constraints.maxHeight ~/ 2),
      );

      final LatLng centerLatLng = await _mapController!.getLatLng(screenCenter);

      print("_activeCard Api Calling-=-=-=-=-${_activeCard}");
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
    _sheetController.animateTo(
      isMapViewSelected ? 0.0 : 0.78,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
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
            });
            Navigator.pop(context);
            _handleTextTap(context);
          },
        );
      },
    );
  }

  void _toggleFlightCard({required String flight}) {
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

  Future<Set<Marker>> _buildAirportMarkers() async {
    final markers = <Marker>{};
    final airports = _mapCubit.state.airports;
    final customIcon = await _getBitmapDescriptorFromSvgAsset(
      assetName: 'assets/svg_images/Airport1.svg',
      size: 120,
      color: Colors.blue,
    );

    if (airports == null) return markers;

    for (final airport in airports) {
      final marker = Marker(
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
            _activeCard = 2;
          });
        },
      );
      markers.add(marker);
    }
    return markers;
  }

  Future<BitmapDescriptor> _getBitmapDescriptorFromSvgAsset({
    required String assetName,
    required double size,
    Color? color, // optional color parameter
  }) async {
    try {
      final pictureInfo = await vg.loadPicture(SvgAssetLoader(assetName), null);
      final scale = size / pictureInfo.size.width;
      final recorder = ui.PictureRecorder();
      final canvas = Canvas(recorder);
      canvas.scale(scale, scale);

      // If color is provided, apply it as a ColorFilter
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

      final byteData = await img.toByteData(format: ui.ImageByteFormat.png);
      final uint8List = byteData!.buffer.asUint8List();
      return BitmapDescriptor.fromBytes(uint8List);
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
    return DraggableScrollableSheet(
      controller: _sheetController,
      initialChildSize: 0.0,
      minChildSize: 0.0,
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
                  return Padding(
                    key: ValueKey(index),
                    padding: EdgeInsets.symmetric(
                      vertical: MediaQuery.of(context).size.width * 0.017,
                    ),
                    child: SimpleAircraftCard(
                      imagePath:
                          (data?.aircraftDetails?.image == null ||
                              data?.aircraftDetails?.image == ""
                          ? Image.asset(
                              CommonUi.setPngImage(
                                AssetsPath.aeroplaneComparison,
                              ),
                              width: 50,
                              height: 120,
                              fit: BoxFit.fill,
                            )
                          : CachedAnyImage(
                              imagePath: data!.aircraftDetails!.image,
                              width: 50,
                              height: 120,
                              contentImage: BoxFit.fill,
                            )),
                      model: "${data?.aircraftDetails?.aircraftModel ?? " "} ",
                      badge:
                          data?.aircraftDetails?.icaoTypeCode ??
                          data?.type ??
                          "",
                      manufacturer:
                          data?.aircraftDetails?.manufacturer?.companyName ??
                          "",
                      airline: "",
                      airlineImagePath:
                          (data?.aircraftDetails?.manufacturer?.logo == null ||
                              data?.aircraftDetails?.manufacturer?.logo == ""
                          ? SizedBox.shrink()
                          : CachedAnyImage(
                              imagePath:
                                  data?.aircraftDetails?.manufacturer?.logo ??
                                  "",
                              width: 50,
                              height: 120,
                              contentImage: BoxFit.fill,
                            )),
                      callSign: data?.callSign ?? "",
                      onTap: () {
                        _buildSingleFlightMarker(data!).then((marker) {
                          setState(() {
                            isMapViewSelected = true;
                            _isMapListViewShown = false;
                            _singleSearchMarker = marker;
                            selectedFlightId = data.id;
                            context.read<FlightMapCubit>().setSelectedFlight(
                              data,
                            );
                          });
                        });

                        _mapController?.animateCamera(
                          CameraUpdate.newLatLngZoom(
                            LatLng(data.latitude, data.longitude),
                            8,
                          ),
                        );

                        _toggleFlightCard(flight: data.id);

                        _sheetController.animateTo(
                          0.0,
                          duration: const Duration(milliseconds: 400),
                          curve: Curves.easeInOut,
                        );
                      },
                    ),
                  );
                }, childCount: state.flights?.length),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSearchBar(BuildContext context, FlightMapState state) {
    return Positioned(
      top: 40,
      left: 5,
      right: 5,
      child: SearchBarWidget(
        enableGestureMode: true,
        onTextTap: () => _handleTextTap(context),
        enableBackArrow: _isForFlyingInTheArea != 0,
        onBackButtonTap: () => _showInitialTrackingModePopup(context),
        enableFilter: _isMapListViewShown,
        enableCloseScreen: false,
        isComeFromMapSection: true,
        controller: _searchController,
        onFilterTap: () async {
          final selectedMapTypes = await showModalBottomSheet<MapType>(
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
                    context.read<FlightMapCubit>().state.mapType,
                  ),
                child: FractionallySizedBox(
                  heightFactor: 0.84,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                    child: FilterForMapScreen(initialMapType: state.mapType),
                  ),
                ),
              );
            },
          );

          if (selectedMapTypes != null) {
            _mapCubit.changeMapType(selectedMapTypes);
          }
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
          return FlightCard(
            flightDetail: state.selectedFlightDetail,
            isComeFromLiveTracking: false,
            callBackForHideFlightCard: () {
              _resetFlightSelection();
            },
            // fromDateTime: state.fromDateTime,
            // toDateTime: state.toDateTime,
          );
        },
      ),
    );
  }

  Widget _buildAnimatedAirportDetailsCard(BuildContext context) {
    return AnimatedPositioned(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      left: 0,
      right: 0,
      bottom: _activeCard == 2 ? 0 : -MediaQuery.of(context).size.height * 0.4,
      child: BlocBuilder<FlightMapCubit, FlightMapState>(
        builder: (context, state) {
          if (state.selectedAirport == null) {
            return const SizedBox.shrink();
          }

          return AirportStationCard(
            airportDetail: state.selectedAirport!,
            isComeFromLiveTracking: false,
            callBackForHideFlightCard: () {
              setState(() {
                _activeCard = 0;
              });
            },
          );
        },
      ),
    );
  }
}

class FlightCard extends StatelessWidget {
  final FlightAircraftDetail? flightDetail;
  final bool? isComeFromLiveTracking;
  final VoidCallback? callBackForHideFlightCard;

  const FlightCard({
    super.key,
    this.callBackForHideFlightCard,
    this.flightDetail,
    this.isComeFromLiveTracking,
  });

  String _formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    if (hours == 0 && minutes == 0) {
      return '0 min';
    } else if (hours == 0) {
      return '$minutes min';
    } else if (minutes == 0) {
      return '$hours h';
    } else {
      return '${hours}h ${minutes}min';
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FlightMapCubit, FlightMapState>(
      builder: (context, state) {
        final selectedFlight = state.selectedFlight;
        final detail = flightDetail;

        if (selectedFlight == null && detail == null) {
          return const Text('No flight selected');
        }

        final groundSpeed =
            detail?.groundSpeed ?? selectedFlight?.groundSpeed ?? 0;
        final altitude = detail?.altitude ?? selectedFlight?.altitude ?? 0;
        final eta = detail?.eta ?? selectedFlight?.eta;
        final takeoffTime = detail?.takeoffTime;

        final aircraftType = detail?.aircraftModel ?? 'N/A';
        final manufacturer = detail?.manufacturer?.companyName ?? "N/A";
        final category = detail?.icaoTypeCode ?? detail?.type ?? "";
        final image = detail?.image ?? "";
        final manufacturerLogo = detail?.manufacturer?.logo ?? "";
        final callSign = detail?.callsign ?? selectedFlight?.callSign ?? 'N/A';
        final departureIata = detail?.departureIcao ?? 'N/A';
        final arrivalIata = detail?.arrivalIcao ?? 'N/A';
        final flightNumber =
            selectedFlight?.flightNumber ?? detail?.flightNumber ?? '';

        final flightId = selectedFlight?.id ?? detail?.id ?? '';

        String timeSinceTakeoff = 'N/A';

        if (takeoffTime != null) {
          final duration = DateTime.now().toUtc().difference(takeoffTime);
          timeSinceTakeoff = '${_formatDuration(duration)} ago';
        }

        String timeToArrival = 'N/A';
        if (eta != null) {
          final duration = eta.difference(DateTime.now().toUtc());
          timeToArrival = duration.isNegative
              ? 'Landed'
              : 'in ${_formatDuration(duration)}';
        }

        double progress = 0.0;

        if (takeoffTime != null && eta != null) {
          final takeoffMillis = takeoffTime.millisecondsSinceEpoch;
          final etaMillis = eta.millisecondsSinceEpoch;
          final nowMillis = DateTime.now().toUtc().millisecondsSinceEpoch;

          final totalDuration = etaMillis - takeoffMillis;
          final elapsed = nowMillis - takeoffMillis;

          if (totalDuration > 0) {
            progress = (elapsed / totalDuration).clamp(0.0, 1.0);
          }
        }

        final departureCity = detail?.originAirport?.city ?? 'N/A';
        final arrivalCity = detail?.destinationAirport?.city ?? 'N/A';

        return GestureDetector(
          onTap: callBackForHideFlightCard,
          child: Card(
            color: Colors.white,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
            ),
            elevation: 10,
            margin: EdgeInsets.zero,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  aircraftType,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF3F3D56),
                                  ),
                                ),
                                const SizedBox(width: 25),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 6,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    category,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xFF3F3D56),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Wrap(
                              crossAxisAlignment: WrapCrossAlignment.center,
                              spacing: 8,
                              runSpacing: 8,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(6),
                                  child: manufacturerLogo.isEmpty
                                      ? SvgPicture.asset(
                                          CommonUi.setSvgImage(
                                            AssetsPath.manufacturer,
                                          ),
                                          width: 22,
                                          height: 16,
                                          fit: BoxFit.fill,
                                        )
                                      : CachedAnyImage(
                                          imagePath: manufacturerLogo,
                                          width: 22,
                                          height: 16,
                                          contentImage: BoxFit.contain,
                                          useCache: false,
                                        ),
                                ),
                                Text(
                                  manufacturer,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: Color(0xFF3F3D56),
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),

                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    // CallSign Box
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 18,
                                        vertical: 3,
                                      ),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF3F3D56),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Text(
                                        callSign,
                                        style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    InkWell(
                                      borderRadius: BorderRadius.circular(6),
                                      onTap: () {
                                        if (isComeFromLiveTracking == true) {
                                          context
                                              .read<FlightMapCubit>()
                                              .stopTrackingFlight();
                                          Navigator.pop(context, flightId);
                                        } else {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (_) =>
                                                  BlocProvider.value(
                                                    value: context
                                                        .read<FlightMapCubit>(),
                                                    child: TrackFlightScreen(
                                                      flightNumber:
                                                          flightNumber,
                                                      initialFlight:
                                                          selectedFlight,
                                                      initialFlightDetail:
                                                          detail,
                                                      flightId: flightId,
                                                    ),
                                                  ),
                                            ),
                                          );
                                        }
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(4),
                                        child: state.isTracking
                                            ? const LiveBadge()
                                            : const Icon(
                                                Icons.my_location,
                                                color: Colors.blue,
                                                size: 20,
                                              ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: (manufacturerLogo == ""
                            ? Image.asset(
                                CommonUi.setPngImage(
                                  AssetsPath.aeroplaneComparison,
                                ),
                                width: 100,
                                height: 50,
                                fit: BoxFit.fill,
                              )
                            : CachedAnyImage(
                                imagePath: image,
                                width: 100,
                                height: 50,
                                contentImage: BoxFit.fill,
                                useCache: false,
                              )),
                      ),
                    ],
                  ),
                  const CustomDivider(height: 1.0),
                  const SizedBox(height: 16),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        flex: 2,
                        child: Text(
                          "$departureCity\n$departureIata\n$timeSinceTakeoff",
                          style: const TextStyle(fontSize: 13),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Column(
                          children: [
                            LinearProgressIndicator(
                              value: progress,
                              backgroundColor: Colors.grey.shade300,
                              color: Colors.blue,
                              minHeight: 5,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            const SizedBox(height: 6),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  groundSpeed == 0
                                      ? 'N/A'
                                      : '$groundSpeed km/h',
                                  style: const TextStyle(
                                    color: Colors.blue,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                const Text(
                                  "•",
                                  style: TextStyle(color: Colors.grey),
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  altitude == 0 ? 'N/A' : '$altitude m',
                                  style: const TextStyle(
                                    color: Colors.blue,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          "$arrivalCity\n$arrivalIata\n$timeToArrival",
                          style: const TextStyle(fontSize: 13),
                          textAlign: TextAlign.right,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class AirportStationCard extends StatelessWidget {
  final AircraftStationModel? airportDetail;
  final bool? isComeFromLiveTracking;
  final VoidCallback? callBackForHideFlightCard;

  const AirportStationCard({
    super.key,
    this.callBackForHideFlightCard,
    this.airportDetail,
    this.isComeFromLiveTracking,
  });

  @override
  Widget build(BuildContext context) {
    final detail = airportDetail;
    if (detail == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return GestureDetector(
      onTap: callBackForHideFlightCard,
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
              offset: Offset(0, -2), // slight shadow above
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [Text("Airport Details")],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: customField(label: 'Name', text: detail.name),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: customField(label: 'City', text: detail.city),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: customField(label: 'State', text: detail.state),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: customField(label: 'Country', text: detail.country),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: customField(label: 'Runway', text: detail.type),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: customField(
                      label: 'Length(m)',
                      text: detail.runwayLength.toString(),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: customField(
                      label: 'ICAO Code',
                      text: detail.iataCode,
                    ),
                  ),
                  const SizedBox(width: 12),
                  if (detail.elev.toString() != "")
                    Expanded(
                      child: customField(
                        label: 'Elevation(m)',
                        text: detail.elev.toString(),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}
