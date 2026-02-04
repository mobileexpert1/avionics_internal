import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class FlightGoogleMapWidget extends StatelessWidget {
  final CameraPosition initialCameraPosition;

  final GoogleMapController? mapController;
  final void Function(GoogleMapController controller)? onMapCreated;
  final VoidCallback? onCameraIdle;
  final VoidCallback? onCameraMoveStarted;

  final MapType mapType;
  final Set<Polygon> polygons;
  final Set<Marker> markers;

  final bool zoomControlsEnabled;
  final bool myLocationButtonEnabled;
  final bool rotateGesturesEnabled;
  final bool myLocationEnabled;

  /// Optional tracking support
  final bool isTracking;
  final LatLng? trackingLatLng;

  const FlightGoogleMapWidget({
    super.key,
    required this.initialCameraPosition,
    required this.mapType,
    required this.markers,
    this.polygons = const {},

    this.mapController,
    this.onMapCreated,
    this.onCameraIdle,
    this.onCameraMoveStarted,

    this.zoomControlsEnabled = false,
    this.myLocationButtonEnabled = false,
    this.rotateGesturesEnabled = false,
    this.myLocationEnabled = true,

    this.isTracking = false,
    this.trackingLatLng,
  });

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      zoomControlsEnabled: zoomControlsEnabled,
      myLocationButtonEnabled: myLocationButtonEnabled,
      rotateGesturesEnabled: rotateGesturesEnabled,
      myLocationEnabled: myLocationEnabled,
      minMaxZoomPreference: MinMaxZoomPreference(5, 12),
      mapType: mapType,
      polygons: polygons,
      markers: markers,

      initialCameraPosition: initialCameraPosition,

      onCameraIdle: onCameraIdle,
      onCameraMoveStarted: onCameraMoveStarted,

      onMapCreated: (controller) async {
        onMapCreated?.call(controller);

        if (isTracking && trackingLatLng != null) {
          await controller.animateCamera(
            CameraUpdate.newLatLng(trackingLatLng!),
          );
        }
      },
    );
  }
}
