import 'dart:async';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../Constants/ApiClass/ApiErrorModel.dart';
import '../../Constants/ApiClass/FirebaseAnalytics/analytics_service.dart';
import '../../Constants/ApiClass/FirebaseAnalytics/event_names.dart';
import '../../Helpers/MapSection/rotatePlane_icon.dart';
import '../../bloc/MapSection/flight_Map_Cubit.dart';
import '../../bloc/MapSection/flight_map_detailModel.dart';
import '../../bloc/MapSection/flight_map_model.dart';
import '../../bloc/MapSection/flight_map_state.dart';
import 'FlightMapScreen.dart';

class TrackFlightScreen extends StatefulWidget {
  final String flightNumber;
  final FlightModel? initialFlight;
  final FlightAircraftDetail? initialFlightDetail;
  final String? flightId;

  const TrackFlightScreen({
    required this.flightNumber,
    this.initialFlight,
    this.initialFlightDetail,
    this.flightId,
    super.key,
  });

  @override
  State<TrackFlightScreen> createState() => _TrackFlightScreenState();
}

class _TrackFlightScreenState extends State<TrackFlightScreen>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  GoogleMapController? _mapController;
  Marker? _flightMarker;
  LatLng? _currentFlightPosition;
  AnimationController? _animationController;
  Animation<LatLng>? _positionAnimation;

  // for queued animations
  LatLng? _pendingTarget;

  bool _alertShown = false;

  @override
  void initState() {
    super.initState();

    // set initial flight position
    if (widget.initialFlight != null) {
      _currentFlightPosition = LatLng(
        widget.initialFlight!.latitude,
        widget.initialFlight!.longitude,
      );
    }

    // start flight tracking
    context.read<FlightMapCubit>().startTrackingFlight(
      widget.flightNumber,
      context,
    );

    // observe lifecycle only on mobile
    if (defaultTargetPlatform == TargetPlatform.android ||
        defaultTargetPlatform == TargetPlatform.iOS) {
      WidgetsBinding.instance.addObserver(this);
    }
    AnalyticsService.instance.logVisibleScreen(FirebaseEvents.flightTrackScreen);
  }

  @override
  void dispose() {
    _mapController?.dispose();
    _animationController?.dispose();

    if (defaultTargetPlatform == TargetPlatform.android ||
        defaultTargetPlatform == TargetPlatform.iOS) {
      WidgetsBinding.instance.removeObserver(this);
    }

    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    try {
      debugPrint("TrackFlightScreen lifecycle → $state");

      if (state == AppLifecycleState.resumed) {
        _alertShown = false;
      }

      if (state == AppLifecycleState.paused ||
          state == AppLifecycleState.inactive) {
        if (_alertShown == false) {
          _alertShown = true;
          _showInactiveDialog();
        }
      }
    } catch (e, s) {
      debugPrint("Lifecycle error: $e\n$s");
    }
  }

  void _showInactiveDialog() {
    if (!mounted) return;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.white,
        title: const Text("Tracking Stopped"),
        content: const Text(
          "You’ve become inactive. Flight tracking has been stopped.",
        ),
        actions: [
          TextButton(
            onPressed: () {
              context.read<FlightMapCubit>().stopTrackingFlight();
              Navigator.of(ctx).pop();
              Navigator.of(context).pop();
            },
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  Future<BitmapDescriptor> _getFlightMarkerIcon(double track) async {
    return await getRotatedPlaneIcon(track, color: Colors.red);
  }

  double _calculateBearing(LatLng from, LatLng to) {
    final lat1 = from.latitude * (pi / 180);
    final lon1 = from.longitude * (pi / 180);
    final lat2 = to.latitude * (pi / 180);
    final lon2 = to.longitude * (pi / 180);

    final dLon = lon2 - lon1;

    final y = sin(dLon) * cos(lat2);
    final x = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(dLon);

    final bearing = atan2(y, x) * (180 / pi);
    return (bearing + 360) % 360;
  }

  void _animateFlight(LatLng from, LatLng to) async {
    if (_animationController != null && _animationController!.isAnimating) {
      _pendingTarget = to;
      debugPrint("Queued new target: $to");
      return;
    }

    _animationController?.dispose();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 60),
    );

    final tween = LatLngTween(
      begin: from,
      end: to,
    ).chain(CurveTween(curve: Curves.linear));

    _positionAnimation = tween.animate(_animationController!);

    // Direction auto calculate
    final calculatedTrack = _calculateBearing(from, to);
    final icon = await _getFlightMarkerIcon(calculatedTrack);

    var movingMarker = Marker(
      markerId: MarkerId(widget.flightNumber),
      position: from,
      icon: icon,
      infoWindow: InfoWindow(
        title: widget.initialFlight?.callSign ?? 'Flight',
        snippet:
        '${widget.initialFlightDetail?.departureIata ?? 'N/A'} → ${widget.initialFlightDetail?.arrivalIata ?? 'N/A'}',
      ),
    );

    setState(() {
      _flightMarker = movingMarker;
    });

    _positionAnimation!.addListener(() {
      if (!mounted) return;
      final pos = _positionAnimation!.value;
      movingMarker = movingMarker.copyWith(positionParam: pos);

      setState(() {
        _flightMarker = movingMarker;
      });
    });

    _animationController!.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _currentFlightPosition = to;
        _mapController?.animateCamera(CameraUpdate.newLatLng(to));

        // process queued update if available
        if (_pendingTarget != null) {
          final nextTarget = _pendingTarget!;
          _pendingTarget = null;
          debugPrint("Starting queued animation to: $nextTarget");
          _animateFlight(_currentFlightPosition!, nextTarget);
        }
      }
    });
    _animationController!.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<FlightMapCubit, FlightMapState>(
        listener: (context, state) async {
          if (state.status == CommonApiStatus.failure) {
            if (!mounted) return;
            print(state.errorMessage ?? 'Failed to fetch flight details');
          }

          if (state.selectedFlight != null) {
            final newPos = LatLng(
              state.selectedFlight!.latitude,
              state.selectedFlight!.longitude,
            );

            if (_currentFlightPosition != null) {
              _animateFlight(_currentFlightPosition!, newPos);
            } else {
              // first-time: animate as well
              _currentFlightPosition = newPos;
              _animateFlight(newPos, newPos);
            }
          }
        },
        child: BlocBuilder<FlightMapCubit, FlightMapState>(
          builder: (context, state) {
            final flight = state.selectedFlight ?? widget.initialFlight;
            final detail =
                state.selectedFlightDetail ?? widget.initialFlightDetail;

            if (flight == null && detail == null) {
              return const Center(child: Text('No flight data available'));
            }

            final flightLatLng = flight != null
                ? LatLng(flight.latitude, flight.longitude)
                : _currentFlightPosition;

            return Stack(
              fit: StackFit.expand,
              children: [
                if (flightLatLng != null)
                  FutureBuilder<BitmapDescriptor>(
                    future: _getFlightMarkerIcon(
                      _calculateBearing(flightLatLng, flightLatLng),
                    ),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      _flightMarker ??= Marker(
                        markerId: MarkerId(
                          flight?.id.toString() ?? widget.flightNumber,
                        ),
                        position: flightLatLng,
                        icon: snapshot.data!,
                        infoWindow: InfoWindow(
                          title:
                              flight?.callSign ?? detail?.callsign ?? 'Unknown',
                          snippet:
                              '${detail?.departureIcao ?? 'N/A'} → ${detail?.arrivalIcao ?? 'N/A'}',
                        ),
                      );
                      return GoogleMap(
                        rotateGesturesEnabled: false,
                        zoomControlsEnabled: false,
                        myLocationButtonEnabled: false,
                        mapType: state.mapType,
                        zoomGesturesEnabled: true,
                        initialCameraPosition: CameraPosition(
                          target: flightLatLng,
                          zoom: 8,
                        ),
                        myLocationEnabled: true,
                        markers: _flightMarker != null ? {_flightMarker!} : {},
                        onMapCreated: (GoogleMapController controller) {
                          _mapController = controller;
                          _mapController?.animateCamera(
                            CameraUpdate.newLatLngZoom(flightLatLng, 8),
                          );
                        },
                      );
                    },
                  ),
                AnimatedPositioned(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: FlightCard(
                    flightDetail: detail,
                    isComeFromLiveTracking: true,
                  ),
                ),
                Positioned(
                  top: 40,
                  left: 10,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
                    onPressed: () {
                      context.read<FlightMapCubit>().stopTrackingFlight();
                      Navigator.pop(context, widget.flightId);
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}


class LatLngTween extends Tween<LatLng> {
  LatLngTween({required LatLng begin, required LatLng end})
    : super(begin: begin, end: end);

  @override
  LatLng lerp(double t) {
    return LatLng(
      begin!.latitude + (end!.latitude - begin!.latitude) * t,
      begin!.longitude + (end!.longitude - begin!.longitude) * t,
    );
  }
}
