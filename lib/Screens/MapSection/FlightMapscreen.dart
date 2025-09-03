import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../Constants/ApiClass/ApiErrorModel.dart';
import '../../Helpers/MapSection/rotatePlane_icon.dart';
import '../../Helpers/SearchBarWidget.dart';
import '../../bloc/MapSection/flight_Map_Cubit.dart';
import '../../bloc/MapSection/flight_map_model.dart';
import '../../bloc/MapSection/flight_map_state.dart';

class FlightMapScreen extends StatefulWidget {
  const FlightMapScreen({Key? key}) : super(key: key);

  @override
  State<FlightMapScreen> createState() => _FlightMapscreenState();
}

class _FlightMapscreenState extends State<FlightMapScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _showFlightCard = false;
  GoogleMapController? _mapController;
  FlightModel? _selectedFlight;

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

  void _toggleFlightCard({FlightModel? flight}) {
    setState(() {
      _selectedFlight = flight;
      _showFlightCard = !_showFlightCard;
    });
  }

  void _hideFlightCard() {
    setState(() {
      _selectedFlight = null;
      _showFlightCard = false;
    });
  }

  Future<Set<Marker>> _buildFlightMarkers(List<FlightModel> flights) async {
    final markers = <Marker>{};
    print('Building markers for ${flights.length} flights');
    for (final flight in flights) {
      print('Flight track: ${flight.track}, Type: ${flight.track.runtimeType}');
      final icon = await getRotatedPlaneIcon((flight.track ?? 0.0).toDouble(), color: Colors.red);
      markers.add(
        Marker(
          markerId: MarkerId(flight.id.toString()),
          position: LatLng(flight.latitude, flight.longitude),
          icon: icon,
          infoWindow: InfoWindow(
            title: flight.flightNumber ?? "Unknown",
            snippet: "${flight.departureIata} → ${flight.arrivalIata}",
          ),
          onTap: () {
            print("Flight: ${flight.flightNumber}\n"
                "Lat: ${flight.latitude}, Lon: ${flight.longitude}\n"
                "Dir: ${flight.track}°\n"
                "From: ${flight.departureIata} → To: ${flight.arrivalIata}");
            _toggleFlightCard(flight: flight);
          },
        ),
      );
    }
    return markers;
  }

  void _fitMapToBounds(List<FlightModel> flights, LatLng currentLatLng) {
    if (flights.isEmpty || _mapController == null) {
      print('No flights or map controller not ready, skipping bounds adjustment');
      return;
    }

    final latLngBounds = LatLngBounds(
      southwest: LatLng(
        [currentLatLng.latitude, ...flights.map((f) => f.latitude)].reduce((a, b) => a < b ? a : b),
        [currentLatLng.longitude, ...flights.map((f) => f.longitude)].reduce((a, b) => a < b ? a : b),
      ),
      northeast: LatLng(
        [currentLatLng.latitude, ...flights.map((f) => f.latitude)].reduce((a, b) => a > b ? a : b),
        [currentLatLng.longitude, ...flights.map((f) => f.longitude)].reduce((a, b) => a > b ? a : b),
      ),
    );

    _mapController!.animateCamera(
      CameraUpdate.newLatLngBounds(latLngBounds, 50),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox.expand(
        child: BlocBuilder<FlightMapCubit, FlightMapState>(
          builder: (context, state) {
            if (state.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state.status == CommonApiStatus.failure) {
              return Center(
                child: Text(state.errorMessage ?? 'Failed to get current location'),
              );
            }

            if (state.status == CommonApiStatus.success && state.position != null) {
              final position = state.position!;
              final currentLatLng = LatLng(position.latitude, position.longitude);
              print('Current location: $currentLatLng, Flights: ${state.flights?.length ?? 0}');

              return GestureDetector(
                onTap: _hideFlightCard,
                child: Stack(
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
                      top: 20,
                      left: 10,
                      right: 10,
                      child: SearchBarWidget(
                        enableBackArrow: false,
                        enableFilter: true,
                        enableCloseScreen: false,
                        isComeFromMapSection: true,
                        controller: _searchController,
                        onFilterTap: () {
                          if (_showFlightCard) {
                            _hideFlightCard();
                          } else {
                            _toggleFlightCard();
                          }
                        },
                        searchTitle: 'Search...',
                      ),
                    ),
                    AnimatedPositioned(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      left: 0,
                      right: 0,
                      bottom: _showFlightCard ? 0 : -250,
                      child: GestureDetector(
                        onTap: () {}, // Block tap-through
                        child: FlightCard(flight: _selectedFlight),
                      ),
                    ),
                  ],
                ),
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
  const FlightCard({super.key, FlightModel? flight});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      elevation: 10,
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 25),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Text(
                            "A-320-200",
                            style: TextStyle(
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
                            child: const Text(
                              "A320",
                              style: TextStyle(fontSize: 12),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: const [
                          Icon(
                            Icons.airplanemode_active,
                            size: 16,
                            color: Colors.black54,
                          ),
                          SizedBox(width: 4),
                          Text(
                            "Airbus",
                            style: TextStyle(
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
                Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        "https://picsum.photos/100/60",
                        height: 60,
                        width: 100,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Container(
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.black87,
                      ),
                      padding: const EdgeInsets.all(6),
                      child: const Icon(
                        Icons.airplanemode_active,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 16),

            /// Route
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text("LFPG Paris\n40 min ago", style: TextStyle(fontSize: 13)),
                Text(
                  "LEMD Madrid\nin 1h 9m",
                  style: TextStyle(fontSize: 13),
                  textAlign: TextAlign.right,
                ),
              ],
            ),
            const SizedBox(height: 10),

            /// Progress
            Column(
              children: [
                LinearProgressIndicator(
                  value: 0.6,
                  backgroundColor: Colors.grey.shade300,
                  color: Colors.blue,
                  minHeight: 5,
                  borderRadius: BorderRadius.circular(4),
                ),
                const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text(
                      "933 km/h",
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(width: 10),
                    Text("•", style: TextStyle(color: Colors.grey)),
                    SizedBox(width: 10),
                    Text(
                      "10,668m",
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
