import 'dart:async';
import 'dart:math';

import 'package:avionics_internal/Constants/ApiClass/api_service.dart';
import 'package:avionics_internal/bloc/MapSection/flight_map_repository.dart'
    hide Position;
import 'package:avionics_internal/bloc/Home/AircraftComparison/AircraftComparisonModel.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import '../../Constants/ApiClass/ApiErrorModel.dart';
import '../../Constants/ApiClass/SessionTokenClass/session_Common_Token_Error.dart';
import '../../Helpers/push_notifications/LocalNotificationHelper.dart';
import 'AircraftStationList/aircraft_Station_List_Model.dart';
import 'AircraftStationList/aircraft_Station_List_Repository.dart';
import 'FilterMap/filter_Map_Cubit.dart';
import 'MapAircraftList/aircraft_List_Data_Cubit.dart';
import 'MapAircraftList/aircraft_List_Data_Repository.dart';
import 'flight_map_model.dart';
import 'flight_map_state.dart';
import 'flight_map_detailModel.dart';

class FlightMapCubit extends Cubit<FlightMapState> {
  FlightMapCubit() : super(FlightMapState());

  Timer? _trackingTimer;

  Future<bool> getCurrentLocation(BuildContext context) async {
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
        return false;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          emit(
            state.copyWith(
              status: CommonApiStatus.failure,
              isLoading: false,
              errorMessage:
                  'Location permissions are permanently denied.\n   Please enable them from settings.',
            ),
          );
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Location permissions are permanently denied.\n   Please enable them from settings.',
              ),
            ),
          );
          return false;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        emit(
          state.copyWith(
            status: CommonApiStatus.failure,
            isLoading: false,
            errorMessage:
                'Location permissions are permanently denied.\n   Please enable them from settings.',
          ),
        );

        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Location Permission'),
            content: const Text(
              'Location permissions are permanently denied.\n   Please enable them from settings.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () async {
                  Navigator.of(context).pop();
                  await Geolocator.openAppSettings();
                },
                child: const Text('Open Settings'),
              ),
            ],
          ),
        );
        return false;
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

      return true; // Successfully got location
    } catch (e) {
      emit(
        state.copyWith(
          status: CommonApiStatus.failure,
          errorMessage: e.toString(),
          isLoading: false,
        ),
      );
      return false;
    }
  }

  // fetch Aircraft Details From Flights List...... For The Map List.....
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

  void setSelectedFlight(FlightModel flight) {
    emit(state.copyWith(selectedFlight: flight));
  }

  void setSelectedAirport(AircraftStationModel airportModel) {
    emit(state.copyWith(selectedAirport: airportModel));
  }

  LatLngBounds? _previousBounds;

  Future<void> fetchFlightsByBounds({
    required bool isNeedToRefresh,
    required LatLngBounds bounds,
    required BuildContext context,
    required LatLng currentCenterLatLong,
  }) async {
    try {
      _previousBounds = bounds;

      final boundsString =
          "${bounds.northeast.latitude},${bounds.southwest.latitude},"
          "${bounds.southwest.longitude},${bounds.northeast.longitude}";

      final hasAircraftFilter =
          state.selectedAircraftIcaos != null &&
          state.selectedAircraftIcaos!.isNotEmpty;
      final hasCategoryFilter =
          state.selectedCategories != null &&
          state.selectedCategories!.isNotEmpty;

      final flights = await FlightRepository().getFlights(
        bounds: boundsString,
        aircraft: hasAircraftFilter
            ? state.selectedAircraftIcaos!.join(',')
            : null,
        categories: hasCategoryFilter
            ? state.selectedCategories!
                  .map((cat) => _getCategoryCode(cat))
                  .join(',')
            : null,
      );

      final airportList = await AircraftStationListRepository()
          .getListOfAllAircraftStationAccordingToLatLong(
            longitude: currentCenterLatLong.longitude.toString(),
            latitude: currentCenterLatLong.latitude.toString(),
          );

      //https://fr24api.flightradar24.com/api/live/flight-positions/full?bounds=32.252355981477805,28.99138728132285,75.73254201561213,77.71007940173149&limit=20&aircraft=AN2,AN24&altitude_ranges=0-46000&categories=C,C

      // https://fr24api.flightradar24.com/api/live/flight-positions/full?bounds=32.252355981477805,28.99138728132285,75.73254201561213,77.71007940173149&limit=20&aircraft=A318,A320,A20N,A21N&altitude_ranges=0-46000&categories=C,P
      debugPrint(
        "Flights fetched: ${flights.length}\n"
        "Airport list count: ${airportList.data.length}",
      );

      emit(
        state.copyWith(
          flights: flights,
          airports: airportList.data,
          status: CommonApiStatus.success,
          isSuccess: true,
          isLoading: false,
        ),
      );
    } catch (e, stack) {
      debugPrint("❌ Error fetching flights: $e");
      debugPrint(stack.toString());
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

  String _getCategoryCode(String label) {
    switch (label) {
      case "CARGO":
        return "C";
      case "BUSINESS_JETS":
        return "B";
      case "PASSENGER":
        return "P";
      case "GLIDERS":
        return "G";
      default:
        return "";
    }
  }

  void setFilters(List<String> categories, List<String> aircraftIcaos) {
    emit(
      state.copyWith(
        selectedCategories: categories,
        selectedAircraftIcaos: aircraftIcaos,
      ),
    );
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
          aircraftId: '',
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
    return "${dateTime.toUtc().toIso8601String().split('.').first}Z";
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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error fetching flight details: ${e.toString()}'),
        ),
      );
      emit(state.copyWith(isLoading: false));
      // emit(
      //   state.copyWith(
      //     status: CommonApiStatus.failure,
      //     errorMessage: 'Error fetching flight details: ${e.toString()}',
      //     isLoading: false,
      //   ),
      // );
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

      final response = await FlightRepository().getFlightPositions(
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
      } else {
        if (flights.isEmpty) {
          emit(
            state.copyWith(
              status: CommonApiStatus.success,
              isLoading: false,
              flights: state.flights,
              isFlightLanded: true,
            ),
          );
        }
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

  // void stopTrackingFlight() {
  //   if (_trackingTimer != null) {
  //     _trackingTimer?.cancel();
  //     _trackingTimer = null;
  //   }
  //   emit(state.copyWith(isTracking: false,isFlightLanded:false));
  // }

  void stopTrackingFlight({String? flightNumber, String? destination}) {
    if (_trackingTimer != null) {
      _trackingTimer?.cancel();
      _trackingTimer = null;
    }

    emit(state.copyWith(isTracking: false, isFlightLanded: false));

    if (!kIsWeb && flightNumber != null) {
      LocalNotificationHelper.show(
        title: "Flight landed",
        body: destination != null
            ? "Flight Number $flightNumber has landed at $destination."
            : "Flight Number $flightNumber has landed.",
        screenName: "flightDetails",
      );
    }
  }

  void clearSelectedFlightDetail() {
    emit(state.copyWith(selectedFlightDetail: null));
  }

  Future<void> refreshFlightPosition({
    required String flightNumber,
    required BuildContext context,
  }) async {
    emit(state.copyWith(isLoading: true));

    try {
      final response = await FlightRepository().getFlightPositions(
        flightNumber,
      );
      if (response?.flights != null && response!.flights.isNotEmpty) {
        final updatedFlight = response.flights.first;

        emit(
          state.copyWith(
            selectedFlight: updatedFlight,
            isLoading: false,
            status: CommonApiStatus.success,
          ),
        );
      } else {
        emit(
          state.copyWith(
            isLoading: false,
            status: CommonApiStatus.failure,
            errorMessage: "No flight position data found.",
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          status: CommonApiStatus.failure,
          errorMessage: e.toString(),
        ),
      );
      SessionCommonTokenError.handleUnauthorizedError(context, e);
    }
  }
}
