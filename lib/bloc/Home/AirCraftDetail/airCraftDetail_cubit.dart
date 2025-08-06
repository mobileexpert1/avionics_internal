import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../Constants/ApiClass/SessionTokenClass/session_Common_Token_Error.dart';
import 'airCraftDetail_repository.dart';
import 'airCraftDetail_state.dart';

class AirCraftDetailCubit extends Cubit<AirCraftDetailState> {
  final AirCraftRepository repository=AirCraftRepository();

  AirCraftDetailCubit() : super(const AirCraftDetailState());

  Future<void> fetchAircraftDetailById(String aircraftId, BuildContext context) async {
    emit(state.copyWith(airCraftDetails: null));
    emit(state.copyWith(isLoading: true, isSuccess: false, isError: false));
    try {
      final aircraftDetail = await repository.getAirCraftData(aircraftId);
      emit(state.copyWith(
        isLoading: false,
        isSuccess: true,
        airCraftDetails: aircraftDetail
      ));
    } catch (e) {
      SessionCommonTokenError.handleUnauthorizedError(context, e);
      emit(state.copyWith(
        isLoading: false,
        isError: true,
        errorMessage: e.toString(),
      ));
    }
  }
}
