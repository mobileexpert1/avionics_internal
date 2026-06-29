import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

import '../../../Constants/ApiClass/ApiErrorModel.dart';
import '../../../Constants/ApiClass/SessionTokenClass/session_Common_Token_Error.dart';
import '../../../Constants/ApiClass/shared_prefs_helper.dart';
import '../../../Helpers/NoInternetDialog.dart';
import 'unit_selection_repository.dart';
import 'unit_selection_state.dart';

class UnitSelectionCubit extends Cubit<UnitSelectionState> {
  UnitSelectionCubit(BuildContext context)
    : super(
        const UnitSelectionInitial(
          speed: 'Kts',
          altitude: 'Feet',
          distance: 'Miles',
          temperature: 'Celsius',
          isLoading: false,
          isSuccess: false,
        ),
      ) {
    getUnitPreferences(context);
  }

  final UnitSelectionRepository repository = UnitSelectionRepository();

  Future<void> getUnitPreferences(BuildContext context) async {
    if (await InternetConnection().hasInternetAccess) {
      final currentState = state;
      emit(
        UnitSelectionInitial(
          speed: currentState is UnitSelectionInitial ? currentState.speed : '',
          altitude: currentState is UnitSelectionInitial
              ? currentState.altitude
              : '',
          distance: currentState is UnitSelectionInitial
              ? currentState.distance
              : '',
          temperature: currentState is UnitSelectionInitial
              ? currentState.temperature
              : '',
          isLoading: true,
          isSuccess: false,
          status: CommonApiStatus.submitting,
        ),
      );

      try {
        final token = await SharedPrefsHelper.getUserAccessToken();
        final response = await repository.getUnitPreferences(token: token!);

        final selectedSpeed = response.speed
            .firstWhere((e) => e.isSelected, orElse: () => response.speed.first)
            .unit;
        final selectedAltitude = response.altitude
            .firstWhere(
              (e) => e.isSelected,
              orElse: () => response.altitude.first,
            )
            .unit;
        final selectedDistance = response.distance
            .firstWhere(
              (e) => e.isSelected,
              orElse: () => response.distance.first,
            )
            .unit;
        final selectedTemperature = response.temperature
            .firstWhere(
              (e) => e.isSelected,
              orElse: () => response.temperature.first,
            )
            .unit;

        emit(
          UnitSelectionInitial(
            speed: selectedSpeed,
            altitude: selectedAltitude,
            distance: selectedDistance,
            temperature: selectedTemperature,
            isLoading: false,
            isSuccess: true,
            status: CommonApiStatus.success,
          ),
        );
      } catch (e) {
        SessionCommonTokenError.handleUnauthorizedError(context, e);

        emit(
          UnitSelectionInitial(
            speed: '',
            altitude: '',
            distance: '',
            temperature: '',
            isLoading: false,
            isSuccess: false,
            errorMessage: e.toString(),
            status: CommonApiStatus.failure,
          ),
        );
      }
    } else {
      NoInternetDialog.show(
        context,
        onRetry: () => getUnitPreferences(context),
      );
    }
  }

  void selectSpeed(String value) {
    final currentState = state;
    if (currentState is UnitSelectionInitial) {
      emit(currentState.copyWith(speed: value));
    }
  }

  void selectAltitude(String value) {
    final currentState = state;
    if (currentState is UnitSelectionInitial) {
      emit(currentState.copyWith(altitude: value));
    }
  }

  void selectDistance(String value) {
    final currentState = state;
    if (currentState is UnitSelectionInitial) {
      emit(currentState.copyWith(distance: value));
    }
  }

  void selectTemperature(String value) {
    final currentState = state;
    if (currentState is UnitSelectionInitial) {
      emit(currentState.copyWith(temperature: value));
    }
  }

  Future<void> submitPreferences(BuildContext context) async {
    if (await InternetConnection().hasInternetAccess) {
      final currentState = state;
      if (currentState is! UnitSelectionInitial) return;

      emit(
        currentState.copyWith(
          isLoading: true,
          isSuccess: false,
          status: CommonApiStatus.submitting,
        ),
      );

      try {
        final token = await SharedPrefsHelper.getUserAccessToken();

        final result = await repository.updateUnitPreferences(
          token: token!,
          speed: currentState.speed,
          altitude: currentState.altitude,
          distance: currentState.distance,
          temperature: currentState.temperature,
        );

        final selectedSpeed = result.speed
            .firstWhere((e) => e.isSelected, orElse: () => result.speed.first)
            .unit;
        final selectedAltitude = result.altitude
            .firstWhere(
              (e) => e.isSelected,
              orElse: () => result.altitude.first,
            )
            .unit;
        final selectedDistance = result.distance
            .firstWhere(
              (e) => e.isSelected,
              orElse: () => result.distance.first,
            )
            .unit;
        final selectedTemperature = result.temperature
            .firstWhere(
              (e) => e.isSelected,
              orElse: () => result.temperature.first,
            )
            .unit;

        emit(
          UnitSelectionInitial(
            speed: selectedSpeed,
            altitude: selectedAltitude,
            distance: selectedDistance,
            temperature: selectedTemperature,
            isLoading: false,
            isSuccess: true,
            status: CommonApiStatus.success,
          ),
        );
      } catch (e) {
        SessionCommonTokenError.handleUnauthorizedError(context, e);

        emit(
          currentState.copyWith(
            isLoading: false,
            isSuccess: false,
            errorMessage: e.toString(),
            status: CommonApiStatus.failure,
          ),
        );
      }
    } else {
      NoInternetDialog.show(context, onRetry: () => submitPreferences(context));
    }
  }
}
