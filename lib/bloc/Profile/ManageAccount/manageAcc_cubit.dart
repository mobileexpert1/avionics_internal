import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../Constants/ApiClass/shared_prefs_helper.dart';
import '../../../Constants/Validators.dart';
import 'manageAcc_model.dart';
import 'manageAcc_repository.dart';
import 'manageAcc_state.dart';

class ManageaccCubit extends Cubit<ManageAccState> {
  ManageaccCubit() : super(ManageAccState());

  void initializeUserData({
    required String firstName,
    required String lastName,
    required String email,
  }) {
    emit(state.copyWith(
      firstName: firstName,
      lastName: lastName,
      email: email,
      firstNameError: Validators().validateName(firstName),
      lastNameError: Validators().validateName(lastName),
      emailError: Validators().validateEmail(email),
      isButtonEnabled: firstName.isNotEmpty &&
          lastName.isNotEmpty &&
          email.isNotEmpty &&
          Validators().validateName(firstName) == null &&
          Validators().validateName(lastName) == null &&
          Validators().validateEmail(email) == null,
    ));
  }

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

  final ManageAccountRepository repository = ManageAccountRepository();

  Future<void> fetchUserDetails() async {
    emit(state.copyWith(isLoading: true, errorMessage: null));
    try {
      final token = await SharedPrefsHelper.getUserAccessToken();

      if (token == null || token.isEmpty) {
        emit(state.copyWith(
          isLoading: false,
          errorMessage: 'Access token is missing.',
        ));
        return;
      }

      final ManageAccountModel user = await repository.getUserDetail(token: token);

      final firstNameError = Validators().validateName(user.firstName);
      final lastNameError = Validators().validateName(user.lastName);
      final emailError = Validators().validateEmail(user.email);

      final isValid = firstNameError == null &&
          lastNameError == null &&
          emailError == null &&
          user.firstName.isNotEmpty &&
          user.lastName.isNotEmpty &&
          user.email.isNotEmpty;

      emit(state.copyWith(
        firstName: user.firstName,
        lastName: user.lastName,
        email: user.email,
        firstNameError: firstNameError,
        lastNameError: lastNameError,
        emailError: emailError,
        isButtonEnabled: isValid,
        isLoading: false,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to fetch user data: ${e.toString()}',
      ));
    }
  }

}
