import 'package:avionics_internal/Screens/Onboarding/Otp/OtpScreen.dart';
import 'package:avionics_internal/Screens/Profile/Avtar/AvtarScreen.dart';
import 'package:avionics_internal/bloc/login/login_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../Constants/ApiClass/ApiErrorModel.dart';
import '../../Constants/ApiClass/shared_prefs_helper.dart';
import '../../Screens/Home/RootTabbar/RootTabbarScreen.dart';
import 'login_state.dart';
import '../../Constants/Validators.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginState());

  void emailChanged(String email) {
    if (email == state.email) return;

    emit(
      state.copyWith(
        email: email,
        isButtonEnabled: email.isNotEmpty && state.password.isNotEmpty,
      ),
    );
  }

  void passwordChanged(String password) {
    if (password == state.password) return;

    emit(
      state.copyWith(
        password: password,
        isButtonEnabled: password.isNotEmpty && state.email.isNotEmpty,
      ),
    );
  }


  Future<void> validateAndLogin(BuildContext context) async {
    final emailError = Validators().validateEmail(state.email);
    final passwordError = Validators().validatePassword(state.password);

    if (emailError != null || passwordError != null) {
      emit(
        state.copyWith(emailError: emailError, passwordError: passwordError),
      );
      return;
    }

    await loginUserApi(context);
  }

  Future<void> loginUserApi(BuildContext context) async {
    emit(
      state.copyWith(status: CommonApiStatus.submitting, errorMessage: null),
    );
    try {
      final result = await LoginRepository().loginUser(
        email: state.email,
        password: state.password,
      );

      emit(state.copyWith(status: CommonApiStatus.success));

      if (result.userDetails != null) {
        await SharedPrefsHelper.setUserAccessToken(result.accessToken ?? '');
        await SharedPrefsHelper.setUserRefreshToken(result.refreshToken ?? '');
        await SharedPrefsHelper.saveIsUserLogin(true);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Login successfully!'),
            behavior: SnackBarBehavior.floating,
            duration: Duration(seconds: 2),
          ),
        );
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => RootTabbarscreen()),
          (route) => false,
        );
      } else if (result.isVerified == false) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('OTP sent successfully! Please verify your email.'),
            behavior: SnackBarBehavior.floating,
            duration: Duration(seconds: 2),
          ),
        );
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) =>
                OtpScreen(email: state.email, isComeFromSignup: true),
          ),
        );
      } else if (result.isAvatar == false) {
        final signupData = {'email': state.email};

        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (_) => AvtarScreen(
              isComeFromSignupScreen: true,
              signupData: signupData,
            ),
          ),
          (route) => false,
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
}
