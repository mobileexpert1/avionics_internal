import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../Constants/ApiClass/shared_prefs_helper.dart';

class FlightGoogleMapWidget extends StatefulWidget {
  final CameraPosition initialCameraPosition;

  final void Function(GoogleMapController controller)? onMapCreated;
  final VoidCallback? onCameraIdle;
  final VoidCallback? onCameraMoveStarted;
  final ValueChanged<bool>? isAlreadyFetchedTheKey;

  final MapType mapType;
  final Set<Polygon> polygons;
  final Set<Marker> markers;
  final Set<Circle>? circles;

  final bool zoomControlsEnabled;
  final bool myLocationButtonEnabled;
  final bool rotateGesturesEnabled;
  final bool myLocationEnabled;

  final bool isTracking;
  final LatLng? trackingLatLng;

  const FlightGoogleMapWidget({
    super.key,
    required this.initialCameraPosition,
    required this.mapType,
    required this.markers,
    this.circles,
    this.polygons = const {},
    this.onMapCreated,
    this.onCameraIdle,
    this.onCameraMoveStarted,
    this.isAlreadyFetchedTheKey,
    this.zoomControlsEnabled = false,
    this.myLocationButtonEnabled = false,
    this.rotateGesturesEnabled = false,
    this.myLocationEnabled = true,
    this.isTracking = false,
    this.trackingLatLng,
  });

  @override
  State<FlightGoogleMapWidget> createState() => _FlightGoogleMapWidgetState();
}

class _FlightGoogleMapWidgetState extends State<FlightGoogleMapWidget> {
  GoogleMapController? _mapController;

  bool _isAlreadyFetchedTheKey = false;

  @override
  void initState() {
    super.initState();
    fetchTheApiKey();
    debugPrint("FlightGoogleMapWidget initialized");
  }

  Future<void> fetchTheApiKey() async {
    bool? apiTokenSever = await SharedPrefsHelper.getApiFetchKeyFromSever();
    if (apiTokenSever == true) {
      _isAlreadyFetchedTheKey = true;
      widget.isAlreadyFetchedTheKey?.call(true);
    } else {
      _isAlreadyFetchedTheKey = false;
      widget.isAlreadyFetchedTheKey?.call(false);
    }
  }

  @override
  void dispose() {
    debugPrint("FlightGoogleMapWidget disposed");
    _mapController?.dispose();
    _mapController = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isAlreadyFetchedTheKey) {
      return const Scaffold(
        backgroundColor: Colors.white,
        body: Center(child: CircularProgressIndicator()),
      );
    }
    return GoogleMap(
      key: ValueKey(widget.circles.hashCode),
      zoomControlsEnabled: widget.zoomControlsEnabled,
      myLocationButtonEnabled: widget.myLocationButtonEnabled,
      rotateGesturesEnabled: widget.rotateGesturesEnabled,
      minMaxZoomPreference: MinMaxZoomPreference(0, 15),
      myLocationEnabled: widget.myLocationEnabled,
      mapType: widget.mapType,
      polygons: widget.polygons,
      markers: widget.markers,
      circles: widget.circles ?? {},
      initialCameraPosition: widget.initialCameraPosition,
      onCameraIdle: widget.onCameraIdle,
      onCameraMoveStarted: widget.onCameraMoveStarted,
      onMapCreated: (controller) async {
        _mapController = controller;

        widget.onMapCreated?.call(controller);

        if (widget.isTracking && widget.trackingLatLng != null) {
          await controller.animateCamera(
            CameraUpdate.newLatLng(widget.trackingLatLng!),
          );
        }
      },
    );
  }
}
