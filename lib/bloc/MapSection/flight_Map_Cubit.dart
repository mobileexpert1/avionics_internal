import 'dart:async';

import 'package:avionics_internal/bloc/MapSection/flight_map_repository.dart'
    hide Position;
import 'package:avionics_internal/bloc/Home/AircraftComparison/AircraftComparisonModel.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../Constants/ApiClass/ApiErrorModel.dart';
import '../../Constants/ApiClass/SessionTokenClass/session_Common_Token_Error.dart';
import 'MapAircraftList/aircraft_List_Data_Repository.dart';
import 'flight_map_model.dart';
import 'flight_map_state.dart';
import 'flight_map_detailModel.dart';

class FlightMapCubit extends Cubit<FlightMapState> {
  FlightMapCubit() : super(FlightMapState());

  Timer? _trackingTimer;

  // fetch Aircraft Details From Flights List......
  Future<void> fetchAircraftDetailsFromFlightsList(
    List<String> uniqueTypes,
    BuildContext context,
  ) async {
    try {
      final flightsDetails = await AircraftListDataRepository()
          .getListOfAllPlanes(aircraftIds: uniqueTypes);

      if (flightsDetails.data.isNotEmpty) {
        final enrichedFlights = await mergeFlightsWithDetails(
          state.flights ?? [],
          flightsDetails.data,
        );
        emit(
          state.copyWith(
            flights: enrichedFlights,
            status: CommonApiStatus.success,
            isSuccess: true,
            isLoading: false,
          ),
        );
      }
    } catch (e) {
      SessionCommonTokenError.handleUnauthorizedError(context, e);
      emit(
        state.copyWith(
          status: CommonApiStatus.failure,
          isSuccess: false,
          isLoading: false,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  void changeMapType(MapType type) {
    emit(state.copyWith(mapType: type));
  }

  String _calculateBounds(Position position, {double delta = 5.0}) {
    final north = position.latitude + delta;
    final south = position.latitude - delta;
    final east = position.longitude + delta;
    final west = position.longitude - delta;
    print('Bounds: north=$north, south=$south, east=$east, west=$west');
    return "$north,$south,$east,$west";
  }

  String formatUtc(DateTime dateTime) {
    return "${dateTime.toUtc().toIso8601String().split('.').first}Z";
  }

  void setSelectedFlight(FlightModel flight) {
    emit(state.copyWith(selectedFlight: flight));
  }

  Future<void> getCurrentLocation(BuildContext context) async {
    emit(state.copyWith(status: CommonApiStatus.submitting, isLoading: true));

    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        emit(
          state.copyWith(
            status: CommonApiStatus.failure,
            errorMessage: 'Location services are disabled.',
            isLoading: false,
          ),
        );
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          emit(
            state.copyWith(status: CommonApiStatus.failure, isLoading: false),
          );
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permissions are denied')),
          );
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        emit(state.copyWith(status: CommonApiStatus.failure, isLoading: false));
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Location permissions are permanently denied'),
          ),
        );
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      final bounds = _calculateBounds(position);
      emit(state.copyWith(flights: [], isLoading: true));

      final flights = await FlightRepository().getFlights(bounds: bounds);

      emit(
        state.copyWith(
          position: position,
          flights: flights,
          status: CommonApiStatus.success,
          isSuccess: true,
          isLoading: false,
        ),
      );
    } on PlatformException catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Platform error: ${e.message}')));
      emit(
        state.copyWith(
          status: CommonApiStatus.failure,
          errorMessage: 'Platform error: ${e.message}',
          isLoading: false,
        ),
      );
    } catch (e) {
      SessionCommonTokenError.handleUnauthorizedError(context, e);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
      emit(
        state.copyWith(
          status: CommonApiStatus.failure,
          errorMessage: 'Something went wrong: ${e.toString()}',
          isLoading: false,
        ),
      );
    }
  }

  Future<List<FlightModel>> mergeFlightsWithDetails(
    List<FlightModel> flights,
    List<AircraftModel> aircraftDetails,
  ) async {
    return flights.map((flight) {
      final matchingDetail = aircraftDetails.firstWhere(
        (detail) =>
            detail.icaoTypeCode.toUpperCase() == flight.type.toUpperCase(),
        orElse: () => AircraftModel(
          id: '',
          aircraftModel: '',
          isFavorite: false,
          icaoTypeCode: '',
          image: '',
        ),
      );
      return flight.copyWith(aircraftDetails: matchingDetail);
    }).toList();
  }

  Future<void> fetchFlightDetails({
    required String flightId,
    required BuildContext context,
  }) async {
    try {
      final now = DateTime.now().toUtc();
      final from = now.subtract(const Duration(hours: 24));
      final formattedFrom = formatUtc(from);
      final formattedTo = formatUtc(now);

      final response = await FlightRepository().getFlightDetails(
        flightId: flightId,
        fromDateTime: formattedFrom,
        toDateTime: formattedTo,
      );

      final flightDetail = response['flightDetail'] as FlightAircraftDetail;

      emit(
        state.copyWith(
          selectedFlightDetail: flightDetail,
          status: CommonApiStatus.success,
          isLoading: false,
        ),
      );
    } catch (e) {
      SessionCommonTokenError.handleUnauthorizedError(context, e);
      emit(
        state.copyWith(
          status: CommonApiStatus.failure,
          errorMessage: 'Error fetching flight details: ${e.toString()}',
          isLoading: false,
        ),
      );
    }
  }

  void startTrackingFlight(String flightId, BuildContext context) {
    if (_trackingTimer != null && _trackingTimer!.isActive) {
      return;
    }
    if (!isClosed) emit(state.copyWith(isTracking: true));

    _fetchAndUpdateFlight(flightId, context);

    _trackingTimer = Timer.periodic(Duration(seconds: 60), (timer) {
      if (isClosed) {
        timer.cancel();
        return;
      }
      _fetchAndUpdateFlight(flightId, context);
    });
  }

  Future<void> _fetchAndUpdateFlight(
    String flightNumber,
    BuildContext context,
  ) async {
    if (isClosed) return;

    try {
      final position = state.position;
      if (position == null) {
        Future.delayed(Duration(seconds: 5), () {
          if (!isClosed) {
            _fetchAndUpdateFlight(flightNumber, context);
          }
        });
        return;
      }

      final bounds = _calculateBounds(position);
      final response = await FlightRepository().getFlightPositions(
        bounds,
        flightNumber,
      );
      final flights = response?.flights as List<FlightModel>;
      if (flights.isNotEmpty && !isClosed) {
        final updatedFlight = flights.first;
        emit(
          state.copyWith(
            selectedFlight: updatedFlight,
            status: CommonApiStatus.success,
            isLoading: false,
            flights: state.flights,
          ),
        );
      }
    } catch (e) {
      if (isClosed) return;
      SessionCommonTokenError.handleUnauthorizedError(context, e);
      emit(
        state.copyWith(
          status: CommonApiStatus.failure,
          errorMessage: 'Error tracking flight: ${e.toString()}',
          isLoading: false,
        ),
      );
    }
  }

  void stopTrackingFlight() {
    if (_trackingTimer != null) {
      _trackingTimer?.cancel();
      _trackingTimer = null;
    }
    emit(state.copyWith(isTracking: false));
  }
}
