import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

import '../../../Constants/ApiClass/SessionTokenClass/session_Common_Token_Error.dart';
import '../../../Helpers/NoInternetDialog.dart';
import 'AirPlanePartsModel.dart';
import 'AirPlanePartsRepository.dart';
import 'AirPlanePartsState.dart';

class AirPlanePartsCubit extends Cubit<AirPlanePartsState> {
  AirPlanePartsCubit({
    required BuildContext context,
  }) : super(const AirPlanePartsState()) {
    loadAircraftParts(context);
  }

  Future<void> loadAircraftParts(BuildContext context) async {
    emit(
      state.copyWith(
        isLoading: true,
        errorMessage: null,
        isError: false,
        isSuccess: false,
      ),
    );

    if (await InternetConnection().hasInternetAccess) {
      try {
        final parts =
        await AirPlanePartsRepository().getAirplaneParts();

        emit(
          state.copyWith(
            parts: parts,
            isLoading: false,
            isError: false,
            isSuccess: true,
            errorMessage: null,
          ),
        );
      } catch (e) {
        SessionCommonTokenError.handleUnauthorizedError(
          context,
          e,
        );

        emit(
          state.copyWith(
            parts: [],
            isLoading: false,
            isError: true,
            isSuccess: false,
            errorMessage: e.toString(),
          ),
        );
      }
    } else {
      NoInternetDialog.show(
        context,
        onRetry: () async {
          await loadAircraftParts(context);
        },
      );
    }
  }

  void unlockPart(String id) {
    final updatedParts = state.parts.map((part) {
      if (part.id != id) {
        return part;
      }

      return part.copyWith(
        isUnlocked: true,
        collectedCount: part.totalCount,
      );
    }).toList();

    emit(
      state.copyWith(
        parts: updatedParts,
      ),
    );
  }

  void updatePartProgress({
    required String id,
    required int collectedCount,
  }) {
    final updatedParts = state.parts.map((part) {
      if (part.id != id) {
        return part;
      }

      final updatedCount =
      collectedCount.clamp(0, part.totalCount);

      return part.copyWith(
        collectedCount: updatedCount,
        isUnlocked: updatedCount >= part.totalCount,
      );
    }).toList();

    emit(
      state.copyWith(
        parts: updatedParts,
      ),
    );
  }

  Future<void> retryLoadAircraftParts(
      BuildContext context,
      ) async {
    await loadAircraftParts(context);
  }
}
