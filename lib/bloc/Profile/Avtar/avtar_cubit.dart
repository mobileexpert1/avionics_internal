import 'package:avionics_internal/Constants/ApiClass/ApiErrorModel.dart';
import 'package:avionics_internal/bloc/Profile/Avtar/avtar_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

import '../../../Constants/ApiClass/SessionTokenClass/session_Common_Token_Error.dart';
import '../../../Constants/ApiClass/shared_prefs_helper.dart';
import '../../../Helpers/NoInternetDialog.dart';
import '../../../Screens/Onboarding/Otp/OtpScreen.dart';
import '../../../Screens/Onboarding/Subscription/SubscriptionPlanDetailScreen.dart';
import '../../Onboarding/signup/signup_repository.dart';
import 'avtar_state.dart';

class AvtarCubit extends Cubit<AvtarState> {
  AvtarCubit() : super(const AvtarState());

  void selectAvatarTypeOnly(String userType, String userTypeUrl) {
    emit(
      state.copyWith(
        selectedUserType: userType,
        selectedUserTypeUrl: userTypeUrl,
      ),
    );
  }

  void resetIsComeFromSignupValue(){
    emit(
      state.copyWith(
        isComeFromSignup: -2,
      ),
    );
  }

  Future<void> selectAvatar(
    String userTypeUrl,
    String userType,
    bool isComeFromSignup,
    bool? isComeFromSocialLogin,
    BuildContext context,
    Map<String, String> signupData,
  ) async {
    if (await InternetConnection().hasInternetAccess) {
      emit(
        state.copyWith(
          status: CommonApiStatus.initial,
          selectedUserType: userType,
          selectedUserTypeUrl: userTypeUrl,
        ),
      );

      try {
        if (isComeFromSignup) {
          await SignupRepository().registerUser(
            firstName: signupData['first_name'] ?? '',
            lastName: signupData['last_name'] ?? '',
            email: signupData['email'] ?? '',
            password: signupData['password'] ?? '',
            phoneNumber: '',
            professionalRole: '',
            experienceLevel: '',
            userType: userType,
            authType: 'email',
          );

          if (!context.mounted) return;

          await SharedPrefsHelper.setUserProfileName(
            '${signupData['first_name'] ?? ''} ${signupData['last_name'] ?? ''}'
                .trim(),
          );

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Avatar selected successfully! Verify your email.'),
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
            isComeFromSignup: isComeFromSignup == false ? 2 : -1,
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
            const SnackBar(content: Text('Avatar updated successfully')),
          );

          if (isComeFromSocialLogin == true) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) =>
                    SubscriptionPlanDetailScreen(isComeFromSignup: true),
              ),
            );
          }
        }
      } catch (e) {
        if (context.mounted) {
          SessionCommonTokenError.handleUnauthorizedError(context, e);
        }

        emit(
          state.copyWith(
            status: CommonApiStatus.failure,
            errorMessage: e.toString(),
          ),
        );
      }
    } else {
      NoInternetDialog.show(
        context,
        onRetry: () => selectAvatar(
          userTypeUrl,
          userType,
          isComeFromSignup,
          isComeFromSocialLogin,
          context,
          signupData,
        ),
      );
    }
  }

  Future<void> loadAvatars(
    bool isComeFromSignup,
    bool isComeFromSocialLogin,
    BuildContext context,
  ) async {
    if (await InternetConnection().hasInternetAccess) {
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
    } else {
      NoInternetDialog.show(
        context,
        onRetry: () =>
            loadAvatars(isComeFromSignup, isComeFromSocialLogin, context),
      );
    }
  }

  void resetStatus() {
    emit(state.copyWith(status: CommonApiStatus.initial));
  }
}
