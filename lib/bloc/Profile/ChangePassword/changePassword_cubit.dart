import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../Constants/Validators.dart';
import 'changePassword_state.dart';

class ChangePasswordCubit extends Cubit<CreateNewPasswordState> {
  ChangePasswordCubit() : super(CreateNewPasswordState());

  void oldPasswordChanged(String oldPassword) {
    final error = Validators().validatePassword(
      oldPassword,
    ); // or separate validator
    _emitUpdatedState(oldPassword: oldPassword, oldPasswordError: error);
  }

  void newPasswordChanged(String password) {
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
    String? oldPassword,
    String? password,
    String? confirmPassword,
    String? oldPasswordError,
    String? passwordError,
    String? confirmPasswordError,
  }) {
    final newOldPassword = oldPassword ?? state.oldPassword;
    final newPassword = password ?? state.password;
    final newConfirmPassword = confirmPassword ?? state.confirmPassword;

    final updatedOldPasswordError =
        oldPasswordError ?? Validators().validatePassword(newOldPassword);
    final updatedPasswordError =
        passwordError ?? Validators().validatePassword(newPassword);
    final updatedConfirmPasswordError =
        confirmPasswordError ??
        Validators().validateConfirmPassword(newPassword, newConfirmPassword);

    final isValid =
        updatedOldPasswordError == null &&
        updatedPasswordError == null &&
        updatedConfirmPasswordError == null &&
        newOldPassword.isNotEmpty &&
        newPassword.isNotEmpty &&
        newConfirmPassword.isNotEmpty;

    emit(
      state.copyWith(
        oldPassword: newOldPassword,
        password: newPassword,
        confirmPassword: newConfirmPassword,
        oldPasswordError: updatedOldPasswordError,
        passwordError: updatedPasswordError,
        confirmPasswordError: updatedConfirmPasswordError,
        isButtonEnabled: isValid,
      ),
    );
  }
}
