import 'package:flutter_bloc/flutter_bloc.dart';
import 'login_state.dart';
import '../../Constants/Validators.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginState());

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

    // Revalidate each field if its error is not explicitly passed

    
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
