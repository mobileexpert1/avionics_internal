import 'package:flutter_bloc/flutter_bloc.dart';
import 'airCraftDetail_repository.dart';
import 'airCraftDetail_state.dart';

class AirCraftDetailCubit extends Cubit<AirCraftDetailState> {
  final AirCraftRepository repository=AirCraftRepository();

  AirCraftDetailCubit() : super(const AirCraftDetailState());

  Future<void> fetchAircraftDetailById(String aircraftId) async {
    emit(state.copyWith(isLoading: true, isSuccess: false, isError: false));

    try {
      final aircraftDetail = await repository.getAirCraftData(aircraftId);
      emit(state.copyWith(
        isLoading: false,
        isSuccess: true,
        airCraftDetails: aircraftDetail
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        isError: true,
        errorMessage: e.toString(),
      ));
    }
  }
}
