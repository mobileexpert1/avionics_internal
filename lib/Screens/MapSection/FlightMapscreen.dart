import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Constants/ApiClass/ApiErrorModel.dart';
import '../../Constants/constantImages.dart';
import '../../Helpers/CacheManger/CachedImageFile.dart';
import '../../Helpers/CustomDivider.dart';
import '../../Helpers/MapSection/rotatePlane_icon.dart';
import '../../Helpers/SearchBarWidget.dart';
import '../../Helpers/SelectableAircraftCard.dart';
import '../../bloc/MapSection/flight_Map_Cubit.dart';
import '../../bloc/MapSection/flight_map_detailModel.dart';
import '../../bloc/MapSection/flight_map_model.dart';
import '../../bloc/MapSection/flight_map_state.dart';
import '../Home/AppBarFilterAndMapFilter/FilterForMapScreen.dart';
import '../Home/HomeAirbus/ChatSection/ChatBotScreen.dart';
import 'MapHelpers/MapToggleButtons.dart';
import 'MapHelpers/MapTrackingModePopup.dart';
import 'MapHelpers/TrackAndSeacrhFlight.dart';

class FlightMapScreen extends StatefulWidget {
  final VoidCallback onGoToFirstTab;

  const FlightMapScreen({required this.onGoToFirstTab, Key? key})
    : super(key: key);

  @override
  State<FlightMapScreen> createState() => _FlightMapscreenState();
}

