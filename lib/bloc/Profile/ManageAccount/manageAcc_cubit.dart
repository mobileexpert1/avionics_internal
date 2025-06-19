import 'dart:ui';

import 'package:avionics_internal/Constants/ApiClass/ApiErrorModel.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../Constants/ApiClass/refresh_accessRepository.dart';
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

  Future<void> fetchUserDetails() async {
    emit(state.copyWith(isLoading: true, errorMessage: null));
    try {
      final user = await repository.getUserDetail();

      initializeUserData(
        firstName: user.firstName,
        lastName: user.lastName,
        email: user.email,
      );

      await SharedPrefsHelper.setAvtarUserType(user.userType);

      emit(state.copyWith(isLoading: false));
    } catch (e) {
      _handleApiError(e);
    }
  }

  Future<void> updateUserDetails() async {
    emit(state.copyWith(isLoading: true, errorMessage: null));
    try {
      await repository.updateProfileInformation(
        firstName: state.firstName,
        lastName: state.lastName,
      );

      emit(state.copyWith(isLoading: false, status: CommonApiStatus.success));
    } catch (e) {
      _handleApiError(e);
    }
  }

  void _handleApiError(Object e) async {
    final error = e.toString().toLowerCase();
    if (error.contains("unauthorized") || error.contains("401")) {
      final prefs = await SharedPreferences.getInstance();
      final refreshToken = prefs.getString('UserAccessTokenKey');
      final accessToken = await RefreshAccesstokenRepository().getAndUpdateTheRefreshToken(refreshToken: refreshToken ?? '');
      print(accessToken);
    }
    emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
  }
}
