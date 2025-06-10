import 'package:avionics_internal/Home/HomeScreen.dart';
import 'package:avionics_internal/bloc/login/login_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../Constants/ApiClass/ApiErrorModel.dart';
import '../../Home/RootTabbar/RootTabbarScreen.dart';
import 'login_state.dart';
import '../../Constants/Validators.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginState());

  Future<void> loginUserApi(BuildContext context) async {
    emit(
      state.copyWith(status: CommonApiStatus.submitting, errorMessage: null),
    );
    try {
      await LoginRepository().loginUser(
        email: state.email,
        password: state.password,
      );

      emit(state.copyWith(status: CommonApiStatus.success));

      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => RootTabbarscreen()),
        (route) => false,
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

  void passwordChanged(String password) {
    final error = Validators().validatePassword(password);
    _emitUpdatedState(password: password, passwordError: error);
  }

  void _emitUpdatedState({
    String? email,
    String? password,
    String? emailError,
    String? passwordError,
  }) {
    final newEmail = email ?? state.email;
    final newPassword = password ?? state.password;

    final updatedEmailError =
        emailError ?? Validators().validateEmail(newEmail);
    final updatedPasswordError =
        passwordError ?? Validators().validatePassword(newPassword);

    final isValid =
        updatedEmailError == null &&
        updatedPasswordError == null &&
        newEmail.isNotEmpty &&
        newPassword.isNotEmpty;

    emit(
      state.copyWith(
        email: newEmail,
        password: newPassword,
        emailError: updatedEmailError,
        passwordError: updatedPasswordError,
        isButtonEnabled: isValid,
      ),
    );
  }
}
