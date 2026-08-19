import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

import '../../../../../Constants/ApiClass/ApiErrorModel.dart';
import '../../../../../Constants/ApiClass/SessionTokenClass/session_Common_Token_Error.dart';
import '../jettingTheWorld_repository.dart';
import 'jetting_BoardingPasses_state.dart';

class JettingBoardingPassCubit extends Cubit<JettingBoardingPassState> {
  JettingBoardingPassCubit() : super(const JettingBoardingPassState());

  Future<void> loadAirports(BuildContext context) async {
    if (!await InternetConnection().hasInternetAccess) {
      return;
    }

    try {
      emit(
        state.copyWith(
          isLoading: true,
          isSuccess: false,
          status: CommonApiStatus.initial,
        ),
      );

      final response = await JettingTheWorldRepository().getUnlockedAirports();

      if (response == null || response.data.isEmpty) {
        emit(
          state.copyWith(
            isLoading: false,
            isSuccess: false,
            status: CommonApiStatus.failure,
            errorMessage: 'No boarding passes found',
          ),
        );
        return;
      }

      emit(
        state.copyWith(
          jettingTheWorldModel: response,
          airportList: response.data,
          routeCoordinates: const [],
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
          errorMessage: e.toString(),
          status: CommonApiStatus.failure,
        ),
      );
    }
  }
}
