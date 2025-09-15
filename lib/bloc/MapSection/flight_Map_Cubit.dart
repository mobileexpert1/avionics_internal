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
import '../../Helpers/MapSection/rotatePlane_icon.dart';
import '../../Screens/MapSection/FlightMapscreen.dart';
import 'MapAircraftList/aircraft_List_Data_Repository.dart';
import 'flight_map_model.dart';
import 'flight_map_state.dart';
import 'flight_map_detailModel.dart';

class FlightMapCubit extends Cubit<FlightMapState> {
  Timer? _trackingTimer;

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

  void updateMarkers(Set<Marker> markers) {
    emit(state.copyWith(markers: markers));
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

  Future<void> _fetchAndUpdateFlight(
    String flightNumber,
    BuildContext context,
  // {
    // int animationDuration = 50,
  // }
  ) async {
    if (isClosed) return;
    try {
      final position = state.position;
      if (position == null) return;

      final bounds = _calculateBounds(position);

      final response = await FlightRepository().getFlightPositions(
        bounds: bounds,
        flightNumber: flightNumber,
      );

      final flights = response['flights'] as List<FlightModel>;
      if (flights.isNotEmpty && !isClosed) {
        final updatedFlight = flights.first;
        emit(
          state.copyWith(
            selectedFlight: updatedFlight,
            // animationDuration: animationDuration,
            status: CommonApiStatus.success,
            isLoading: false,
            flights: state.flights,
          ),
        );
      }
    } catch (e) {
      if (isClosed) return;
      emit(
        state.copyWith(
          status: CommonApiStatus.failure,
          errorMessage: 'Error tracking flight: ${e.toString()}',
          isLoading: false,
        ),
      );
    }
  }

  void startTrackingFlight(String flightNumber, BuildContext context) {
    stopTrackingFlight();
    if (!isClosed) {
      emit(state.copyWith(isTracking: true));
    }
    _fetchAndUpdateFlight(flightNumber, context);
    _trackingTimer = Timer.periodic(const Duration(seconds: 60), (timer) {
      _fetchAndUpdateFlight(flightNumber, context);
    });
  }

  // void startTrackingFlight(String flightNumber, BuildContext context) {
  //   stopTrackingFlight(); // cancel old timer if any
  //   if (!isClosed) {
  //     emit(state.copyWith(isTracking: true));
  //   }
  //
  //   // Step 1: First call after 5 sec
  //   // Step 1: 10 sec → 8s
  //   Timer(const Duration(seconds: 10), () {
  //     if (isClosed) return;
  //     _fetchAndUpdateFlight(flightNumber, context, animationDuration: 8);
  //
  //     // Step 2: 10 sec → 8s
  //     Timer(const Duration(seconds: 10), () {
  //       if (isClosed) return;
  //       _fetchAndUpdateFlight(flightNumber, context, animationDuration: 8);
  //
  //       // Step 3: 10 sec → 8s
  //       Timer(const Duration(seconds: 10), () {
  //         if (isClosed) return;
  //         _fetchAndUpdateFlight(flightNumber, context, animationDuration: 8);
  //
  //         // Step 4: 20 sec → 16s
  //         Timer(const Duration(seconds: 20), () {
  //           if (isClosed) return;
  //           _fetchAndUpdateFlight(flightNumber, context, animationDuration: 16);
  //
  //           // Step 5: 20 sec → 16s
  //           Timer(const Duration(seconds: 20), () {
  //             if (isClosed) return;
  //             _fetchAndUpdateFlight(flightNumber, context, animationDuration: 16);
  //
  //             // Step 6: 35 sec → 30s
  //             Timer(const Duration(seconds: 35), () {
  //               if (isClosed) return;
  //               _fetchAndUpdateFlight(flightNumber, context, animationDuration: 30);
  //
  //               // Step 7: periodic 60 sec → 50s
  //               _trackingTimer = Timer.periodic(const Duration(seconds: 60), (timer) {
  //                 if (isClosed) return;
  //                 _fetchAndUpdateFlight(flightNumber, context, animationDuration: 50);
  //               });
  //             });
  //           });
  //         });
  //       });
  //     });
  //   });
  //
  // }

  // Stop tracking a flight
  void stopTrackingFlight() {
    _trackingTimer?.cancel();
    _trackingTimer = null;
    emit(state.copyWith(isTracking: false));
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

  //
  void setSelectedFlight(FlightModel flight) {
    emit(state.copyWith(selectedFlight: flight));
  }

  void clearSelectedFlight() {
    emit(state.copyWith(selectedFlight: null));
  }
}
