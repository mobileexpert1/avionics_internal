import 'package:flutter_bloc/flutter_bloc.dart';
import '../../Constants/Validators.dart';
import 'forgot_state.dart';

class ForgotCubit extends Cubit<ForgotState> {
  ForgotCubit() : super(ForgotState());

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
