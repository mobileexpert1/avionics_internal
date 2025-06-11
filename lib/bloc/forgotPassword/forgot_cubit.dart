import 'package:avionics_internal/Screens/Onboarding/Otp/OtpScreen.dart';
import 'package:avionics_internal/bloc/forgotPassword/forgot_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../Constants/ApiClass/ApiErrorModel.dart';
import '../../Constants/Validators.dart';
import '../../Home/RootTabbar/RootTabbarScreen.dart';
import 'forgot_state.dart';

class ForgotCubit extends Cubit<ForgotState> {
  ForgotCubit() : super(ForgotState());

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
      emit(
        state.copyWith(
          status: CommonApiStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  void emailChanged(String email) {
    final error = Validators().validateEmail(email);
    _emitUpdatedState(email: email, emailError: error);
  }

  void _emitUpdatedState({String? email, String? emailError}) {
    final newEmail = email ?? state.email;

    final updatedEmailError =
        emailError ?? Validators().validateEmail(newEmail);

    final isValid = updatedEmailError == null && newEmail.isNotEmpty;

    emit(
      state.copyWith(
        email: newEmail,
        emailError: updatedEmailError,
        isButtonEnabled: isValid,
      ),
    );
  }
}
