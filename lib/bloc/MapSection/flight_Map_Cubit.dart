import 'package:avionics_internal/bloc/MapSection/flight_map_repository.dart';
import 'dart:convert';
import 'package:avionics_internal/bloc/Home/AircraftComparison/AircraftComparisonModel.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../Constants/ApiClass/ApiErrorModel.dart';
import '../Home/AircraftComparison/AircraftComparisonModel.dart';
import 'MapAircraftList/aircraft_List_Data_Repository.dart';
import 'flight_map_model.dart';
import 'flight_map_state.dart';
import 'flight_map_detailModel.dart';
import 'flight_map_state.dart';
import 'flight_map_model.dart';
import 'flight_map_repository.dart';

class FlightMapCubit extends Cubit<FlightMapState> {
  FlightMapCubit() : super(FlightMapState());

  void changeMapType(MapType type) {
    emit(state.copyWith(mapType: type));
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
      print(
        'Current location: Lat=${position.latitude}, Lon=${position.longitude}',
      );

      final bounds = _calculateBounds(position);

      emit(state.copyWith(flights: [], isLoading: true));
      final flights = await FlightRepository().getFlights(bounds: bounds);
      print('Fetched ${flights.length} flights');

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

  Future<void> fetchAircraftDetailsFromFlightsList(
    List<String> uniqueTypes,
  ) async {
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

      print(
        'Fetched ${flightsDetails.detail} flights from AircraftListDataRepository',
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

  String formatUtc(DateTime dateTime) {
    // Format as UTC without milliseconds, with 'Z'
    return dateTime.toUtc().toIso8601String().split('.').first + "Z";
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

      print('Fetching flight details from: $formattedFrom to: $formattedTo');

      final response = await FlightRepository().getFlightDetails(
        flightId: flightId,
        fromDateTime: formattedFrom,
        toDateTime: formattedTo,
      );

      final flightDetail = response['flightDetail'] as FlightAircraftDetail;

      emit(
        state.copyWith(
          selectedFlightDetail: flightDetail,
          // Update with merged flight and aircraft details
          status: CommonApiStatus.success,
          isLoading: false,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: CommonApiStatus.failure,
          errorMessage: 'Error fetching flight details: ${e.toString()}',
          isLoading: false,
        ),
      );
    }
  }

  String _calculateBounds(Position position, {double delta = 5.0}) {
    final north = position.latitude + delta;
    final south = position.latitude - delta;
    final east = position.longitude + delta;
    final west = position.longitude - delta;
    print('Bounds: north=$north, south=$south, east=$east, west=$west');
    return "$north,$south,$east,$west";
  }

  void resetLocationState() {
    emit(FlightMapState());
  }
}
