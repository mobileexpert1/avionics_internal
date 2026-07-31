import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

import '../../../Constants/ApiClass/SessionTokenClass/session_Common_Token_Error.dart';
import '../../../Constants/ApiClass/shared_prefs_helper.dart';
import '../../../Helpers/NoInternetDialog.dart';
import 'FlightInfoParamsResponse.dart';
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

  Future<void> resetAllTheDataBeforeEnter() async {
    emit(AirCraftDetailState());
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
            airCraftDetails: null,
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
          await fetchAircraftDetailByICAOCode(ICAOCode, context);
        },
      );
    }
  }

  String getFieldValue(String key, String isForLiveDetails) {
    final response = isForLiveDetails.contains("Live") == true
        ? state.flightParamsLiveResponse
        : state.aircraftParamsInfoResponse;
    if (response == null || response.data == null) {
      return 'N/A';
    }
    try {
      final item = response.data!.firstWhere((e) => e.parameter == key);
      return item.info ?? 'N/A';
    } catch (_) {
      return 'N/A';
    }
  }

  Future<FlightInfoParamsResponse?> _getFlightParams(
    BuildContext context,
    int actionNumber,
  ) async {
    final cacheKey = 'flight_params_$actionNumber';

    try {
      final cachedResponse = await SharedPrefsHelper.getString(cacheKey);

      if (cachedResponse != null && cachedResponse.isNotEmpty) {
        return FlightInfoParamsResponse.fromJson(jsonDecode(cachedResponse));
      }

      if (!await InternetConnection().hasInternetAccess) {
        return null;
      }

      final response = await repository.getTheFlightInfoParamsResponse(
        actionNumber,
      );

      await SharedPrefsHelper.saveString(
        cacheKey,
        jsonEncode(response?.toJson()),
      );

      return response;
    } catch (e) {
      SessionCommonTokenError.handleUnauthorizedError(context, e);
      rethrow;
    }
  }

  Future<void> fetchFlightLiveInfoParams(
    BuildContext context,
    int actionNumber,
  ) async {
    try {
      emit(state.copyWith(isLoading: true, isSuccess: false, isError: false));

      final response = await _getFlightParams(context, actionNumber);

      if (response == null) {
        NoInternetDialog.show(
          context,
          onRetry: () => fetchFlightLiveInfoParams(context, actionNumber),
        );
        return;
      }

      emit(
        state.copyWith(
          flightParamsLiveResponse: response,
          isLoading: false,
          isSuccess: true,
          isError: false,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          isSuccess: false,
          isError: true,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> fetchAircraftParams(
    BuildContext context,
    int actionNumber,
  ) async {
    try {
      emit(state.copyWith(isLoading: true, isSuccess: false, isError: false));

      final aircraftResponse = await _getFlightParams(context, actionNumber);

      if (aircraftResponse == null) {
        NoInternetDialog.show(
          context,
          onRetry: () => fetchAircraftParams(context, actionNumber),
        );
        return;
      }

      final liveResponse = await _getFlightParams(context, 2);

      emit(
        state.copyWith(
          aircraftParamsInfoResponse: aircraftResponse,
          flightParamsLiveResponse: liveResponse,
          isLoading: false,
          isSuccess: true,
          isError: false,
        ),
      );
    } catch (e) {
      SessionCommonTokenError.handleUnauthorizedError(context, e);

      emit(
        state.copyWith(
          isLoading: false,
          isSuccess: false,
          isError: true,
          errorMessage: e.toString(),
        ),
      );
    }
  }
}
