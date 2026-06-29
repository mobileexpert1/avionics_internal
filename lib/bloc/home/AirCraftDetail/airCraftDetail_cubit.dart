import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

import '../../../Constants/ApiClass/SessionTokenClass/session_Common_Token_Error.dart';
import '../../../Helpers/NoInternetDialog.dart';
import 'airCraftDetail_repository.dart';
import 'airCraftDetail_state.dart';

class AirCraftDetailCubit extends Cubit<AirCraftDetailState> {
  final AirCraftRepository repository = AirCraftRepository();

  AirCraftDetailCubit() : super(const AirCraftDetailState());

  Future<void> fetchAircraftDetailById(
    String aircraftId,
    BuildContext context,
  ) async {
    if (await InternetConnection().hasInternetAccess) {
      emit(state.copyWith(airCraftDetails: null));
      emit(state.copyWith(isLoading: true, isSuccess: false, isError: false));
      try {
        final aircraftDetail = await repository.getAirCraftData(aircraftId);
        emit(
          state.copyWith(
            isLoading: false,
            isSuccess: true,
            airCraftDetails: aircraftDetail,
          ),
        );
      } catch (e) {
        SessionCommonTokenError.handleUnauthorizedError(context, e);
        emit(
          state.copyWith(
            isLoading: false,
            isError: true,
            errorMessage: e.toString(),
          ),
        );
      }
    } else {
      NoInternetDialog.show(
        context,
        onRetry: () async {
          await fetchAircraftDetailById(aircraftId, context);
        },
      );
    }
  }

  Future<void> fetchAircraftDetailByICAOCode(
    String ICAOCode,
    BuildContext context,
  ) async {
    emit(
      state.copyWith(
        airCraftDetails: null,
        isLoading: true,
        isError: false,
        isSuccess: false,
      ),
    );
    if (await InternetConnection().hasInternetAccess) {
      try {
        final aircraftDetail = await repository.getAirCraftDetailICAOCode(
          ICAOCode,
        );
        if (aircraftDetail?.results == null) {
          emit(
            state.copyWith(
              airCraftDetails: null,
              isLoading: false,
              isSuccess: false,
            ),
          );
        } else {
          emit(
            state.copyWith(
              airCraftDetails: aircraftDetail,
              isLoading: false,
              isSuccess: true,
            ),
          );
        }
      } catch (e) {
        SessionCommonTokenError.handleUnauthorizedError(context, e);
        emit(
          state.copyWith(
            isLoading: false,
            isError: true,
            errorMessage: e.toString(),
            airCraftDetails: null,
          ),
        );
      }
    } else {
      NoInternetDialog.show(
        context,
        onRetry: () async {
          await fetchAircraftDetailByICAOCode(ICAOCode, context);
        },
      );
    }
  }
}
