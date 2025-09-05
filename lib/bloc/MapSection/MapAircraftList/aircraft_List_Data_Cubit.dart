import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import '../../../Constants/ApiClass/ApiErrorModel.dart';
import '../../../Constants/ApiClass/SessionTokenClass/session_Common_Token_Error.dart';
import 'aircraft_List_Data_State.dart';
import 'aircraft_List_Data_Repository.dart';

class AircraftListDataCubit extends Cubit<AircraftListDataState> {
  AircraftListDataCubit() : super(AircraftListDataState.initial());

  Future<void> loadListOfAllAirbusModels({
    required List<String> selectedAirbusId,
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
      final response = await AircraftListDataRepository().getListOfAllPlanes(
        aircraftIds: selectedAirbusId,
      );

      emit(
        state.copyWith(
          aircraftList: response.data,
          detail: response.detail,
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
