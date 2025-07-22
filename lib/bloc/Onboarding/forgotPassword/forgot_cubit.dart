import 'package:avionics_internal/Screens/Onboarding/Otp/OtpScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../Constants/ApiClass/ApiErrorModel.dart';
import '../../../Constants/ApiClass/SessionTokenClass/session_Common_Token_Error.dart';
import '../../../Constants/Validators.dart';
import 'forgot_repository.dart';
import 'forgot_state.dart';

class ForgotCubit extends Cubit<ForgotState> {
  ForgotCubit() : super(ForgotState());

  void emailChanged(String email) {
    emit(state.copyWith(
      email: email,
      isButtonEnabled: email.isNotEmpty,
    ));
  }

  Future<void> validateAndSubmit(BuildContext context) async {
    final emailError = Validators().validateEmail(state.email);

    if (emailError != null) {
      emit(state.copyWith(emailError: emailError));
      return;
    }

    await forgotUserApi(context);
  }

  Future<void> forgotUserApi(BuildContext context) async {
    emit(
      state.copyWith(status: CommonApiStatus.submitting, errorMessage: null),
    );
    try {
      await ForgotRepository().forgotUserApi(email: state.email);

      emit(state.copyWith(status: CommonApiStatus.success));

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) =>
              OtpScreen(email: state.email, isComeFromSignup: false),
        ),
      );
    } catch (e) {
      SessionCommonTokenError.handleUnauthorizedError(context, e);
      emit(
        state.copyWith(
          status: CommonApiStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }
}
