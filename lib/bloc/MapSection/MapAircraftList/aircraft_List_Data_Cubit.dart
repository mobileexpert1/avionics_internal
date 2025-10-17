import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import '../../../Constants/ApiClass/ApiErrorModel.dart';
import '../../../Constants/ApiClass/SessionTokenClass/session_Common_Token_Error.dart';
import '../../../Database/generic_methods.dart';
import '../../Home/AircraftComparison/AircraftComparisonModel.dart';
import 'aircraft_List_Data_State.dart';
import 'aircraft_List_Data_Repository.dart';

class AircraftListDataCubit extends Cubit<AircraftListDataState> {
  AircraftListDataCubit() : super(AircraftListDataState.initial());

  final GenericMethods<AircraftModel> _genericMethods =
  GenericMethods<AircraftModel>(AircraftModel.fromJson);
  List<AircraftModel> selectedAircraft = [];

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

  Future<void> searchAircraftByICAO({
    required String icaoCode,
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
      final response = await AircraftListDataRepository().searchAircraftByICAO(icaoCode);

      emit(
        state.copyWith(
          aircraftList: response.data,
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

  void clearResults() {
    emit(state.copyWith(aircraftList: []));
  }

  void removeAircraft(String? icaoCode) {
    final updated = List.of(state.aircraftList)
      ..removeWhere((a) => a.icaoTypeCode == icaoCode);
    emit(state.copyWith(aircraftList: updated));
  }


  Future<void> addSelectedAircraft(AircraftModel aircraft) async {
    final exists = selectedAircraft.any((a) => a.icaoTypeCode == aircraft.icaoTypeCode);
    if (selectedAircraft.length < 5 && !exists) {
      selectedAircraft.add(aircraft);
      await _genericMethods.insertAll([aircraft]);
      emit(state.copyWith());
    }
  }


  Future<void> removeSelectedAircraft(String? icaoCode) async {
    if (icaoCode != null) {
      final aircraftToRemove = selectedAircraft.firstWhere(
            (a) => a.icaoTypeCode == icaoCode,
        orElse: () => throw Exception('Aircraft not found'),
      );
      selectedAircraft.removeWhere((a) => a.icaoTypeCode == icaoCode);
      await _genericMethods.deleteById('selected_aircraft', aircraftToRemove.id);
      emit(state.copyWith());
    }
  }

  Future<void> initSelectedAircraft(List<AircraftModel> aircraft) async {
    selectedAircraft.clear();
    selectedAircraft = [...aircraft];
    await _genericMethods.insertAll(aircraft);
    emit(state.copyWith());
  }

  Future<void> loadSelectedAircraft() async {
    selectedAircraft = await _genericMethods.getAll('selected_aircraft');
    emit(state.copyWith());
  }
}