import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../Constants/Validators.dart';
import 'manageAcc_state.dart';

class ManageaccCubit extends Cubit<ManageAccState> {
  ManageaccCubit() : super(ManageAccState());

  void firstNameChanged(String firstName) {
    final error = Validators().validateName(firstName);
    _emitUpdatedState(firstName: firstName, firstNameError: error);
  }

  void lastNameChanged(String lastName) {
    final error = Validators().validateName(lastName);
    _emitUpdatedState(lastName: lastName, lastNameError: error);
  }

  void emailChanged(String email) {
    final error = Validators().validateEmail(email);
    _emitUpdatedState(email: email, emailError: error);
  }

  void _emitUpdatedState({
    String? firstName,
    String? lastName,
    String? email,
    String? firstNameError,
    String? lastNameError,
    String? emailError,
  }) {
    final newFirstName = firstName ?? state.firstName;
    final newLastName = lastName ?? state.lastName;
    final newEmail = email ?? state.email;

    final updatedFirstNameError =
        firstNameError ?? Validators().validateName(newFirstName);
    final updatedLastNameError =
        lastNameError ?? Validators().validateName(newLastName);

    final isValid =
        updatedFirstNameError == null &&
        updatedLastNameError == null &&
        newFirstName.isNotEmpty &&
        newLastName.isNotEmpty &&
        newEmail.isNotEmpty;

    emit(
      state.copyWith(
        firstName: newFirstName,
        lastName: newLastName,
        email: newEmail,
        firstNameError: updatedFirstNameError,
        lastNameError: updatedLastNameError,
        isButtonEnabled: isValid,
      ),
    );
  }
}
