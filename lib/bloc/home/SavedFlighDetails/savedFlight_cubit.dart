import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

import '../../../Constants/ApiClass/ApiErrorModel.dart';
import '../../../Helpers/NoInternetDialog.dart';
import 'savedFlight_repository.dart';
import 'savedFlight_state.dart';

class SavedFlightCubit extends Cubit<SavedFlightState> {
  SavedFlightCubit()
    : super(
        SavedFlightState(
          savedflight: [],
          isLoading: false,
          isSuccess: false,
          apiError: null,
          status: CommonApiStatus.initial,
          errorMessage: null,
          favorites: [],
        ),
      );

  Future<void> loadSavedAndFavoriteFlights(BuildContext context) async {
    if (await InternetConnection().hasInternetAccess) {
      emit(
        state.copyWith(
          isLoading: true,
          status: CommonApiStatus.initial,
          errorMessage: null,
        ),
      );

      try {
        final response = await SavedFlightRepository()
            .getSavedAndFavoriteAircraft();

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
    } else {
      NoInternetDialog.show(
        context,
        onRetry: () => loadSavedAndFavoriteFlights(context),
      );
    }
  }
}
