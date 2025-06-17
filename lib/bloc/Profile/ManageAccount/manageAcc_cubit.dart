import 'package:flutter_bloc/flutter_bloc.dart';
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
    emit(
      state.copyWith(
        firstName: firstName,
        lastName: lastName,
        email: email,
        isButtonEnabled: firstName.isNotEmpty && lastName.isNotEmpty,
      ),
    );
  }

  void firstNameChanged(String firstName) {
    emit(
      state.copyWith(
        firstName: firstName,
        isButtonEnabled: firstName.isNotEmpty && state.lastName.isNotEmpty,
      ),
    );
  }

  void lastNameChanged(String lastName) {
    emit(
      state.copyWith(
        lastName: lastName,
        isButtonEnabled: state.firstName.isNotEmpty && lastName.isNotEmpty,
      ),
    );
  }

  /// Called on button press
  bool validateFields() {
    final firstNameError = Validators().validateName(state.firstName);
    final lastNameError = Validators().validateName(state.lastName);

    emit(
      state.copyWith(
        firstNameError: firstNameError,
        lastNameError: lastNameError,
      ),
    );

    return firstNameError == null && lastNameError == null;
  }

  Future<void> fetchUserDetails() async {
    emit(state.copyWith(isLoading: true, errorMessage: null));
    try {
      final user = await repository.getUserDetail();

      initializeUserData(
        firstName: user.firstName,
        lastName: user.lastName,
        email: user.email, // This will only be displayed
      );

      emit(state.copyWith(isLoading: false));
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }

  Future<void> updateUserDetails() async {
    emit(state.copyWith(isLoading: true, errorMessage: null));
    try {
      await repository.updateProfileInformation(
        firstName: state.firstName,
        lastName: state.lastName,
      );

      emit(state.copyWith(isLoading: false));
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }
}
