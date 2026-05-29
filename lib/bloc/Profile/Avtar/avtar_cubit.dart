import 'package:avionics_internal/Constants/ApiClass/ApiErrorModel.dart';
import 'package:avionics_internal/bloc/Profile/Avtar/avtar_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../Constants/ApiClass/SessionTokenClass/session_Common_Token_Error.dart';
import '../../../Constants/ApiClass/shared_prefs_helper.dart';
import '../../../Screens/Onboarding/Otp/OtpScreen.dart';
import '../../../Screens/Onboarding/Subscription/SubscriptionPlanDetailScreen.dart';
import '../../Onboarding/signup/signup_repository.dart';
import 'avtar_state.dart';

class AvtarCubit extends Cubit<AvtarState> {
  AvtarCubit() : super(const AvtarState());

  void selectAvatarTypeOnly(String userType) {
    emit(state.copyWith(selectedUserType: userType));
  }

  Future<void> selectAvatar(
      String userTypeUrl,
      String userType,
      bool isComeFromSignup,
      bool? isComeFromSocialLogin,
      BuildContext context,
      Map<String, String> signupData,
      ) async {

    emit(
      state.copyWith(
        status: CommonApiStatus.initial,
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

        if (!context.mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Avatar selected successfully! Verify your email.',
            ),
            behavior: SnackBarBehavior.floating,
            duration: Duration(seconds: 2),
          ),
        );

      } else {

        await AvtarRepository().setAvtarForProfile(
          userType: userType,
          context: context,
        );

      }

      await SharedPrefsHelper.setAvtarUserType(userType);
      await SharedPrefsHelper.setAvtarUserUrl(userTypeUrl);

      emit(
        state.copyWith(
          status: CommonApiStatus.success,
        ),
      );

      if (!context.mounted) return;

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
          const SnackBar(
            content: Text('Avatar updated successfully'),
          ),
        );

        if (isComeFromSocialLogin == true) {

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => SubscriptionPlanDetailScreen(
                isComeFromSignup: true,
              ),
            ),
          );

        }
      }

    } catch (e) {

      if (context.mounted) {
        SessionCommonTokenError.handleUnauthorizedError(
          context,
          e,
        );
      }

      emit(
        state.copyWith(
          status: CommonApiStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> loadAvatars(
    bool isComeFromSignup,
    bool isComeFromSocialLogin,
  ) async {
    emit(state.copyWith(status: CommonApiStatus.initial));
    try {
      final response = await AvtarRepository().loadAvatars();
      var userType = await SharedPrefsHelper.getAvtarUserType();
      if (isComeFromSignup == true || isComeFromSocialLogin == true) {
        userType = '';
      }
      emit(
        state.copyWith(
          status: CommonApiStatus.success,
          avatars: response.data,
          selectedUserType: userType,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: CommonApiStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  void resetStatus() {
    emit(state.copyWith(status: CommonApiStatus.initial));
  }
}
