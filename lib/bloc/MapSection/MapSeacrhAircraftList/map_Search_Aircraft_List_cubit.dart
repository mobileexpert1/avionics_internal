import 'package:avionics_internal/bloc/MapSection/MapSeacrhAircraftList/map_Search_Aircraft_List_Model.dart';
import 'package:avionics_internal/bloc/MapSection/MapSeacrhAircraftList/map_Search_Aircraft_List_State.dart';
import 'package:avionics_internal/bloc/MapSection/MapSeacrhAircraftList/map_Search_Aircraft_List_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import '../../../Constants/ApiClass/ApiErrorModel.dart';
import '../../../Constants/ApiClass/SessionTokenClass/session_Common_Token_Error.dart';
import '../../Home/AircraftComparison/AircraftComparisonModel.dart';
import '../MapAircraftList/aircraft_List_Data_Repository.dart';

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
}
