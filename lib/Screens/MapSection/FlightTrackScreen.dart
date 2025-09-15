import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../Constants/ApiClass/ApiErrorModel.dart';
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
    Key? key,
  }) : super(key: key);

  @override
  State<TrackFlightScreen> createState() => _TrackFlightScreenState();
}

class _TrackFlightScreenState extends State<TrackFlightScreen>
    with TickerProviderStateMixin {
  Timer? _timer;
  GoogleMapController? _mapController;
  Marker? _flightMarker;
  LatLng? _currentFlightPosition;
  AnimationController? _animationController;
  Animation<LatLng>? _positionAnimation;

  @override
  void initState() {
    super.initState();
    if (widget.initialFlight != null) {
      _currentFlightPosition = LatLng(
        widget.initialFlight!.latitude,
        widget.initialFlight!.longitude,
      );
    }
    context.read<FlightMapCubit>().startTrackingFlight(
      widget.flightNumber,
      context,
    );
    _timer = Timer.periodic(const Duration(seconds: 60), (timer) {
      if (!mounted) return;
      context.read<FlightMapCubit>().fetchFlightDetails(
        flightId: widget.flightId ?? widget.flightNumber,
        context: context,
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    context.read<FlightMapCubit>().stopTrackingFlight();
    _mapController?.dispose();
    _animationController?.dispose();
    super.dispose();
  }

  Future<BitmapDescriptor> _getFlightMarkerIcon(double track) async {
    return await getRotatedPlaneIcon(track, color: Colors.red);
  }

  void _animateFlight(LatLng from, LatLng to, double track) async {
    _animationController?.stop();
    _animationController?.removeListener(() {});
    _animationController?.removeStatusListener((_) {});
    _animationController?.dispose();
    _animationController = null;
    _positionAnimation = null;
    _flightMarker = null;

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 120),
    );

    final tween = LatLngTween(
      begin: from,
      end: to,
    ).chain(CurveTween(curve: Curves.linear));

    _positionAnimation = tween.animate(_animationController!);

    final icon = await _getFlightMarkerIcon(track);

    var movingMarker = Marker(
      markerId: MarkerId(widget.flightNumber),
      position: from,
      icon: icon,
      infoWindow: InfoWindow(
        title: widget.initialFlight?.callSign ?? 'Flight',
        snippet:
        '${widget.initialFlightDetail?.departureIcao ?? 'N/A'} → ${widget
            .initialFlightDetail?.arrivalIcao ?? 'N/A'}',
      ),
    );

    setState(() {
      _flightMarker = movingMarker;
    });

    _positionAnimation!.addListener(() {
      if (!mounted) return;
      final pos = _positionAnimation!.value;
      print(
        "pos=-=----==$pos,Shown on the Map New long=-=----==${_currentFlightPosition
            ?.longitude}, lat=-=----==${_currentFlightPosition?.latitude}",
      );
      movingMarker = movingMarker.copyWith(positionParam: pos);

      setState(() {
        _flightMarker = movingMarker;
      });
    });

    _animationController!.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _currentFlightPosition = to;
        _mapController?.animateCamera(CameraUpdate.newLatLng(to));
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
              print(
                "Api Fetch New Lat long=-=----==${_currentFlightPosition
                    ?.longitude}, New Lat lat=-=----==${_currentFlightPosition
                    ?.latitude}",
              );
              _animateFlight(
                _currentFlightPosition!,
                newPos,
                state.selectedFlight!.track.toDouble(),
                // durationSeconds: state.animationDuration ?? 50,
              );
            } else {
              final icon = await _getFlightMarkerIcon(
                state.selectedFlight!.track.toDouble(),
              );

              setState(() {
                _flightMarker = Marker(
                  markerId: MarkerId(widget.flightNumber),
                  position: newPos,
                  icon: icon,
                  infoWindow: InfoWindow(
                    title: state.selectedFlight!.callSign ?? 'Unknown',
                    snippet:
                    '${state.selectedFlightDetail?.departureIcao ??
                        'N/A'} → ${state.selectedFlightDetail?.arrivalIcao ??
                        'N/A'}',
                  ),
                );
              });
              _mapController?.animateCamera(CameraUpdate.newLatLng(newPos));
            }
            _currentFlightPosition = newPos;
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
                    future: _getFlightMarkerIcon(flight?.track.toDouble() ?? 0),
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
                          '${detail?.departureIcao ?? 'N/A'} → ${detail
                              ?.arrivalIcao ?? 'N/A'}',
                        ),
                      );
                      return GoogleMap(
                        rotateGesturesEnabled: false,
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
                  child: FlightCard(flightDetail: detail),
                ),
                Positioned(
                  top: 40,
                  left: 10,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
                    onPressed: () {
                      _timer?.cancel();
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
