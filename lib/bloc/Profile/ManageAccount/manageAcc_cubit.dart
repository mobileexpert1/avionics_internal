import 'package:avionics_internal/Constants/ApiClass/ApiErrorModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

import '../../../Constants/ApiClass/SessionTokenClass/session_Common_Token_Error.dart';
import '../../../Constants/ApiClass/shared_prefs_helper.dart';
import '../../../Constants/Validators.dart';
import '../../../Constants/constantImages.dart';
import '../../../CustomFiles/Custom_SnackBar.dart';
import '../../../Helpers/NoInternetDialog.dart';
import 'manageAcc_repository.dart';
import 'manageAcc_state.dart';

class ManageaccCubit extends Cubit<ManageAccState> {
  final ManageAccountRepository repository = ManageAccountRepository();

  ManageaccCubit() : super(ManageAccState());

  void initializeUserData({
    required String userId,
    required String firstName,
    required String lastName,
    required String email,
    required String authType,
    required double tokenUsagePercentage,
    required double creditUsagePercentage,
  }) {
    emit(
      state.copyWith(
        userId: userId,
        firstName: firstName,
        lastName: lastName,
        email: email,
        authType: authType,
        isButtonEnabled: firstName.isNotEmpty && lastName.isNotEmpty,
        tokenUsagePercentage: tokenUsagePercentage,
        creditUsagePercentage: creditUsagePercentage,
      ),
    );
  }

  void firstNameChanged(String firstName) {
    emit(
      state.copyWith(
        firstName: firstName,
        firstNameError: null,
        isButtonEnabled: firstName.isNotEmpty && state.lastName.isNotEmpty,
      ),
    );
  }

  void lastNameChanged(String lastName) {
    emit(
      state.copyWith(
        lastName: lastName,
        lastNameError: null,
        isButtonEnabled: state.firstName.isNotEmpty && lastName.isNotEmpty,
      ),
    );
  }

  bool validateFields() {
    final firstNameError = Validators().validateName(state.firstName);
    final lastNameError = Validators().validateName(state.lastName);

    final isValid = firstNameError == null && lastNameError == null;

    emit(
      state.copyWith(
        firstNameError: firstNameError,
        lastNameError: lastNameError,
      ),
    );
    return isValid;
  }

  Future<void> fetchUserDetails(BuildContext context) async {
    if (await InternetConnection().hasInternetAccess) {
      emit(
        state.copyWith(
          isLoading: true,
          status: CommonApiStatus.submitting,
          errorMessage: null,
        ),
      );
      try {
        final user = await repository.getUserDetail();

        initializeUserData(
          userId: user.id,
          firstName: user.firstName,
          lastName: user.lastName,
          email: user.email,
          authType: user.authType,
          tokenUsagePercentage: user.tokenUsagePercentage ?? 0.0,
          creditUsagePercentage: user.creditUsagePercentage ?? 0.0,
        );

        emit(state.copyWith(isLoading: false, status: CommonApiStatus.success));
      } catch (e) {
        SessionCommonTokenError.handleUnauthorizedError(context, e);
        emit(
          state.copyWith(
            status: CommonApiStatus.failure,
            isLoading: false,
            errorMessage: e.toString(),
          ),
        );
      }
    } else {
      NoInternetDialog.show(context, onRetry: () => fetchUserDetails(context));
    }
  }

  Future<void> updateUserDetails(BuildContext context) async {
    if (await InternetConnection().hasInternetAccess) {
      emit(state.copyWith(isLoading: true, errorMessage: null));
      try {
        await repository.updateProfileInformation(
          firstName: state.firstName,
          lastName: state.lastName,
        );

        await SharedPrefsHelper.setUserProfileName(
          '${state.firstName ?? ''} ${state.lastName ?? ''}'.trim(),
        );

        emit(state.copyWith(isLoading: false, status: CommonApiStatus.success));
        AppSnackBar.custom(
          context,
          message: "Your profile has been successfully updated",
          svgAsset: CommonUi.setSvgImage(AssetsPath.successIcon),
        );
      } catch (e) {
        SessionCommonTokenError.handleUnauthorizedError(context, e);
        emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
      }
    } else {
      NoInternetDialog.show(context, onRetry: () => updateUserDetails(context));
    }
  }
}
