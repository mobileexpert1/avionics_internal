import 'package:avionics_internal/Screens/Profile/Avtar/AvtarScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../Constants/ApiClass/ApiErrorModel.dart';
import '../../Screens/Onboarding/Otp/OtpScreen.dart';
import 'signup_repository.dart';
import 'signup_state.dart';
import '../../Constants/Validators.dart';

class SignupCubit extends Cubit<SignupState> {
  SignupCubit() : super(SignupState());

  void firstNameChanged(String value) {
    emit(
      state.copyWith(
        firstName: value,
        isButtonEnabled: _canEnableButton(
          value,
          state.lastName,
          state.email,
          state.password,
          state.confirmPassword,
        ),
      ),
    );
  }

  void lastNameChanged(String value) {
    emit(
      state.copyWith(
        lastName: value,
        isButtonEnabled: _canEnableButton(
          state.firstName,
          value,
          state.email,
          state.password,
          state.confirmPassword,
        ),
      ),
    );
  }

  void emailChanged(String value) {
    emit(
      state.copyWith(
        email: value,
        isButtonEnabled: _canEnableButton(
          state.firstName,
          state.lastName,
          value,
          state.password,
          state.confirmPassword,
        ),
      ),
    );
  }

  void passwordChanged(String value) {
    emit(
      state.copyWith(
        password: value,
        isButtonEnabled: _canEnableButton(
          state.firstName,
          state.lastName,
          state.email,
          value,
          state.confirmPassword,
        ),
      ),
    );
  }

  void confirmPasswordChanged(String value) {
    emit(
      state.copyWith(
        confirmPassword: value,
        isButtonEnabled: _canEnableButton(
          state.firstName,
          state.lastName,
          state.email,
          state.password,
          value,
        ),
      ),
    );
  }

  bool _canEnableButton(
    String fn,
    String ln,
    String email,
    String pass,
    String confirmPass,
  ) {
    return fn.isNotEmpty &&
        ln.isNotEmpty &&
        email.isNotEmpty &&
        pass.isNotEmpty &&
        confirmPass.isNotEmpty;
  }

  Future<void> verifyEmailRegisteredOrNot(BuildContext context) async {
    final firstNameError = Validators().validateName(state.firstName);
    final lastNameError = Validators().validateName(state.lastName);
    final emailError = Validators().validateEmail(state.email);
    final passwordError = Validators().validatePassword(state.password);
    final confirmPasswordError = Validators().validateConfirmPassword(
      state.password,
      state.confirmPassword,
    );

    final hasError = [
      firstNameError,
      lastNameError,
      emailError,
      passwordError,
      confirmPasswordError,
    ].any((error) => error != null);

    emit(
      state.copyWith(
        firstNameError: firstNameError,
        lastNameError: lastNameError,
        emailError: emailError,
        passwordError: passwordError,
        confirmPasswordError: confirmPasswordError,
      ),
    );

    if (hasError) return;

    emit(
      state.copyWith(status: CommonApiStatus.submitting, errorMessage: null),
    );

    try {
      await SignupRepository().checkIsEmailAlreadyResgisteredOrNot(
        email: state.email,
      );

      emit(state.copyWith(status: CommonApiStatus.success));

      final signupData = {
        'first_name': state.firstName,
        'last_name': state.lastName,
        'email': state.email,
        'password': state.password,
        'username': state.firstName + state.lastName,
        'phone_number': '',
        'professional_role': '',
        'experience_level': '',
        'user_type': '',
        'auth_type': '',
      };

      print(signupData);

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) =>
              AvtarScreen(isComeFromSignupScreen: true, signupData: signupData),
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
}
