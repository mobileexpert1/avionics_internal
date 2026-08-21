import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

import '../../../../../Constants/ApiClass/ApiErrorModel.dart';
import '../../../../../Constants/ApiClass/SessionTokenClass/session_Common_Token_Error.dart';
import '../jettingTheWorld_repository.dart';
import 'jettingChronicle_state.dart';

class JettingChronicleCubit extends Cubit<JettingChronicleState> {
  JettingChronicleCubit() : super(const JettingChronicleState());

  Future<void> loadChronicle(BuildContext context) async {
    if (await InternetConnection().hasInternetAccess) {
      try {
        emit(state.copyWith(isLoading: true, status: CommonApiStatus.initial));

        final response = await JettingTheWorldRepository()
            .getChronicleDetails();

        if (response != null) {
          emit(
            state.copyWith(
              chronicleModel: response.data,
              isLoading: false,
              isSuccess: true,
              status: CommonApiStatus.success,
            ),
          );
        }
      } catch (e) {
        SessionCommonTokenError.handleUnauthorizedError(context, e);

        emit(
          state.copyWith(
            isLoading: false,
            errorMessage: e.toString(),
            status: CommonApiStatus.failure,
          ),
        );
      }
    } else {
      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: 'No internet connection',
          status: CommonApiStatus.failure,
        ),
      );
    }
  }
}