class _FlightMapscreenState extends State<FlightMapScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _showFlightCard = false;
  GoogleMapController? _mapController;
  FlightModel? selectedFlight;
  bool _hasFetchedDetails = false;
  int _isForFlyingInTheArea = 0;
  bool isMapViewSelected = true;
  bool _isMapListViewShown = true;
  bool _isNeedToShowBackButton = false;

  final DraggableScrollableController _sheetController =
      DraggableScrollableController();

  @override
  void initState() {
    super.initState();
    context.read<FlightMapCubit>().getCurrentLocation(context);

    //Listen to sheet drag
    _sheetController.addListener(() {
      if (!_hasFetchedDetails && _sheetController.size > 0.15) {
        final flights = context.read<FlightMapCubit>().state.flights ?? [];
        if (flights.isNotEmpty) {
          _hasFetchedDetails = true;
          final typeList = flights.map((f) => f.type).toList();
          final uniqueTypes = typeList.toSet().toList();
          context.read<FlightMapCubit>().fetchAircraftDetailsFromFlightsList(
            uniqueTypes,
          );
        }
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showTrackingModePopup(context);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _mapController?.dispose();
    super.dispose();
  }

  void handleToggle(bool newIsMapViewSelected) {
    setState(() {
      isMapViewSelected = newIsMapViewSelected;
    });
    _sheetController.animateTo(
      isMapViewSelected == true ? 0.0 : 0.78,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
  }

  void _showTrackingModePopup(BuildContext context) {
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
              _hideFlightCard();
              _isMapListViewShown = true;
              _isNeedToShowBackButton = true;
              _isForFlyingInTheArea = 1;
            });
            Navigator.pop(context);
          },
          onTrackSelected: () {
            setState(() {
              _hideFlightCard();
              _isMapListViewShown = false;
              _isNeedToShowBackButton = true;
              _isForFlyingInTheArea = 2;
            });
            Navigator.pop(context);
          },
        );
      },
    );
  }

  void _toggleFlightCard({required FlightModel flight}) {
    context.read<FlightMapCubit>().fetchFlightDetails(
      flightId: flight.id,
      context: context,
    );
    setState(() {
      _showFlightCard = true;
    });
  }

  void _hideFlightCard() {
    setState(() {
      _showFlightCard = false;
    });
  }

  Future<Set<Marker>> _buildFlightMarkers(List<FlightModel> flights) async {
    final markers = <Marker>{};

    if (_isForFlyingInTheArea == 1) {
      for (final flight in flights) {
        final icon = await getRotatedPlaneIcon(
          (flight.track).toDouble(),
          color: Colors.red,
        );

        markers.add(
          Marker(
            markerId: MarkerId(flight.id.toString()),
            position: LatLng(flight.latitude, flight.longitude),
            icon: icon,
            infoWindow: InfoWindow(
              title: flight.flightNumber ?? 'Unknown',
              snippet:
                  "${flight.departureIata ?? 'N/A'} → ${flight.arrivalIata ?? 'N/A'}",
            ),
            onTap: () {
              print(
                "Flight: ${flight.flightNumber}\n"
                "Lat: ${flight.latitude}, Lon: ${flight.longitude}\n"
                "Dir: ${flight.track}°\n"
                "From: ${flight.departureIata} → To: ${flight.arrivalIata}",
              );
              _isMapListViewShown = false;
              context.read<FlightMapCubit>().setSelectedFlight(flight);
              _toggleFlightCard(flight: flight);
            },
          ),
        );
      }
    }
    return markers;
  }

  void _fitMapToBounds(List<FlightModel> flights, LatLng currentLatLng) {
    if (flights.isEmpty || _mapController == null) {
      print(
        'No flights or map controller not ready, skipping bounds adjustment',
      );
      return;
    }

    final latLngBounds = LatLngBounds(
      southwest: LatLng(
        [
          currentLatLng.latitude,
          ...flights.map((f) => f.latitude),
        ].reduce((a, b) => a < b ? a : b),
        [
          currentLatLng.longitude,
          ...flights.map((f) => f.longitude),
        ].reduce((a, b) => a < b ? a : b),
      ),
      northeast: LatLng(
        [
          currentLatLng.latitude,
          ...flights.map((f) => f.latitude),
        ].reduce((a, b) => a > b ? a : b),
        [
          currentLatLng.longitude,
          ...flights.map((f) => f.longitude),
        ].reduce((a, b) => a > b ? a : b),
      ),
    );

    _mapController!.animateCamera(
      CameraUpdate.newLatLngBounds(latLngBounds, 50),
    );
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
              final position = state.position!;
              final currentLatLng = LatLng(
                position.latitude,
                position.longitude,
              );
              print(
                'Current location: $currentLatLng, Flights: ${state.flights?.length ?? 0}',
              );

              return Stack(
                fit: StackFit.expand,
                children: [
                  FutureBuilder<Set<Marker>>(
                    future: _buildFlightMarkers(state.flights ?? []),
                    builder: (context, snapshot) {
                      return GoogleMap(
                        mapType: state.mapType,
                        initialCameraPosition: CameraPosition(
                          target: currentLatLng,
                          zoom: 8,
                        ),
                        myLocationEnabled: true,
                        markers: {
                          Marker(
                            markerId: const MarkerId("current"),
                            position: currentLatLng,
                            infoWindow: const InfoWindow(title: "You are here"),
                          ),
                          if (snapshot.hasData) ...snapshot.data!,
                        },
                        onMapCreated: (GoogleMapController controller) {
                          _mapController = controller;
                          if (state.flights != null) {
                            _fitMapToBounds(state.flights!, currentLatLng);
                          }
                        },
                      );
                    },
                  ),
                  if (_isMapListViewShown)
                    Positioned(
                      top: 120,
                      right: 30,
                      child: MapToggleButtons(
                        isMapViewSelected: isMapViewSelected,
                        onToggle: handleToggle, // Passing the callback function
                      ),
                    ),

                  Positioned(
                    top: 40,
                    left: 5,
                    right: 5,
                    child: SearchBarWidget(
                      enableGestureMode: true,
                      onTextTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => TrackAndSearchFlight(),
                          ),
                        );
                      },
                      enableBackArrow: _isNeedToShowBackButton,
                      onBackButtonTap: () {
                        _showTrackingModePopup(context);
                      },
                      enableFilter: _isMapListViewShown == false ? false : true,
                      enableCloseScreen: false,
                      isComeFromMapSection: true,
                      controller: _searchController,
                      onFilterTap: () async {
                        final selectedMapTypes =
                            await showModalBottomSheet<MapType>(
                              context: context,
                              isScrollControlled: true,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(20),
                                ),
                              ),
                              backgroundColor: Colors.transparent,
                              builder: (context) {
                                return FractionallySizedBox(
                                  heightFactor: 0.84,
                                  child: ClipRRect(
                                    borderRadius: const BorderRadius.vertical(
                                      top: Radius.circular(20),
                                    ),
                                    child: FilterForMapScreen(
                                      initialMapType: context
                                          .read<FlightMapCubit>()
                                          .state
                                          .mapType,
                                    ),
                                  ),
                                );
                              },
                            );
                        if (selectedMapTypes != null) {
                          context.read<FlightMapCubit>().changeMapType(
                            selectedMapTypes,
                          );
                        }
                        _hideFlightCard();
                      },
                      searchTitle: _isForFlyingInTheArea == 2
                          ? 'Track a flight...'
                          : 'Search...',
                    ),
                  ),
                  DraggableScrollableSheet(
                    controller: _sheetController,
                    initialChildSize: 0.0,
                    minChildSize: 0.0,
                    maxChildSize: 0.78,
                    snap: true,
                    builder: (context, scrollController) {
                      return Container(
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(20),
                          ),
                        ),
                        child: CustomScrollView(
                          controller: scrollController,
                          slivers: [
                            SliverToBoxAdapter(
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 12,
                                    ),
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
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 16,
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.radar,
                                          color: Colors.black,
                                          size: 30,
                                        ),
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
                              delegate: SliverChildBuilderDelegate((
                                context,
                                index,
                              ) {
                                final data = state.flights?[index];
                                return Padding(
                                  key: ValueKey(index),
                                  padding: EdgeInsets.symmetric(
                                    vertical:
                                        MediaQuery.of(context).size.width *
                                        0.017,
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
                                            imagePath:
                                                data!.aircraftDetails!.image,
                                            width: 50,
                                            height: 120,
                                            contentImage: BoxFit.fill,
                                          )),

                                    model:
                                        "${data?.aircraftDetails?.aircraftModel ?? " "} ",
                                    badge:
                                        data?.aircraftDetails?.icaoTypeCode ??
                                        data?.type ??
                                        "",
                                    manufacturer:
                                        data
                                            ?.aircraftDetails
                                            ?.manufacturer
                                            ?.companyName ??
                                        "",
                                    airline: "",
                                    airlineImagePath:
                                        (data
                                                    ?.aircraftDetails
                                                    ?.manufacturer
                                                    ?.logo ==
                                                null ||
                                            data
                                                    ?.aircraftDetails
                                                    ?.manufacturer
                                                    ?.logo ==
                                                ""
                                        ? SizedBox.shrink()
                                        : CachedAnyImage(
                                            imagePath:
                                                data
                                                    ?.aircraftDetails
                                                    ?.manufacturer
                                                    ?.logo ??
                                                "",
                                            width: 50,
                                            height: 120,
                                            contentImage: BoxFit.fill,
                                          )),
                                    callSign: data?.callSign ?? "",
                                    onTap: () {
                                      setState(() {
                                        _isMapListViewShown = false;
                                      });

                                      context
                                          .read<FlightMapCubit>()
                                          .setSelectedFlight(data!);
                                      _toggleFlightCard(flight: data!);

                                      _sheetController.animateTo(
                                        0.0,
                                        duration: const Duration(
                                          milliseconds: 400,
                                        ),
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
                  ),
                  if (state.selectedFlightDetail != null)
                    AnimatedPositioned(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      left: 0,
                      right: 0,
                      bottom: _showFlightCard
                          ? 0
                          : -MediaQuery.of(context).size.height * 0.4,
                      child: BlocBuilder<FlightMapCubit, FlightMapState>(
                        builder: (context, state) {
                          return FlightCard(
                            flightDetail: state.selectedFlightDetail,
                            // fromDateTime: state.fromDateTime,
                            // toDateTime: state.toDateTime,
                          );
                        },
                      ),
                    ),
                ],
              );
            }
            return const Center(child: Text('Fetching your location...'));
          },
        ),
      ),
      floatingActionButton: _showFlightCard == false
          ? Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  margin: EdgeInsets.only(bottom: 70),
                  child: FloatingActionButton(
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
                          const SnackBar(
                            content: Text("Access token not found"),
                          ),
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
                ),
              ],
            )
          : SizedBox.shrink(),
    );
  }
}

