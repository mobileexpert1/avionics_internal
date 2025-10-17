import 'package:bloc/bloc.dart';
import '../flight_map_model.dart';
import 'package:flutter/material.dart';
import '../../../Constants/ApiClass/ApiErrorModel.dart';
import '../MapAircraftList/aircraft_List_Data_Repository.dart';
import '../../Home/AircraftComparison/AircraftComparisonModel.dart';
import 'package:avionics_internal/bloc/MapSection/flight_map_repository.dart'
    as repo;
import '../../../Constants/ApiClass/SessionTokenClass/session_Common_Token_Error.dart';
import 'package:avionics_internal/bloc/MapSection/MapSeacrhAircraftList/map_Search_Aircraft_List_Model.dart';
import 'package:avionics_internal/bloc/MapSection/MapSeacrhAircraftList/map_Search_Aircraft_List_State.dart';
import 'package:avionics_internal/bloc/MapSection/MapSeacrhAircraftList/map_Search_Aircraft_List_repository.dart';

class MapSearchAircraftListCubit extends Cubit<MapSearchAircraftListState> {
  MapSearchAircraftListCubit() : super(MapSearchAircraftListState.initial());

  Future<void> loadListOfAllLiveFlights({
    required String querySearch,
    required BuildContext context,
  }) async {
    emit(
      state.copyWith(
        isLoading: true,
        isSuccess: false,
        status: CommonApiStatus.submitting,
      ),
    );

    try {
      final response = await MapSearchAircraftListRepository()
          .getListOfAllLiveFlights(querySearch: querySearch);

      emit(
        state.copyWith(
          flights: response.results,
          isLoading: false,
          isSuccess: true,
          status: CommonApiStatus.success,
        ),
      );

      if (response.results.isNotEmpty) {
        final typeList = response.results.map((f) => f.detail.acType).toList();
        final uniqueTypes = typeList.toSet().toList();
        fetchAircraftDetailsFromFlightsList(uniqueTypes);
      }
    } catch (e) {
      SessionCommonTokenError.handleUnauthorizedError(context, e);
      emit(
        state.copyWith(
          isLoading: false,
          isSuccess: false,
          status: CommonApiStatus.failure,
          errorMessage: e.toString(),
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
        state.flights,
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
  }

  Future<List<FlightResult>> mergeFlightsWithDetails(
    List<FlightResult> flights,
    List<AircraftModel> aircraftDetails,
  ) async {
    return flights.map((flight) {
      final matchingDetail = aircraftDetails.firstWhere(
        (detail) => detail.icaoTypeCode.toUpperCase().contains(
          flight.detail.acType.toUpperCase(),
        ),
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

  Future<List<FlightResult>> mergeFlightsResponseDetails(
    List<FlightResult> flights,
    List<FlightModel> aircraftDetails,
  ) async {
    if (flights.isEmpty) return [];

    return flights.map((flight) {
      print("➡ Checking flight: ${flight.detail.flight}");

      final matchingDetail = aircraftDetails.firstWhere(
        (detail) {
          final isMatch =
              detail.flightNumber.toUpperCase() ==
              flight.detail.flight.toUpperCase();

          print(
            "   Comparing: detail.flightNumber=${detail.flightNumber} "
            "with flight.detail.flight=${flight.detail.flight} "
            "=> ${isMatch ? 'MATCH' : 'NO MATCH'}",
          );

          return isMatch;
        },
        orElse: () {
          print("No matching detail found for flight: ${flight.detail.flight}");
          return FlightModel(
            id: '',
            flightNumber: '',
            callSign: '',
            latitude: 0,
            longitude: 0,
            track: 0,
            altitude: 0,
            groundSpeed: 0,
            verticalSpeed: 0,
            squawk: '',
            timestamp: DateTime.timestamp(),
            source: '',
            hex: '',
            type: '',
            registration: '',
            paintedAs: '',
            operatingAs: '',
            departureIata: '',
            departureIcao: '',
            arrivalIata: '',
            arrivalIcao: '',
          );
        },
      );

      print(
        "Selected detail for ${flight.detail.flight}: ${matchingDetail.flightNumber}",
      );
      return flight.copyWith(flightDetailResponse: matchingDetail);
    }).toList();
  }

  Future<void> getCurrentSearchFlight(
    FlightResult flightDetails,
    BuildContext context,
  ) async {
    emit(state.copyWith(status: CommonApiStatus.submitting));

    try {
      // Fetch flights
      final flightsDetails = await repo.FlightRepository()
          .getParticularFlightDetails(flightId: flightDetails.detail.flight);

      if (flightsDetails.flights.isNotEmpty) {
        final enrichedFlight = await mergeFlightsResponseDetails(
          state.flights,
          flightsDetails.flights,
        );

        final selected = enrichedFlight.firstWhere(
          (f) => f.detail.flight == flightDetails.detail.flight,
          orElse: () => enrichedFlight.first,
        );
        emit(
          state.copyWith(
            status: CommonApiStatus.success,
            isLoading: false,
            selectedFlight: selected,
          ),
        );
      }else{
        emit(
          state.copyWith(
            status: CommonApiStatus.failure,
            errorMessage: 'Tracking not available',
            isLoading: false,
          ),
        );
      }
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
}
