import 'package:avionics_internal/Constants/ApiClass/ApiErrorModel.dart';
import 'package:avionics_internal/bloc/Profile/Avtar/avtar_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../Constants/ApiClass/SessionTokenClass/session_Common_Token_Error.dart';
import '../../../Constants/ApiClass/shared_prefs_helper.dart';
import '../../../Screens/Onboarding/Otp/OtpScreen.dart';
import '../../signup/signup_repository.dart';
import 'avtar_state.dart';

class AvtarCubit extends Cubit<AvtarState> {
  AvtarCubit() : super(const AvtarState());

  void selectAvatarTypeOnly(String userType) {
    emit(state.copyWith(selectedUserType: userType));
  }

  Future<void> selectAvatar(
      String userType,
      bool isComeFromSignup,
      BuildContext context,
      Map<String, String> signupData,
      ) async {
    emit(
      state.copyWith(
        status: CommonApiStatus.submitting,
        selectedUserType: userType,
      ),
    );

    try {
      if (isComeFromSignup) {
        await SignupRepository().registerUser(
          first_name: signupData['first_name'] ?? '',
          last_name: signupData['last_name'] ?? '',
          email: signupData['email'] ?? '',
          password: signupData['password'] ?? '',
          phone_number: '',
          professional_role: '',
          experience_level: '',
          user_type: userType,
          auth_type: 'email',
        );
      } else {
        await AvtarRepository().setAvtarForProfile(userType: userType);
      }

      await SharedPrefsHelper.setAvtarUserType(userType);
      emit(state.copyWith(status: CommonApiStatus.success));

      if (isComeFromSignup) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => OtpScreen(
              email: signupData['email'] ?? '',
              isComeFromSignup: true,
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Avatar updated successfully')),
        );
      }
    } catch (e) {
      SessionCommonTokenError.handleUnauthorizedError(context, e);

      emit(state.copyWith(
        status: CommonApiStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> loadAvatarFromPrefs(bool isComeFromSignup) async {
    final userType = await SharedPrefsHelper.getAvtarUserType();
    emit(
      state.copyWith(
        selectedUserType: userType,
        status: CommonApiStatus.initial,
        errorMessage: null,
      ),
    );
  }

  void resetStatus() {
    emit(state.copyWith(status: CommonApiStatus.initial));
  }
}
