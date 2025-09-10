import 'package:avionics_internal/bloc/MapSection/MapSeacrhAircraftList/map_Search_Aircraft_List_State.dart';
import 'package:avionics_internal/bloc/MapSection/MapSeacrhAircraftList/map_Search_Aircraft_List_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import '../../../Constants/ApiClass/ApiErrorModel.dart';
import '../../../Constants/ApiClass/SessionTokenClass/session_Common_Token_Error.dart';

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
}
