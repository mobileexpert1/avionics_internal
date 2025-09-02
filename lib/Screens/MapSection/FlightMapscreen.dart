import 'package:avionics_internal/Screens/Home/AppBarFilterAndMapFilter/FilterForMapScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../../Constants/ApiClass/ApiErrorModel.dart';
import '../../Helpers/SearchBarWidget.dart';
import '../../bloc/MapSection/flight_Map_Cubit.dart';
import '../../bloc/MapSection/flight_map_state.dart';

class FlightMapScreen extends StatefulWidget {
  const FlightMapScreen({Key? key}) : super(key: key);

  @override
  State<FlightMapScreen> createState() => _FlightMapscreenState();
}

class _FlightMapscreenState extends State<FlightMapScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _showFlightCard = false;

  @override
  void initState() {
    super.initState();
    context.read<FlightMapCubit>().getCurrentLocation(context);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _toggleFlightCard() {
    setState(() {
      _showFlightCard = !_showFlightCard;
    });
  }

  void _hideFlightCard() {
    setState(() {
      _showFlightCard = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FlightMapCubit, FlightMapState>(
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

          return GestureDetector(
            onTap: () {
              /// Tap on map background toggles card
            },
            child: Stack(
              children: [
                /// Map
                FlutterMap(
                  options: MapOptions(center: currentLatLng, zoom: 15),
                  children: [
                    TileLayer(
                      urlTemplate:
                          'https://tile.opentopomap.org/{z}/{x}/{y}.png',
                      userAgentPackageName: 'com.example.yourapp',
                    ),
                    MarkerLayer(
                      markers: [
                        Marker(
                          point: currentLatLng,
                          width: 60,
                          height: 60,
                          builder: (ctx) => const Icon(
                            Icons.location_on,
                            color: Colors.red,
                            size: 40,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                /// 🔍 Search bar
                Positioned(
                  top: 50,
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

                      // showModalBottomSheet(
                      //   context: context,
                      //   isScrollControlled: true,
                      //   shape: const RoundedRectangleBorder(
                      //     borderRadius: BorderRadius.vertical(
                      //       top: Radius.circular(20),
                      //     ),
                      //   ),
                      //   backgroundColor: Colors.transparent,
                      //   builder: (context) {
                      //     return FractionallySizedBox(
                      //       heightFactor: 0.84,
                      //       child: ClipRRect(
                      //         borderRadius: const BorderRadius.vertical(
                      //           top: Radius.circular(20),
                      //         ),
                      //         child: FilterForMapScreen(),
                      //       ),
                      //     );
                      //   },
                      // );
                    },
                    searchTitle: 'Search...',
                  ),
                ),

                /// ✈️ Flight Card at bottom
                AnimatedPositioned(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  left: 0,
                  right: 0,
                  bottom: _showFlightCard ? 0.1 : -250,
                  child: GestureDetector(
                    onTap: () {}, // block tap-through
                    child: const FlightCard(),
                  ),
                ),
              ],
            ),
          );
        }
        return const Center(child: Text('Fetching your location...'));
      },
    );
  }
}

class FlightCard extends StatelessWidget {
  const FlightCard({super.key});

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
