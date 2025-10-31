import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../Constants/ApiClass/ApiErrorModel.dart';
import 'savedFlight_state.dart';
import 'savedFlight_repository.dart';

class SavedFlightCubit extends Cubit<SavedFlightState> {
  SavedFlightCubit()
      : super(
    SavedFlightState(
      savedflight: [],
      isLoading: false,
      isSuccess: false,
      apiError: null,
      status: CommonApiStatus.initial,
      errorMessage: null, favorites: [],
    ),
  );

  /// ✅ Fetch Saved and Favorite Flights
  Future<void> loadSavedAndFavoriteFlights() async {
    emit(state.copyWith(
      isLoading: true,
      status: CommonApiStatus.initial,
      errorMessage: null,
    ));

    try {
      final response = await SavedFlightRepository().getSavedAndFavoriteAircrafts();

      emit(
        state.copyWith(
          isLoading: false,
          isSuccess: true,
          status: CommonApiStatus.success,
          savedflight: response.saved,
          favorites: response.favorite,
        ),
      );
    } catch (e) {
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
