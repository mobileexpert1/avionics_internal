import 'dart:ffi';

import 'package:avionics_internal/bloc/otp/otp_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../Constants/ApiClass/ApiErrorModel.dart';
import '../../Constants/ApiClass/shared_prefs_helper.dart';
import '../../Screens/Onboarding/Subscription/SubscriptionScreen.dart';
import 'otp_state.dart';

class OtpCubit extends Cubit<OtpState> {
  OtpCubit() : super(OtpState());

  Future<void> submitOtpApi(
    BuildContext context,
    String email,
    bool isFromSignup,
  ) async {
    emit(
      state.copyWith(status: CommonApiStatus.submitting, errorMessage: null),
    );
    try {
      await OtpRepository().otpVerifyApi(
        email: email,
        otp_type: isFromSignup == true ? 'sign_up' : 'forgot',
        otp: state.otp,
      );

      emit(state.copyWith(status: CommonApiStatus.success));

      await SharedPrefsHelper.saveEmail(email);
      await SharedPrefsHelper.saveIsUserLogin(true);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => SubscriptionScreen()),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: CommonApiStatus.failure,
          errorMessage: e.toString(),
        ),
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
}