class FlightCard extends StatelessWidget {
  final FlightAircraftDetail? flightDetail;

  const FlightCard({super.key, this.flightDetail});

  String _formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    if (hours == 0 && minutes == 0) {
      return '0min';
    } else if (hours == 0) {
      return '${minutes}min';
    } else if (minutes == 0) {
      return '${hours}h';
    } else {
      return '${hours}h${minutes}min';
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
            selectedFlight?.groundSpeed ?? detail?.groundSpeed ?? 0;
        final altitude = selectedFlight?.altitude ?? detail?.altitude ?? 0;
        final eta = selectedFlight?.eta;
        final takeoffTime = detail?.takeoffTime;

        final aircraftType =
            detail?.aircraftModel ?? selectedFlight?.type ?? 'N/A';
        final manufacturer = detail?.manufacturer?.companyName ?? 'Unknown';
        final category = detail?.icaoTypeCode ?? selectedFlight?.type ?? 'N/A';
        final image = detail?.image ?? 'https://via.placeholder.com/50';
        final manufacturerLogo =
            detail?.manufacturer?.logo ?? 'https://via.placeholder.com/16';
        final callsign = selectedFlight?.callSign ?? detail?.callsign ?? 'N/A';

        final departureIata = detail?.departureIcao ?? 'N/A';
        final arrivalIata = detail?.arrivalIcao ?? 'N/A';

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

        return Card(
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
                          Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(4),
                                child: CachedAnyImage(
                                  imagePath: manufacturerLogo,
                                  width: 22.0,
                                  height: 16.0,
                                  contentImage: BoxFit.contain,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                manufacturer,
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: Color(0xFF3F3D56),
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(width: 15),
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
                                  callsign,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 20),
                              Container(
                                padding: const EdgeInsets.all(4),
                                child: const Icon(
                                  Icons.my_location,
                                  color: Colors.blue,
                                  size: 20,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: CachedAnyImage(
                        imagePath: image,
                        width: 100.0,
                        height: 50.0,
                        contentImage: BoxFit.cover,
                      ),
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
                        "$departureIata\n$timeSinceTakeoff",
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
                                groundSpeed == 0 ? 'N/A' : '$groundSpeed km/h',
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
                        "$arrivalIata\n$timeToArrival",
                        style: const TextStyle(fontSize: 13),
                        textAlign: TextAlign.right,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
