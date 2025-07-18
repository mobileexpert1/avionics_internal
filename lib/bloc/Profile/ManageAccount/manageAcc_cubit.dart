
import 'package:avionics_internal/Constants/ApiClass/ApiErrorModel.dart';
import 'package:avionics_internal/Screens/Onboarding/Login/LoginScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../Constants/ApiClass/SessionTokenClass/session_Common_Token_Error.dart';
import '../../../Constants/ApiClass/shared_prefs_helper.dart';
import '../../../Constants/Validators.dart';
import '../../../Constants/constantImages.dart';
import '../../../CustomFiles/Custom_SnackBar.dart';
import 'manageAcc_repository.dart';
import 'manageAcc_state.dart';

class ManageaccCubit extends Cubit<ManageAccState> {
  final ManageAccountRepository repository = ManageAccountRepository();

  ManageaccCubit() : super(ManageAccState());

  void initializeUserData({
    required String firstName,
    required String lastName,
    required String email,
    required String authType,
  }) {
    emit(
      state.copyWith(
        firstName: firstName,
        lastName: lastName,
        email: email,
        authType: authType,
        isButtonEnabled: firstName.isNotEmpty && lastName.isNotEmpty,
      ),
    );
  }

  void firstNameChanged(String firstName) {
    emit(
      state.copyWith(
        firstName: firstName,
        firstNameError: null,
        isButtonEnabled: firstName.isNotEmpty && state.lastName.isNotEmpty,
      ),
    );
  }

  void lastNameChanged(String lastName) {
    emit(
      state.copyWith(
        lastName: lastName,
        lastNameError: null,
        isButtonEnabled: state.firstName.isNotEmpty && lastName.isNotEmpty,
      ),
    );
  }

  bool validateFields() {
    final firstNameError = Validators().validateName(state.firstName);
    final lastNameError = Validators().validateName(state.lastName);

    final isValid = firstNameError == null && lastNameError == null;

    emit(
      state.copyWith(
        firstNameError: firstNameError,
        lastNameError: lastNameError,
      ),
    );
    return isValid;
  }

  Future<void> fetchUserDetails(BuildContext context) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));
    try {
      final user = await repository.getUserDetail();

      initializeUserData(
        firstName: user.firstName,
        lastName: user.lastName,
        email: user.email,
        authType: user.authType,
      );

      await SharedPrefsHelper.setAvtarUserType(user.userType);

      emit(state.copyWith(isLoading: false));
    } catch (e) {
      SessionCommonTokenError.handleUnauthorizedError(context, e);
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }

  Future<void> updateUserDetails(BuildContext context) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));
    try {
      await repository.updateProfileInformation(
        firstName: state.firstName,
        lastName: state.lastName,
      );

      emit(state.copyWith(isLoading: false, status: CommonApiStatus.success));
      AppSnackBar.custom(
        context,
        message: "Your profile has been successfully updated",
        svgAsset: CommonUi.setSvgImage(AssetsPath.successIcon),
      );
    } catch (e) {
      SessionCommonTokenError.handleUnauthorizedError(context, e);
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }
}
