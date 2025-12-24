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
  final Set<Marker> _markers = {};

  LatLng? _currentFlightPosition;
  AnimationController? _animationController;
  Animation<LatLng>? _positionAnimation;

  // for queued animations
  LatLng? _pendingTarget;
  bool _alertShown = false;
  bool _alertShownOfTrackingStopped = false;

  LatLng? _flightTrailStart;
  final Set<Polyline> _staticPolyline = {};
  final List<LatLng> _flightNextCoordinatesPoints = [];
  Set<Polyline> _flightNextLocationCoordinates = {};

  @override
  void initState() {
    super.initState();

    // set initial flight position
    if (widget.initialFlight != null) {
      _currentFlightPosition = LatLng(
        widget.initialFlight!.latitude,
        widget.initialFlight!.longitude,
      );
      _flightNextCoordinatesPoints.add(_currentFlightPosition!);

      if (widget.initialFlightDetail?.destinationAirport?.latitude != null &&
          widget.initialFlightDetail?.destinationAirport?.longitude != null) {
        _setupStaticFlightPath(_currentFlightPosition!);
      }
    }

    _addStaticAirportMarkers();

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
    AnalyticsService.instance.logVisibleScreen(
      FirebaseEvents.flightTrackScreen,
    );
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

  void _addStaticAirportMarkers() {
    _markers.removeWhere(
      (m) => m.markerId.value == 'origin' || m.markerId.value == 'destination',
    );

    if (widget.initialFlightDetail?.originAirport != null) {
      _markers.add(
        Marker(
          markerId: const MarkerId('origin'),
          position: LatLng(
            widget.initialFlightDetail!.originAirport!.latitude,
            widget.initialFlightDetail!.originAirport!.longitude,
          ),
          icon: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueGreen,
          ),
          infoWindow: InfoWindow(
            title: widget.initialFlightDetail!.originAirport!.name,
          ),
        ),
      );
    }

    if (widget.initialFlightDetail?.destinationAirport != null) {
      _markers.add(
        Marker(
          markerId: const MarkerId('destination'),
          position: LatLng(
            widget.initialFlightDetail!.destinationAirport!.latitude,
            widget.initialFlightDetail!.destinationAirport!.longitude,
          ),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
          infoWindow: InfoWindow(
            title: widget.initialFlightDetail!.destinationAirport!.name,
          ),
        ),
      );
    }
  }

  void _setupStaticFlightPath(LatLng currentLatLong) {
    _staticPolyline.add(
      Polyline(
        polylineId: const PolylineId("static_route"),
        color: Colors.orange,
        width: 1,
        points: [
          currentLatLong,
          LatLng(
            widget.initialFlightDetail!.destinationAirport!.latitude,
            widget.initialFlightDetail!.destinationAirport!.longitude,
          ),
        ],
      ),
    );
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
        title: Text("Tracking Stopped"),
        content: Text(
          "You’ve become inactive. Flight tracking has been stopped.",
        ),
        actions: [
          TextButton(
            onPressed: () {
              context.read<FlightMapCubit>().stopTrackingFlight();
              Navigator.of(ctx).pop();
              Navigator.of(context).pop();
            },
            child: Text("OK"),
          ),
        ],
      ),
    );
  }

  void _showFlightLandedDialog() {
    if (!mounted) return;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.white,
        title: Text("Tracking Temporarily Unavailable"),
        content: Text(
          "Tracking data for ${widget.flightNumber} (Call sign: ${widget.initialFlight?.callSign ?? "N/A"}) is currently unavailable on Avioflai. This usually happens when the aircraft is outside coverage or the flight has ended.",
        ),
        actions: [
          TextButton(
            onPressed: () {
              _alertShownOfTrackingStopped = false;
              context.read<FlightMapCubit>().stopTrackingFlight();
              Navigator.of(ctx).pop();
              Navigator.of(context).pop();
            },
            child: Text("OK"),
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

  void _appendFlightNextCoordinates(LatLng newPoint) {
    // Lock first point once
    if (_flightTrailStart == null) {
      _flightTrailStart = newPoint;
      _flightNextCoordinatesPoints.clear();

      if (widget.initialFlightDetail?.originAirport?.latitude != null &&
          widget.initialFlightDetail?.originAirport?.longitude != null) {
        _flightNextCoordinatesPoints.add(
          LatLng(
            widget.initialFlightDetail!.originAirport!.latitude,
            widget.initialFlightDetail!.originAirport!.longitude,
          ),
        );
        _flightNextCoordinatesPoints.add(_flightTrailStart!);
      } else {
        _flightNextCoordinatesPoints.add(_flightTrailStart!);
      }
      return;
    }

    if (_flightNextCoordinatesPoints.isEmpty) {
      _flightNextCoordinatesPoints.add(newPoint);
      return;
    }

    final last = _flightNextCoordinatesPoints.last;

    const double minDistance = 0.00005;
    if ((last.latitude - newPoint.latitude).abs() < minDistance &&
        (last.longitude - newPoint.longitude).abs() < minDistance) {
      return;
    }

    _flightNextCoordinatesPoints.add(newPoint);

    if (widget.initialFlightDetail?.destinationAirport?.latitude != null &&
        widget.initialFlightDetail?.destinationAirport?.longitude != null) {
      _setupStaticFlightPath(newPoint);

      if (widget.initialFlightDetail?.originAirport?.latitude != null &&
          widget.initialFlightDetail?.originAirport?.longitude != null) {
        _flightNextLocationCoordinates = {
          Polyline(
            polylineId: const PolylineId("flight_trail"),
            color: Colors.blue,
            width: 2,
            points: List.unmodifiable(_flightNextCoordinatesPoints),
          ),
        };
      }
    }
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

    // Calculate direction
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
      //_flightMarker = movingMarker;
      _markers.removeWhere((m) => m.markerId.value == widget.flightNumber);
      _markers.add(movingMarker);
    });

    _positionAnimation!.addListener(() {
      if (!mounted) return;
      final pos = _positionAnimation!.value;
      movingMarker = movingMarker.copyWith(positionParam: pos);

      _appendFlightNextCoordinates(pos);
      setState(() {
        _markers.removeWhere((m) => m.markerId.value == widget.flightNumber);
        _markers.add(movingMarker);
      });
    });

    _animationController!.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _currentFlightPosition = to;
        _mapController?.animateCamera(CameraUpdate.newLatLng(to));

        // Process queued update
        if (_pendingTarget != null) {
          final nextTarget = _pendingTarget!;
          _pendingTarget = null;
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
          if (state.status == CommonApiStatus.success &&
              state.isLoading == false &&
              state.isFlightLanded == true) {
            if (_alertShownOfTrackingStopped == false) {
              _showFlightLandedDialog();
              _alertShownOfTrackingStopped = true;
            }
          }

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
                        polylines: _staticPolyline.union(
                          _flightNextLocationCoordinates,
                        ),
                        zoomGesturesEnabled: true,
                        initialCameraPosition: CameraPosition(
                          target: flightLatLng,
                          zoom: 8,
                        ),
                        myLocationEnabled: true,
                        markers: _markers,
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
