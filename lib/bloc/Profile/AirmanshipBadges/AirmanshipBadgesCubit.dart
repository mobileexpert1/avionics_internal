import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import '../../../../../Constants/ApiClass/ApiErrorModel.dart';
import '../../../../../Constants/ApiClass/SessionTokenClass/session_Common_Token_Error.dart';
import 'AirmanshipBadgesRepository.dart';
import 'AirmanshipBadgesState.dart';

class AirmanshipBadgesCubit extends Cubit<AirmanshipBadgesState> {
  AirmanshipBadgesCubit() : super(const AirmanshipBadgesState());

  Future<void> loadAirmanshipBadges(BuildContext context) async {
    if (await InternetConnection().hasInternetAccess) {
      try {
        emit(state.copyWith(isLoading: true, status: CommonApiStatus.initial));

        final response = await AirmanshipBadgesRepository()
            .getAirmanshipBadges();

        if (response != null) {
          emit(
            state.copyWith(
              categories: response.data,
              isLoading: false,
              isSuccess: true,
              status: CommonApiStatus.success,
            ),
          );
        } else {
          emit(
            state.copyWith(
              isLoading: false,
              isSuccess: false,
              status: CommonApiStatus.failure,
              errorMessage: 'No data found',
            ),
          );
        }
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
    } else {
      emit(
        state.copyWith(
          isLoading: false,
          isSuccess: false,
          errorMessage: 'No internet connection',
          status: CommonApiStatus.failure,
        ),
      );
    }
  }
}
