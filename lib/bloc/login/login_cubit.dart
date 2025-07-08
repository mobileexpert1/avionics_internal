import 'package:avionics_internal/Screens/Onboarding/Otp/OtpScreen.dart';
import 'package:avionics_internal/Screens/Profile/Avtar/AvtarScreen.dart';
import 'package:avionics_internal/bloc/login/login_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../Constants/ApiClass/ApiErrorModel.dart';
import '../../Constants/ApiClass/shared_prefs_helper.dart';
import '../../Constants/constantImages.dart';
import '../../CustomFiles/Custom_SnackBar.dart';
import '../../Database/auth_storage.dart';
import '../../Screens/Home/RootTabbar/RootTabbarScreen.dart';
import '../../Screens/Onboarding/Signup/SignupScreen.dart';
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

        AppSnackBar.custom(
          context,
          message: 'Login Successfully',
          svgAsset: CommonUi.setSvgImage(AssetsPath.loginIcon),
        );

        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => RootTabbarscreen()),
          (route) => false,
        );
      } else if (result.isVerified == false) {
        AppSnackBar.custom(
          context,
          message: 'OTP sent successfully! Please verify your email.',
          svgAsset: CommonUi.setSvgImage(AssetsPath.otpIcon),
          backgroundColor: const Color(0xFF3F3D56),
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

  Future<void> signInWithGoogle() async {
    try {
      await GoogleSignIn().signOut();
      await FirebaseAuth.instance.signOut();
      GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      if (googleUser == null) {
        print("User cancelled Google Sign-In");
        return;
      }
      GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      debugPrint('◆ Access token  : ${googleAuth.accessToken}');
      debugPrint('◆ ID token      : ${googleAuth.idToken}');

      UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);

      print("User Name: ${userCredential.user?.displayName}");
      print("User Email: ${userCredential.user?.email}");
      print("User UID: ${userCredential.user?.uid}");


      // if (userCredential.user != null) {
      //   socialLoginCheck(
      //     socialId: userCredential.user!.uid,
      //     name: userCredential.user!.displayName ?? "No Name",
      //     email: userCredential.user!.email ?? "No Email",
      //   );
      // }
    } catch (e) {
      print("Google Sign-In Error: $e");
    }
  }

  Future<void> signInWithFacebook() async {
    try {
      // ask Facebook for email & public profile
      final LoginResult result = await FacebookAuth.instance.login(
        permissions: ['email', 'public_profile'],
        loginBehavior: LoginBehavior.dialogOnly, // avoids native FB app fallback glitches
      );

      if (result.status != LoginStatus.success) {
        debugPrint('❌ Facebook sign‑in failed: ${result.status} ${result.message}');
        return;
      }

      // this is the OAuth access token you asked about:
      final String accessToken = result.accessToken!.tokenString;
      debugPrint('Facebook accessToken → $accessToken'); // ⚠️ REMOVE in production

      // turn it into a Firebase credential
      final credential = FacebookAuthProvider.credential(accessToken);

      final userCred =
      await FirebaseAuth.instance.signInWithCredential(credential);

      debugPrint('✔️  Logged in as ${userCred.user?.displayName}');
    } on FirebaseAuthException catch (e, st) {
      debugPrint('Firebase auth error: $e\n$st');
    } catch (e, st) {
      debugPrint('Unhandled error: $e\n$st');
    }
  }

}
