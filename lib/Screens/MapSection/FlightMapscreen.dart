import 'package:avionics_internal/bloc/Home/AircraftComparison/AircraftComparisonModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../Constants/ApiClass/ApiErrorModel.dart';
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

class FlightMapScreen extends StatefulWidget {
  const FlightMapScreen({Key? key}) : super(key: key);

  @override
  State<FlightMapScreen> createState() => _FlightMapscreenState();
}

class _FlightMapscreenState extends State<FlightMapScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _showFlightCard = false;
  GoogleMapController? _mapController;

  // Static dummy data for testing
  final dummyAircraft = [
    {
      "image":
          "https://upload.wikimedia.org/wikipedia/commons/3/3f/Airbus_A320.jpg",
      "model": "A320-200",
      "badge": "A320",
      "manufacturer": "Airbus",
      "airline": "Lufthansa",
      "airlineLogo":
          "https://upload.wikimedia.org/wikipedia/commons/0/0d/Lufthansa_Logo_2018.svg",
    },
    {
      "image":
          "https://upload.wikimedia.org/wikipedia/commons/6/6e/Boeing_777_Air_France.jpg",
      "model": "B777-300ER",
      "badge": "B777",
      "manufacturer": "Boeing",
      "airline": "Air France",
      "airlineLogo":
          "https://upload.wikimedia.org/wikipedia/commons/4/45/Air_France_Logo.svg",
    },
    {
      "image":
          "https://upload.wikimedia.org/wikipedia/commons/8/89/Airbus_A350_Finnair.jpg",
      "model": "A350-900",
      "badge": "A350",
      "manufacturer": "Airbus",
      "airline": "Finnair",
      "airlineLogo":
          "https://upload.wikimedia.org/wikipedia/commons/c/c5/Finnair_Logo.svg",
    },
  ];

  final DraggableScrollableController _sheetController =
      DraggableScrollableController();

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    context.read<FlightMapCubit>().getCurrentLocation(context);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _mapController?.dispose();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  void _toggleFlightCard({required FlightModel flight}) {
    print('Toggling flight card for flight ID: ${flight.id}');
    context.read<FlightMapCubit>().fetchFlightDetails(
      flightId: flight.id,
      context: context,
    );
    setState(() {
      _showFlightCard = true;
    });
  }

  void _hideFlightCard() {
    print('Hiding flight card');
    setState(() {
      _showFlightCard = false;
    });
  }

  Future<Set<Marker>> _buildFlightMarkers(List<FlightModel> flights) async {
    final markers = <Marker>{};
    print('Building markers for ${flights.length} flights');
    for (final flight in flights) {
      print('Flight track: ${flight.track}, Type: ${flight.track.runtimeType}');
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
            _toggleFlightCard(flight: flight);
          },
        ),
      );
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
                  Positioned(
                    top: 40,
                    left: 5,
                    right: 5,
                    child: SearchBarWidget(
                      enableBackArrow: false,
                      enableFilter: true,
                      enableCloseScreen: false,
                      isComeFromMapSection: true,
                      controller: _searchController,
                      onFilterTap: () {
                        showModalBottomSheet(
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
                                child: FilterForMapScreen(),
                              ),
                            );
                          },
                        );
                        _hideFlightCard();
                      },
                      searchTitle: 'Search...',
                    ),
                  ),
                  DraggableScrollableSheet(
                    controller: _sheetController,
                    initialChildSize: 0.1,
                    minChildSize: 0.1,
                    maxChildSize: 0.8,
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
                                final data = dummyAircraft[index];
                                return Padding(
                                  key: ValueKey(index),
                                  padding: EdgeInsets.symmetric(
                                    vertical:
                                        MediaQuery.of(context).size.width *
                                        0.017,
                                  ),
                                  child: SimpleAircraftCard(
                                    imagePath: CachedAnyImage(
                                      imagePath: data["image"]!,
                                      width:
                                          MediaQuery.of(context).size.width *
                                          0.15,
                                      height:
                                          MediaQuery.of(context).size.width *
                                          0.15,
                                      contentImage: BoxFit.fill,
                                    ),
                                    model: data["model"]!,
                                    badge: data["badge"]!,
                                    manufacturer: data["manufacturer"]!,
                                    airline: data["airline"]!,
                                    airlineImagePath: CachedAnyImage(
                                      imagePath: data["airlineLogo"]!,
                                      width:
                                          MediaQuery.of(context).size.width *
                                          0.05,
                                      height:
                                          MediaQuery.of(context).size.width *
                                          0.05,
                                      contentImage: BoxFit.fill,
                                    ),
                                    onTap: () {
                                      setState(() {
                                        _showFlightCard = !_showFlightCard;
                                      });
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
                              }, childCount: 3),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
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
    );
  }
}

class FlightCard extends StatelessWidget {
  final FlightAircraftDetail? flightDetail;
  // final AircraftModel? aircraftDetails;

  const FlightCard({
    super.key,
    this.flightDetail,
    // this.aircraftDetails,
  });

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
    if (flightDetail == null) {
      print('FlightCard: flightDetail is null');
      return const Text('No flight details available');
    }

    print(
      'FlightCard: Rendering with flightDetail: ${flightDetail!.toString()}',
    );
    final departureIata = flightDetail!.departureIata ?? 'N/A';
    final arrivalIata = flightDetail!.arrivalIata ?? 'N/A';
    final groundSpeed = flightDetail!.groundSpeed ?? 0;
    final altitude = flightDetail!.altitude ?? 0;
    final takeoffTime = flightDetail!.takeoffTime;
    final eta = flightDetail!.eta;
    final callsign = flightDetail!.callsign;

    final aircraftType =
        flightDetail!.aircraftModel ?? flightDetail!.type ?? 'N/A';
    final manufacturer = flightDetail!.manufacturer?.companyName ?? 'Unknown';
    final category = flightDetail!.icaoTypeCode ?? flightDetail!.type ?? 'N/A';
    final image = flightDetail!.image ?? 'https://via.placeholder.com/50';
    final manufacturerLogo =
        flightDetail!.manufacturer?.logo ?? 'https://via.placeholder.com/16';

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
    if (flightDetail!.actualDistance != null &&
        flightDetail!.circleDistance != null &&
        flightDetail!.circleDistance! > 0) {
      progress = (flightDetail!.actualDistance! / flightDetail!.circleDistance!)
          .clamp(0.0, 1.0);
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
                          const SizedBox(width: 20),
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
                          const SizedBox(width: 10),
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
                              callsign!,
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: Colors
                                    .white, // better contrast with dark background
                              ),
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
                          const Text("•", style: TextStyle(color: Colors.grey)),
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
  }
}
