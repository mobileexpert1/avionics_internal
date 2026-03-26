import 'dart:async';
import 'package:avionics_internal/bloc/MapSection/FilterMap/filter_Map_State.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

import 'Constants/ApiClass/ApiErrorModel.dart';
import 'Screens/MapSection/FlightGoogleMapWidget.dart';
import 'bloc/MapSection/flight_Map_Cubit.dart';
import 'bloc/MapSection/flight_map_state.dart';

class TestDemoMap extends StatefulWidget {
  const TestDemoMap({super.key});

  @override
  State<TestDemoMap> createState() => _TestDemoMapState();
}

class _TestDemoMapState extends State<TestDemoMap> {
  Timer? _debounce;
  LatLng? _currentCenter;
  GoogleMapController? _controller;
  final Set<Circle> _circles = {};
  final Set<Marker> _markers = {};
  static const double radiusInNM = 50;

  double get radiusInMeters => radiusInNM * 1852;

  FlightMapCubit get _mapCubit => context.read<FlightMapCubit>();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _mapCubit.getCurrentLocation(context);
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      _currentCenter = LatLng(position.latitude, position.longitude);
      setState(() {
        _updateMapObjects();
      });
    });
  }

  void _updateMapObjects() {
    if (_currentCenter == null) return;

    _markers.clear();
    _circles.clear();

    _markers.add(
      Marker(
        markerId: const MarkerId('center_marker'),
        position: _currentCenter!,
      ),
    );

    _circles.add(
      Circle(
        circleId: const CircleId('radius_circle'),
        center: _currentCenter!,
        radius: radiusInMeters,
        strokeWidth: 2,
        strokeColor: Colors.blue,
        fillColor: Colors.blue.withOpacity(0.25),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: LayoutBuilder(
        builder: (context, constraints) {
          return BlocBuilder<FlightMapCubit, FlightMapState>(
            builder: (context, state) {
              if (state.status == CommonApiStatus.success &&
                  state.position != null) {
                if (_currentCenter == null) {
                  _currentCenter = LatLng(
                    state.position!.latitude,
                    state.position!.longitude,
                  );
                  _updateMapObjects();
                }

                return FlightGoogleMapWidget(
                  mapType: CustomMapType.standard.toGoogleMapType(),

                  initialCameraPosition: CameraPosition(
                    target: _currentCenter!,
                    zoom: 8,
                  ),

                  markers: {
                    ..._markers,
                    if (state.flights != null)
                      ...state.flights!.map(
                            (flight) => Marker(
                          markerId: MarkerId(flight.id.toString()),
                          position: LatLng(flight.latitude, flight.longitude),
                        ),
                      ),
                  },

                  circles: _circles,

                  isTracking: state.isTracking,

                  trackingLatLng: state.selectedFlight != null
                      ? LatLng(
                    state.selectedFlight!.latitude,
                    state.selectedFlight!.longitude,
                  )
                      : null,

                  onMapCreated: (controller) async {
                    _controller = controller;
                  },
                  onCameraIdle: () async {
                    _fetchFlightsWithDebounce(constraints);
                  },
                );
              }
              return const Center(child: Text('Fetching your location...'));
            },
          );
        },
      ),
    );
  }

  void _fetchFlightsWithDebounce(BoxConstraints constraints) {
    if (_controller == null || _currentCenter == null) return;

    _debounce?.cancel();

    _debounce = Timer(const Duration(seconds: 2), () async {
      if (!mounted) return;

      print("API HIT with center: $_currentCenter");

      final screenCenter = ScreenCoordinate(
        x: (constraints.maxWidth ~/ 2),
        y: (constraints.maxHeight ~/ 2),
      );

      final LatLng centerLatLng = await _controller!.getLatLng(screenCenter);

      _currentCenter = centerLatLng;

      setState(() {
        _updateMapObjects();
      });
    });
  }
}

