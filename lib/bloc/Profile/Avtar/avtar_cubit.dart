import 'package:avionics_internal/Constants/ApiClass/ApiErrorModel.dart';
import 'package:avionics_internal/bloc/Profile/Avtar/avtar_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../Constants/ApiClass/shared_prefs_helper.dart';
import '../../../Screens/Onboarding/Otp/OtpScreen.dart';
import 'avtar_state.dart';

class AvtarCubit extends Cubit<AvtarState> {
  AvtarCubit() : super(const AvtarState());

  /// Save avatar and call API
  Future<void> selectAvatar(
    String userType,
    bool isComeFromSignup,
    String userEmail,
    BuildContext context,
  ) async {
    emit(
      state.copyWith(
        status: CommonApiStatus.submitting,
        selectedUserType: userType,
      ),
    );

    try {
      if (isComeFromSignup == true) {
        await AvtarRepository().setAvtarForProfileWhileSignup(
          userType: userType,
          userEmail: userEmail,
        );
      } else {
        await AvtarRepository().setAvtarForProfile(userType: userType);
      }

      await SharedPrefsHelper.setAvtarUserType(userType);
      emit(state.copyWith(status: CommonApiStatus.success));

      if (isComeFromSignup == true) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => OtpScreen(email: userEmail, isComeFromSignup: true),
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(
          status: CommonApiStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> loadAvatarFromPrefs(bool isComeFromSignup) async {
    final userType = await SharedPrefsHelper.getAvtarUserType();
    if (isComeFromSignup == true) {
      userType == '';
    }
    emit(
      state.copyWith(
        selectedUserType: userType,
        status: CommonApiStatus.initial, // Reset the status
        errorMessage: null,
      ),
    );
  }
}
