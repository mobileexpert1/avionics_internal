// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_map/flutter_map.dart';
// import 'package:latlong2/latlong.dart';
// import '../../Constants/ApiClass/ApiErrorModel.dart';
// import '../../Helpers/SearchBarWidget.dart';
// import '../../bloc/MapSection/flight_Map_Cubit.dart';
// import '../../bloc/MapSection/flight_map_state.dart';
// import '../Home/AppBarFilter/FilterScreen.dart';
//
// class FlightMapScreen extends StatefulWidget {
//   const FlightMapScreen({Key? key}) : super(key: key);
//
//   @override
//   State<FlightMapScreen> createState() => _FlightMapscreenState();
// }
//
// class _FlightMapscreenState extends State<FlightMapScreen> {
//   final TextEditingController _searchController = TextEditingController();
//
//   @override
//   void initState() {
//     super.initState();
//     context.read<FlightMapCubit>().loadFlights();
//   }
//
//   @override
//   void dispose() {
//     _searchController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<FlightMapCubit, FlightMapState>(
//       builder: (context, state) {
//         if (state.isLoading) {
//           return const Center(child: CircularProgressIndicator());
//         }
//
//         if (state.status == CommonApiStatus.failure) {
//           return Center(
//             child: Text(state.errorMessage ?? 'Failed to get current location'),
//           );
//         }
//
//         // if (state.status == CommonApiStatus.success && state.position != null) {
//         //   final position = state.position!;
//         //   final currentLatLng = LatLng(position.latitude, position.longitude);
//         if (state.status == CommonApiStatus.success && state.flights.isNotEmpty) {
//           final firstFlight = state.flights.first;
//           final currentLatLng = LatLng(firstFlight.lat, firstFlight.lon);
//
//           return Stack(
//             children: [
//               FlutterMap(
//                 options: MapOptions(center: currentLatLng, zoom: 6),
//                 children: [
//                   TileLayer(
//                     urlTemplate: 'https://tile.opentopomap.org/{z}/{x}/{y}.png',
//                     userAgentPackageName: 'com.example.yourapp',
//                   ),
//                   // MarkerLayer(
//                   //   markers: [
//                   //     Marker(
//                   //       point: currentLatLng,
//                   //       width: 60,
//                   //       height: 60,
//                   //       builder: (ctx) => const Icon(
//                   //         Icons.location_on,
//                   //         color: Colors.red,
//                   //         size: 40,
//                   //       ),
//                   //     ),
//                   //   ],
//                   // ),
//
//                   MarkerLayer(
//                       markers: [
//                         ...state.flights.map((flight) => Marker(
//                           point: LatLng(flight.lat, flight.lon),
//                           width: 30,
//                           height: 30,
//                           builder: (ctx) => const Icon(
//                             Icons.airplanemode_active,
//                             color: Colors.red,
//                             size: 25,
//                           ),
//                         )),
//                       ]
//                   ),
//
//
//                 ],
//               ),
//
//               // 🔍 Positioned SearchBar on top
//               Positioned(
//                 top: 50,
//                 left: 10,
//                 right: 10,
//                 child: SearchBarWidget(
//                   enableBackArrow: false,
//                   enableFilter: true,
//                   enableCloseScreen: false,
//                   isComeFromMapSection: true,
//                   controller: _searchController,
//                   onFilterTap: () {
//                     showModalBottomSheet(
//                       context: context,
//                       isScrollControlled: true,
//                       shape: const RoundedRectangleBorder(
//                         borderRadius: BorderRadius.vertical(
//                           top: Radius.circular(20),
//                         ),
//                       ),
//                       backgroundColor: Colors.transparent,
//                       builder: (context) {
//                         return FractionallySizedBox(
//                           heightFactor: 0.9,
//                           child: ClipRRect(
//                             borderRadius: const BorderRadius.vertical(
//                               top: Radius.circular(20),
//                             ),
//                             child: FilterScreen(),
//                           ),
//                         );
//                       },
//                     );
//                   },
//                   searchTitle: 'Search...',
//                 ),
//               ),
//             ],
//           );
//         }
//         return const Center(child: Text('Fetching your location...'));
//       },
//     );
//   }
// }



import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../Constants/ApiClass/ApiErrorModel.dart';
import '../../Helpers/SearchBarWidget.dart';
import '../../bloc/MapSection/flight_Map_Cubit.dart';
import '../../bloc/MapSection/flight_map_state.dart';
import '../Home/AppBarFilter/FilterScreen.dart';

class FlightMapScreen extends StatefulWidget {
  const FlightMapScreen({Key? key}) : super(key: key);

  @override
  State<FlightMapScreen> createState() => _FlightMapScreenState();
}

class _FlightMapScreenState extends State<FlightMapScreen> {
  final TextEditingController _searchController = TextEditingController();
  GoogleMapController? _mapController;

  @override
  void initState() {
    super.initState();
    context.read<FlightMapCubit>().loadFlights();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _mapController?.dispose();
    super.dispose();
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
            child: Text(state.errorMessage ?? 'Failed to load flights'),
          );
        }

        if (state.status == CommonApiStatus.success && state.flights.isNotEmpty) {
          final firstFlight = state.flights.first;
          final initialCamera = CameraPosition(
            target: LatLng(firstFlight.lat, firstFlight.lon),
            zoom: 6,
          );

          return Stack(
            children: [
              GoogleMap(
                initialCameraPosition: initialCamera,
                mapType: MapType.normal,
                myLocationEnabled: true,
                onMapCreated: (controller) {
                  _mapController = controller;
                },
                markers: state.flights
                    .map((flight) => Marker(
                  markerId: MarkerId(flight.id),
                  position: LatLng(flight.lat, flight.lon),
                  icon: BitmapDescriptor.defaultMarkerWithHue(
                      BitmapDescriptor.hueYellow),
                  infoWindow: InfoWindow(title: "Flight ${flight.id}"),
                ))
                    .toSet(),
              ),

              // 🔍 Positioned SearchBar on top
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
                          heightFactor: 0.9,
                          child: ClipRRect(
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(20),
                            ),
                            child: FilterScreen(),
                          ),
                        );
                      },
                    );
                  },
                  searchTitle: 'Search...',
                ),
              ),
            ],
          );
        }

        return const Center(child: Text('Fetching flights...'));
      },
    );
  }
}
