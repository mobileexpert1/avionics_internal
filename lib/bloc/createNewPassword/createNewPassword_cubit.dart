import 'package:flutter_bloc/flutter_bloc.dart';
import 'createNewPassword_state.dart';
import '../../Constants/Validators.dart';

class CreateNewPasswordCubit extends Cubit<CreateNewPasswordState> {
  CreateNewPasswordCubit() : super(CreateNewPasswordState());

  void passwordChanged(String password) {
    final passwordError = Validators().validatePassword(password);
    final confirmPasswordError = Validators().validateConfirmPassword(
      password,
      state.confirmPassword,
    );

    final isValid = _isFormValid(
      password,
      state.confirmPassword,
      passwordError,
      confirmPasswordError,
    );

    emit(state.copyWith(
      password: password,
      passwordError: passwordError,
      confirmPasswordError: confirmPasswordError,
      isButtonEnabled: isValid,
    ));
  }

  void confirmPasswordChanged(String confirmPassword) {
    final confirmPasswordError = Validators().validateConfirmPassword(
      state.password,
      confirmPassword,
    );

    final isValid = _isFormValid(
      state.password,
      confirmPassword,
      state.passwordError,
      confirmPasswordError,
    );

    emit(state.copyWith(
      confirmPassword: confirmPassword,
      confirmPasswordError: confirmPasswordError,
      isButtonEnabled: isValid,
    ));
  }

  bool _isFormValid(
      String password,
      String confirmPassword,
      String? passwordError,
      String? confirmPasswordError,
      ) {
    return passwordError == null &&
        confirmPasswordError == null &&
        password.isNotEmpty &&
        confirmPassword.isNotEmpty;
  }
}
