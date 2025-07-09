import 'package:avionics_internal/Screens/Onboarding/Otp/OtpScreen.dart';
import 'package:avionics_internal/Screens/Profile/Avtar/AvtarScreen.dart';
import 'package:avionics_internal/bloc/login/login_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../Constants/ApiClass/ApiErrorModel.dart';
import '../../Constants/ApiClass/shared_prefs_helper.dart';
import '../../Constants/constantImages.dart';
import '../../CustomFiles/Custom_SnackBar.dart';
import '../../Screens/Home/RootTabbar/RootTabbarScreen.dart';
import 'login_state.dart';
import '../../Constants/Validators.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginState());

  final FirebaseAuth _auth = FirebaseAuth.instance;

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

    await _handleLogin(context);
  }

  Future<void> loginWithSocialPlatform(
    BuildContext context,
    String provider,
    String token,
  ) async {
    emit(
      state.copyWith(status: CommonApiStatus.submitting, errorMessage: null),
    );
    try {
      final result = await LoginRepository().loginUser(
        email: state.email,
        password: state.password,
      );
      emit(state.copyWith(status: CommonApiStatus.success));
      await _navigateAfterLogin(context, result);
    } catch (e) {
      emit(
        state.copyWith(
          status: CommonApiStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> signInWithGoogle(BuildContext context) async {
    try {
      await GoogleSignIn().signOut();
      await _auth.signOut();
      final googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return;

      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await _auth.signInWithCredential(credential);
      if (userCredential.user == null) return;

      emit(state.copyWith(status: CommonApiStatus.submitting));

      final result = await LoginRepository().loginUserWithSocialPlatform(
        token: googleAuth.idToken ?? '',
        provider: 'google',
      );

      emit(state.copyWith(status: CommonApiStatus.success));
      await _navigateAfterLogin(context, result);
    } catch (e) {
      print(e.toString());
      emit(
        state.copyWith(
          status: CommonApiStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> signInWithFacebook(BuildContext context) async {
    try {
      final result = await FacebookAuth.instance.login(
        permissions: ['email', 'public_profile'],
        loginBehavior: LoginBehavior.dialogOnly,
      );

      if (result.status != LoginStatus.success) return;

      final accessToken = result.accessToken!.tokenString;
      final credential = FacebookAuthProvider.credential(accessToken);
      final userCredential = await _auth.signInWithCredential(credential);

      debugPrint('userCredential User: ${userCredential.user?.displayName}');
      debugPrint('credential User: ${credential}');
      debugPrint('accessToken: ${accessToken}');

      emit(state.copyWith(status: CommonApiStatus.submitting));

      final resultResponse = await LoginRepository()
          .loginUserWithSocialPlatform(
            token: accessToken,
            provider: 'facebook',
          );

      emit(state.copyWith(status: CommonApiStatus.success));
      await _navigateAfterLogin(context, resultResponse);
      debugPrint('Facebook User: ${userCredential.user?.displayName}');
    } catch (e) {
      print(e.toString());
      emit(
        state.copyWith(
          status: CommonApiStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _handleLogin(BuildContext context) async {
    emit(state.copyWith(status: CommonApiStatus.submitting));
    try {
      final result = await LoginRepository().loginUser(
        email: state.email,
        password: state.password,
      );
      emit(state.copyWith(status: CommonApiStatus.success));
      await _navigateAfterLogin(context, result);
    } catch (e) {
      emit(
        state.copyWith(
          status: CommonApiStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _navigateAfterLogin(BuildContext context, dynamic result) async {
    if (result.userDetails != null) {
      await SharedPrefsHelper.setUserAccessToken(result.accessToken ?? '');
      await SharedPrefsHelper.setUserRefreshToken(result.refreshToken ?? '');
      await SharedPrefsHelper.saveIsUserLogin(true);

      // For Social Login Checks
      if (result.userType == null || result.userType == false) {
        final signupData = {'email': state.email};
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (_) =>
                AvtarScreen(isComeFromSignupScreen: true, signupData: signupData),
          ),
              (route) => false,
        );
      }else if (result.is_active_subscription == null || result.userType == false) {
        final signupData = {'email': state.email};
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (_) =>
                AvtarScreen(
                    isComeFromSignupScreen: true, signupData: signupData),
          ),
              (route) => false,
        );
      }else {
        AppSnackBar.custom(
          context,
          message: 'Login Successfully',
          svgAsset: CommonUi.setSvgImage(AssetsPath.loginIcon),
        );

        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => RootTabbarscreen()),
              (route) => false,
        );
      }
    } else if (result.isVerified == false) {
      AppSnackBar.custom(
        context,
        message: 'OTP sent successfully! Please verify your email.',
        svgAsset: CommonUi.setSvgImage(AssetsPath.otpIcon),
        backgroundColor: const Color(0xFF3F3D56),
      );

      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => OtpScreen(email: state.email, isComeFromSignup: true),
        ),
      );
    } else if (result.isAvatar == false) {
      final signupData = {'email': state.email};
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (_) =>
              AvtarScreen(isComeFromSignupScreen: true, signupData: signupData),
        ),
        (route) => false,
      );
    }
  }
}
