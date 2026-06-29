import 'package:avionics_internal/Screens/Onboarding/ForgotCreateNewPassword/CreateNewPasswordScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

import '../../../Constants/ApiClass/ApiErrorModel.dart';
import '../../../Constants/ApiClass/shared_prefs_helper.dart';
import '../../../Helpers/AppNavigator.dart';
import '../../../Helpers/NoInternetDialog.dart';
import '../../../Screens/Onboarding/Subscription/SubscriptionPlanDetailScreen.dart';
import 'otp_repository.dart';
import 'otp_state.dart';

class OtpCubit extends Cubit<OtpState> {
  OtpCubit() : super(OtpState());

  Future<void> submitOtpApi(
    BuildContext context,
    String email,
    bool isFromSignup,
  ) async {
    if (await InternetConnection().hasInternetAccess) {
      emit(
        state.copyWith(status: CommonApiStatus.submitting, errorMessage: null),
      );
      try {
        final result = await OtpRepository().otpVerifyApi(
          email: email,
          otpType: isFromSignup == true ? 'sign_up' : 'forget_password',
          otp: state.otp,
        );

        emit(state.copyWith(status: CommonApiStatus.success));

        if (isFromSignup == true) {
          await SharedPrefsHelper.saveEmail(email);
          await SharedPrefsHelper.setUserAccessToken(result.accessToken ?? '');
          await SharedPrefsHelper.setUserRefreshToken(
            result.refreshToken ?? '',
          );
          await SharedPrefsHelper.saveIsUserLogin(true);
        }

        AppNavigator.pushReplacement(
          context,
          (isFromSignup == true)
              ? SubscriptionPlanDetailScreen(isComeFromSignup: true)
              : CreateNewPasswordScreen(email: email),
          disableSwipeBack: true,
        );
      } catch (e) {
        emit(
          state.copyWith(
            status: CommonApiStatus.failure,
            errorMessage: e.toString(),
          ),
        );
      }
    } else {
      NoInternetDialog.show(
        context,
        onRetry: () async {
          await submitOtpApi(context, email, isFromSignup);
        },
      );
    }
  }

  void otpChanged(String otp) {
    final error = _validateOtp(otp);
    _emitUpdatedState(otp: otp, otpError: error);
  }

  String? _validateOtp(String otp) {
    if (otp.length != 4) return 'Enter 4 digits';
    if (!RegExp(r'^\d+$').hasMatch(otp)) return 'Only numbers allowed';
    return null;
  }

  void _emitUpdatedState({String? otp, String? otpError}) {
    final newOtp = otp ?? state.otp;
    final updatedOtpError = otpError ?? _validateOtp(newOtp);

    final isValid = updatedOtpError == null && newOtp.isNotEmpty;

    emit(state.copyWith(otp: newOtp, isButtonEnabled: isValid));
  }

  Future<void> resendOtp(
    String email,
    bool isFromSignup,
    BuildContext context,
  ) async {
    if (await InternetConnection().hasInternetAccess) {
      try {
        emit(
          state.copyWith(
            status: CommonApiStatus.submitting,
            errorMessage: null,
          ),
        );

        await OtpRepository().otpVerifyApi(
          email: email,
          otp: '1234',
          otpType: isFromSignup ? 'sign_up' : 'forget_password',
          resend: true,
        );

        emit(state.copyWith(status: CommonApiStatus.success));
      } catch (e) {
        emit(
          state.copyWith(
            status: CommonApiStatus.failure,
            errorMessage: e.toString(),
          ),
        );
      }
    } else {
      NoInternetDialog.show(
        context,
        onRetry: () async {
          await resendOtp(email, isFromSignup, context);
        },
      );
    }
  }
}
