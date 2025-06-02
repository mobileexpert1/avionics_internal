import 'package:avionics_internal/bloc/createNewPassword/createNewPassword_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../Constants/Validators.dart';

class CreatenNewPasswordCubit extends Cubit<CreateNewPasswordState> {
  CreatenNewPasswordCubit() : super(CreateNewPasswordState());

  void passwordChanged(String password) {
    final error = Validators().validatePassword(password);
    _emitUpdatedState(password: password, passwordError: error);
  }

  void confirmPasswordChanged(String confirmPassword) {
    final error = Validators().validateConfirmPassword(
      state.password,
      confirmPassword,
    );
    _emitUpdatedState(
      confirmPassword: confirmPassword,
      confirmPasswordError: error,
    );
  }

  void _emitUpdatedState({
    String? password,
    String? confirmPassword,
    String? passwordError,
    String? confirmPasswordError,
  }) {
    final newPassword = password ?? state.password;
    final newConfirmPassword = confirmPassword ?? state.confirmPassword;

    final updatedPasswordError =
        passwordError ?? Validators().validatePassword(newPassword);
    final updatedConfirmPasswordError =
        confirmPasswordError ??
            Validators().validateConfirmPassword(newPassword, newConfirmPassword);

    final isValid =
            updatedPasswordError == null &&
            updatedConfirmPasswordError == null &&
            newPassword.isNotEmpty &&
            newConfirmPassword.isNotEmpty;

    emit(
      state.copyWith(
        password: newPassword,
        confirmPassword: newConfirmPassword,
        passwordError: updatedPasswordError,
        confirmPasswordError: updatedConfirmPasswordError,
        isButtonEnabled: isValid,
      ),
    );
  }
}
