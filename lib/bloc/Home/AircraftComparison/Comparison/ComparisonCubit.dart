import 'package:avionics_internal/bloc/Home/AircraftComparison/Comparison/ComparisonRepository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../Constants/ApiClass/ApiErrorModel.dart';
import '../../../../Constants/ApiClass/SessionTokenClass/session_Common_Token_Error.dart';
import 'ComparisonModel.dart';
import 'ComparisonState.dart';


class ComparisonCubit extends Cubit<ComparisonState> {
  ComparisonCubit() : super(const ComparisonState());

  Future<void> fetchComparison({
    required BuildContext context,
    required String aircraft1Id,
    required String aircraft2Id,
  }) async {
    emit(state.copyWith(
      isLoading: true,
      status: CommonApiStatus.submitting,
      errorMessage: null,
      apiError: null,
      isSuccess: false,
    ));

    try {
      final comparisonModel = await ComparisonRepository().compareAircrafts(
        aircraft1Id: aircraft1Id,
        aircraft2Id: aircraft2Id,
      );

      emit(state.copyWith(
        comparisonModel: comparisonModel,
        isLoading: false,
        isSuccess: true,
        status: CommonApiStatus.success,
      ));
    } catch (e) {
      SessionCommonTokenError.handleUnauthorizedError(context, e);

      String? errorMessage;
      String? apiError;

      try {
        final parsed = ApiErrorModel.fromJson(e as Map<String, dynamic>);
        apiError = parsed.toString();
      } catch (_) {
        errorMessage = e.toString();
      }

      emit(state.copyWith(
        isLoading: false,
        isSuccess: false,
        status: CommonApiStatus.failure,
        errorMessage: errorMessage,
        apiError: apiError,
      ));
    }
  }
}
