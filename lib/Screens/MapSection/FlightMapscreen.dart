import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Constants/ApiClass/ApiErrorModel.dart';
import '../../Constants/constantImages.dart';
import '../../Helpers/CacheManger/CachedImageFile.dart';
import '../../Helpers/CustomDivider.dart';
import '../../Helpers/MapSection/rotatePlane_icon.dart';
import '../../Helpers/SearchBarWidget.dart';
import '../../Helpers/SelectableAircraftCard.dart';
import '../../bloc/MapSection/MapAircraftList/aircraft_List_Data_Repository.dart';
import '../../bloc/MapSection/flight_Map_Cubit.dart';
import '../../bloc/MapSection/flight_map_model.dart';
import '../../bloc/MapSection/flight_map_state.dart';
import '../Home/AppBarFilterAndMapFilter/FilterForMapScreen.dart';
import '../Home/HomeAirbus/ChatSection/ChatBotScreen.dart';

class FlightMapScreen extends StatefulWidget {
  const FlightMapScreen({Key? key}) : super(key: key);

  @override
  State<FlightMapScreen> createState() => _FlightMapscreenState();
}

class _FlightMapscreenState extends State<FlightMapScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _showFlightCard = false;
  GoogleMapController? _mapController;
  FlightModel? selectedFlight;
  bool _hasFetchedDetails = false;

  final DraggableScrollableController _sheetController =
      DraggableScrollableController();

  @override
  void initState() {
    super.initState();
    context.read<FlightMapCubit>().getCurrentLocation(context);

    // Listen to sheet drag
    _sheetController.addListener(() {
      print(_sheetController.size);
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
  }

  @override
  void dispose() {
    _searchController.dispose();
    _mapController?.dispose();
    super.dispose();
  }

  void _toggleFlightCard({FlightModel? flight}) {
    setState(() {
      _showFlightCard = !_showFlightCard;
      selectedFlight = flight;
    });
  }

  void _hideFlightCard() {
    setState(() {
      _showFlightCard = false;
      selectedFlight = null;
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
            title: flight.flightNumber,
            snippet: "${flight.departureIata} → ${flight.arrivalIata}",
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
                            /// Handle + Header
                            SliverToBoxAdapter(
                              child: Column(
                                children: [
                                  // Handle bar
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

                                  // Header
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

                            /// Flight list
                            SliverList(
                              delegate: SliverChildBuilderDelegate((
                                context,
                                index,
                              ) {
                                final data = state.flightsListDetails?[index];
                                return Padding(
                                  key: ValueKey(index),
                                  padding: EdgeInsets.symmetric(
                                    vertical:
                                        MediaQuery.of(context).size.width *
                                        0.017,
                                  ),
                                  child: SimpleAircraftCard(
                                    imagePath: CachedAnyImage(
                                      imagePath: data?.image ?? "",
                                      width: 50,
                                      height: 120,
                                      contentImage: BoxFit.fill,
                                    ),
                                    model: "${data?.aircraftModel}  " ?? "",
                                    badge: data?.icaoTypeCode ?? "",
                                    manufacturer:
                                        data?.manufacturer?.companyName ?? "",
                                    airline: "",
                                    airlineImagePath: CachedAnyImage(
                                      imagePath: data?.manufacturer?.logo ?? "",
                                      width: 50,
                                      height: 120,
                                      contentImage: BoxFit.fill,
                                    ),
                                    onTap: () {
                                      _sheetController.animateTo(
                                        0.0, // hide it
                                        duration: const Duration(
                                          milliseconds: 400,
                                        ),
                                        curve: Curves.easeInOut,
                                      );
                                    },
                                  ),
                                );
                              }, childCount: state.flightsListDetails?.length),
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
                    child: GestureDetector(
                      onTap: () {
                        _hideFlightCard();
                      },
                      child: FlightCard(flight: selectedFlight),
                    ),
                  ),
                ],
              );
            }
            return const Center(child: Text('Fetching your location...'));
          },
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(right: 10, bottom: 10),
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
                const SnackBar(content: Text("Access token not found")),
              );
            }
          },
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: SvgPicture.asset(
            CommonUi.setSvgImage(AssetsPath.Chatbot),
            width: 50,
            height: 50,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}

class FlightCard extends StatelessWidget {
  final FlightModel? flight;

  const FlightCard({super.key, this.flight});

  @override
  Widget build(BuildContext context) {
    if (flight == null) {
      return const SizedBox.shrink();
    }

    /// Format duration into "1h 35m"
    String formatDuration(Duration duration) {
      final hours = duration.inHours;
      final minutes = duration.inMinutes.remainder(60);
      if (hours > 0 && minutes > 0) {
        return "${hours}h ${minutes}m";
      } else if (hours > 0) {
        return "${hours}h";
      } else {
        return "${minutes}m";
      }
    }

    /// Get arrival status
    String getArrivalStatus(DateTime? eta) {
      if (eta == null) return 'N/A';

      // Format the ETA to a readable time (e.g., "3:45 PM")
      final formatter = DateFormat(
        'h:mm a',
      ); // Use 'intl' package for formatting
      final localEta = eta.toLocal(); // Convert UTC to local time
      final now = DateTime.now().toUtc();
      final difference = eta.difference(now);

      if (difference.isNegative) {
        return "ETA ${formatter.format(localEta)}";
      } else {
        return "ETA ${formatter.format(localEta)}";
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
                /// Flight info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            flight?.flightNumber ?? "Unknown Flight",
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              flight?.type?.isNotEmpty ?? false
                                  ? (flight!.type.substring(0, 4))
                                  : "Unknown",
                              style: const TextStyle(fontSize: 12),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(
                            Icons.airplanemode_active,
                            size: 16,
                            color: Colors.black54,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            flight?.operatingAs ?? 'Unknown Airline',
                            style: const TextStyle(
                              fontSize: 13,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                /// Image
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: const Icon(
                    Icons.airplanemode_active,
                    size: 50,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),

            CustomDivider(height: 1.0),
            const SizedBox(height: 16),

            /// Route Row
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Departure → Only green dot + airport code
                Expanded(
                  flex: 2,
                  child: Row(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(right: 6),
                        width: 10,
                        height: 10,
                        decoration: const BoxDecoration(
                          color: Colors.green,
                          shape: BoxShape.circle,
                        ),
                      ),
                      Text(
                        flight?.departureIata ?? 'Unknown',
                        style: const TextStyle(fontSize: 13),
                      ),
                    ],
                  ),
                ),

                // Progress + Speed + Altitude
                Expanded(
                  flex: 3,
                  child: Column(
                    children: [
                      LinearProgressIndicator(
                        value: 0.5,
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
                            "${flight?.groundSpeed ?? 'N/A'} km/h",
                            style: const TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          const SizedBox(width: 10),
                          const Text("•", style: TextStyle(color: Colors.grey)),
                          const SizedBox(width: 10),
                          Text(
                            "${flight?.altitude ?? 'N/A'} m",
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

                // Arrival → Airport code + ETA or Arrived time
                Expanded(
                  flex: 2,
                  child: Text(
                    "${flight?.arrivalIata ?? 'Unknown'}\n${getArrivalStatus(flight?.eta)}",
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
