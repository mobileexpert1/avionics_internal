import 'dart:async';
import 'dart:math';

import 'package:avionics_internal/Constants/ApiClass/api_service.dart';
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

  // double getDynamicRadius(double zoom) {
  //   if (zoom < 5) {
  //     return 2000; // 2000 km for world view
  //   } else if (zoom < 10) {
  //     return 500; // 500 km
  //   } else if (zoom < 15) {
  //     return 50; // 50 km for city level
  //   } else if (zoom < 18) {
  //     return 5; // 5 km for street level
  //   } else {
  //     return 1; // 1 km for very close zoom
  //   }
  // }

  // LatLngBounds calculateNearbyBounds(
  //   LatLng centerLatLng, {
  //   required double zoom,
  // }) {
  //   final double distanceKm = getDynamicRadius(zoom);
  //
  //   print("Zoome distanceKm-=-=$distanceKm, Zoom Level $zoom");
  //   final double latOffset = distanceKm / 111;
  //   final double lonOffset =
  //       distanceKm / (111 * cos(centerLatLng.latitude * pi / 180));
  //
  //   final double latMin = centerLatLng.latitude - latOffset;
  //   final double latMax = centerLatLng.latitude + latOffset;
  //   final double lonMin = centerLatLng.longitude - lonOffset;
  //   final double lonMax = centerLatLng.longitude + lonOffset;
  //
  //   return LatLngBounds(
  //     southwest: LatLng(latMin, lonMin),
  //     northeast: LatLng(latMax, lonMax),
  //   );
  // }

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

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      emit(
        state.copyWith(
          position: position,
          status: CommonApiStatus.success,
          isSuccess: true,
          isLoading: false,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: CommonApiStatus.failure,
          errorMessage: e.toString(),
          isLoading: false,
        ),
      );
    }
  }

  LatLngBounds? _previousBounds;

  Future<void> fetchFlightsByBounds({
    required LatLngBounds bounds,
    required BuildContext context,
  }) async {
    // Agar bounds change nahi hua, API call skip karo
    if (_previousBounds != null &&
        _previousBounds!.southwest == bounds.southwest &&
        _previousBounds!.northeast == bounds.northeast) {
      debugPrint("Skipping fetch: same bounds as before");
      return;
    }

    _previousBounds = bounds;

    try {
      final boundsString =
          "${bounds.northeast.latitude},${bounds.southwest.latitude},"
          "${bounds.southwest.longitude},${bounds.northeast.longitude}";

      final flights = await FlightRepository().getFlights(bounds: boundsString);

      print("flights-=-=-=-$flights");

      emit(
        state.copyWith(
          flights: flights,
          status: CommonApiStatus.success,
          isSuccess: true,
          isLoading: false,
        ),
      );
    } catch (e) {
      SessionCommonTokenError.handleUnauthorizedError(context, e);
      emit(
        state.copyWith(
          status: CommonApiStatus.failure,
          errorMessage: e.toString(),
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

  Future<void> startTrackingFlight(
    String flightId,
    BuildContext context,
  ) async {
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
