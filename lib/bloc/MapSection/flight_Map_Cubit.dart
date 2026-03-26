import 'dart:async';
import 'package:avionics_internal/bloc/MapSection/flight_map_repository.dart'
    hide Position;
import 'package:avionics_internal/bloc/Home/AircraftComparison/AircraftComparisonModel.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../Constants/ApiClass/ApiErrorModel.dart';
import '../../Constants/ApiClass/SessionTokenClass/session_Common_Token_Error.dart';
import '../../Helpers/push_notifications/LocalNotificationHelper.dart';
import 'AircraftStationList/aircraft_Station_List_Model.dart';
import 'AircraftStationList/aircraft_Station_List_Repository.dart';
import 'FilterMap/filter_Map_State.dart';
import 'MapAircraftList/aircraft_List_Data_Repository.dart';
import 'flight_map_model.dart';
import 'flight_map_state.dart';
import 'flight_map_detailModel.dart';

class FlightMapCubit extends Cubit<FlightMapState> {
  FlightMapCubit() : super(FlightMapState());

  Timer? _trackingTimer;
  Set<String>? _favCallSigns;

  void FavoriteFlights(Set<String> favCallSigns) {
    _favCallSigns = favCallSigns;

    if (state.flights == null || state.flights!.isEmpty) {
      debugPrint('Flights not loaded yet, storing favCallSigns');
      return;
    }

    _favoritesToFlights();
  }

  void _favoritesToFlights() {
    if (_favCallSigns == null || state.flights == null) return;

    final updatedFlights = state.flights!.map((flight) {
      final isFav = _favCallSigns!.contains(flight.callSign);

      if (isFav) {
        debugPrint('FAV MATCHED CallSign => ${flight.callSign}');
      }

      return flight.copyWith(isFavorite: isFav);
    }).toList();

    if (!isClosed) {
      emit(state.copyWith(flights: updatedFlights));
    }
  }

  void onFlightsLoaded(List<FlightModel> flights) {
    if (!isClosed) {
      emit(state.copyWith(flights: flights));
      if (_favCallSigns != null) {
        _favoritesToFlights();
      }
    }
  }

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

      if (!isClosed) {
      emit(
        state.copyWith(
          position: position,
          status: CommonApiStatus.success,
          isSuccess: true,
          isLoading: false,
        ),
      );
      }

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
        if (!isClosed) {
          emit(
            state.copyWith(
              flights: enrichedFlights,
              status: CommonApiStatus.success,
              isSuccess: true,
              isLoading: false,
            ),
          );
        }
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

  void changeMapType(CustomMapType type) {
    emit(state.copyWith(mapType: type));
  }

  void setSelectedFlight(FlightModel flight) {
    emit(state.copyWith(selectedFlight: flight));
  }

  void setSelectedAirport(AircraftStationModel airportModel) {
    emit(state.copyWith(selectedAirport: airportModel));
  }

  Future<void> fetchFlightsByBounds({
    required bool isNeedToRefresh,
    required LatLngBounds bounds,
    required BuildContext context,
    required LatLng currentCenterLatLong,
  }) async {
    try {

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

      debugPrint("Flights fetched: ${flights.length}");
      debugPrint("Airport list count: ${airportList.data.length}");

      onFlightsLoaded(flights);
      if (!isClosed) {
        emit(
          state.copyWith(
            flights: flights,
            airports: airportList.data,
            status: CommonApiStatus.success,
            isSuccess: true,
            isLoading: false,
          ),
        );
      }
    } catch (e, stack) {
      debugPrint("Error fetching flights: $e");
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
        screenName: "trackFlight",
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

  void toggleFavoriteByCallSign(String? callSign) {
    if (callSign == null || state.flights == null) return;

    final updatedFlights = state.flights!.map((flight) {
      if (flight.callSign == callSign) {
        return flight.copyWith(isFavorite: !(flight.isFavorite));
      }
      return flight;
    }).toList();

    emit(state.copyWith(flights: updatedFlights));
  }
}
