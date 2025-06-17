import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../Constants/ApiClass/shared_prefs_helper.dart';
import '../../../Constants/Validators.dart';
import 'manageAcc_repository.dart';
import 'manageAcc_state.dart';

class ManageaccCubit extends Cubit<ManageAccState> {
  final ManageAccountRepository repository = ManageAccountRepository();

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
    final updatedEmailError =
        emailError ?? Validators().validateEmail(newEmail);

    final isValid = updatedFirstNameError == null &&
        updatedLastNameError == null &&
        updatedEmailError == null &&
        newFirstName.isNotEmpty &&
        newLastName.isNotEmpty &&
        newEmail.isNotEmpty;

    emit(state.copyWith(
      firstName: newFirstName,
      lastName: newLastName,
      email: newEmail,
      firstNameError: updatedFirstNameError,
      lastNameError: updatedLastNameError,
      emailError: updatedEmailError,
      isButtonEnabled: isValid,
    ));
  }

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

      final user = await repository.getUserDetail(token: token);

      initializeUserData(
        firstName: user.firstName,
        lastName: user.lastName,
        email: user.email,
      );

      emit(state.copyWith(isLoading: false));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to fetch user data: ${e.toString()}',
      ));
    }
  }

  Future<void> updateUserDetails({required String token, required String firstName, required String lastName}) async {
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

      await repository.updateUserDetail(
        token: token,
        firstName: state.firstName,
        lastName: state.lastName,
      );

      emit(state.copyWith(
        isLoading: false,
        errorMessage: null,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to update user data: ${e.toString()}',
      ));
    }
  }

  Future<String> getUserToken() async {
    return await SharedPrefsHelper.getUserAccessToken() ?? '';
  }
}
