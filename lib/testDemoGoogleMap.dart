// import 'dart:async';
// import 'dart:math';
// import 'package:avionics_internal/bloc/MapSection/FilterMap/filter_Map_State.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:geolocator/geolocator.dart';
//
// import 'Constants/ApiClass/ApiErrorModel.dart';
// import 'Screens/MapSection/FlightGoogleMapWidget.dart';
// import 'bloc/MapSection/flight_Map_Cubit.dart';
// import 'bloc/MapSection/flight_map_state.dart';
//
// class TestDemoMap extends StatefulWidget {
//   const TestDemoMap({super.key});
//
//   @override
//   State<TestDemoMap> createState() => _TestDemoMapState();
// }
//
// class _TestDemoMapState extends State<TestDemoMap> {
//   Timer? _debounce;
//   LatLng? _currentCenter;
//   Set<Polygon> _polygons = {};
//   GoogleMapController? _controller;
//   final Set<Circle> _circles = {};
//   final Set<Marker> _markers = {};
//
//   static const double radiusInNM = 110;
//   double get radiusInMeters => radiusInNM * 1852;
//   FlightMapCubit get _mapCubit => context.read<FlightMapCubit>();
//
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) async {
//       await _mapCubit.getCurrentLocation(context);
//       Position position = await Geolocator.getCurrentPosition(
//         desiredAccuracy: LocationAccuracy.high,
//       );
//       _currentCenter = LatLng(position.latitude, position.longitude);
//       setState(() {
//         _updateMapObjects();
//       });
//     });
//   }
//
//   void _drawBounds(LatLngBounds bounds) {
//     _polygons.clear();
//
//     _polygons.add(
//       Polygon(
//         polygonId: const PolygonId('bounds_polygon'),
//         points: [
//           bounds.southwest,
//           LatLng(bounds.southwest.latitude, bounds.northeast.longitude),
//           bounds.northeast,
//           LatLng(bounds.northeast.latitude, bounds.southwest.longitude),
//         ],
//         strokeWidth: 2,
//         strokeColor: Colors.red,
//         fillColor: Colors.red.withOpacity(0.15),
//       ),
//     );
//
//     setState(() {});
//   }
//
//   Future<void> _updateMapObjects() async {
//     if (_currentCenter == null) return;
//
//     _markers.clear();
//     _circles.clear();
//
//     _markers.add(
//       Marker(
//         markerId: const MarkerId('center_marker'),
//         position: _currentCenter!,
//         icon: BitmapDescriptor.defaultMarkerWithHue(
//           BitmapDescriptor.hueGreen,
//         ),
//       ),
//     );
//
//     _circles.add(
//       Circle(
//         circleId: const CircleId('radius_circle'),
//         center: _currentCenter!,
//         radius: radiusInMeters,
//         strokeWidth: 2,
//         strokeColor: Colors.blue,
//         fillColor: Colors.blue.withOpacity(0.25),
//       ),
//     );
//
//     final bounds = _getBoundsFromCircle(_currentCenter!, radiusInMeters);
//
//     _drawBounds(bounds);
//
//     _mapCubit.fetchFlightsByBounds(
//       currentCenterLatLong: _currentCenter!,
//       bounds: bounds,
//       context: context,
//     );
//   }
//
//   LatLngBounds _getBoundsFromCircle(LatLng center, double radiusInMeters) {
//     const double earthRadius = 6378137;
//
//     final double lat = center.latitude;
//     final double lng = center.longitude;
//
//     final double latDelta = (radiusInMeters / earthRadius) * (180 / pi);
//     final double lngDelta =
//         (radiusInMeters / earthRadius) * (180 / pi) / cos(lat * pi / 180);
//
//     final southwest = LatLng(lat - latDelta, lng - lngDelta);
//     final northeast = LatLng(lat + latDelta, lng + lngDelta);
//
//     return LatLngBounds(southwest: southwest, northeast: northeast);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: LayoutBuilder(
//         builder: (context, constraints) {
//           return BlocBuilder<FlightMapCubit, FlightMapState>(
//             builder: (context, state) {
//               if (state.status == CommonApiStatus.success &&
//                   state.position != null) {
//                 if (_currentCenter == null) {
//                   _currentCenter = LatLng(
//                     state.position!.latitude,
//                     state.position!.longitude,
//                   );
//                   _updateMapObjects();
//                 }
//
//                 return FlightGoogleMapWidget(
//                   mapType: CustomMapType.standard.toGoogleMapType(),
//
//                   initialCameraPosition: CameraPosition(
//                     target: _currentCenter!,
//                     zoom: 8,
//                   ),
//
//                   markers: {
//                     ..._markers,
//                     if (state.flights != null)
//                       ...state.flights!.map(
//                         (flight) => Marker(
//                           markerId: MarkerId(flight.id.toString()),
//                           position: LatLng(flight.latitude, flight.longitude),
//                           infoWindow: InfoWindow(
//                             title:  flight.callSign,
//                             snippet: "${flight.departureIata} → ${flight.arrivalIata}",
//                           ),
//                         ),
//                       ),
//                   },
//                   polygons: _polygons,
//
//                   circles: _circles,
//
//                   isTracking: state.isTracking,
//
//                   trackingLatLng: state.selectedFlight != null
//                       ? LatLng(
//                           state.selectedFlight!.latitude,
//                           state.selectedFlight!.longitude,
//                         )
//                       : null,
//
//                   onMapCreated: (controller) async {
//                     _controller = controller;
//                   },
//
//                   onCameraIdle: () async {
//                     _fetchFlightsWithDebounce(constraints);
//                   },
//                 );
//               }
//               return const Center(child: Text('Fetching your location...'));
//             },
//           );
//         },
//       ),
//     );
//   }
//
//   void _fetchFlightsWithDebounce(BoxConstraints constraints) {
//     if (_controller == null || _currentCenter == null) return;
//
//     _debounce?.cancel();
//
//     _debounce = Timer(const Duration(seconds: 2), () async {
//       if (!mounted) return;
//
//       print("API HIT with center: $_currentCenter");
//
//       final screenCenter = ScreenCoordinate(
//         x: (constraints.maxWidth ~/ 2),
//         y: (constraints.maxHeight ~/ 2),
//       );
//
//       final LatLng centerLatLng = await _controller!.getLatLng(screenCenter);
//
//       _currentCenter = centerLatLng;
//
//       setState(() {
//         _updateMapObjects();
//       });
//     });
//   }
// }