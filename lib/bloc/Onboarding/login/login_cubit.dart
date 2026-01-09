import 'package:avionics_internal/Screens/Onboarding/Otp/OtpScreen.dart';
import 'package:avionics_internal/Screens/Profile/Avtar/AvtarScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import '../../../Constants/ApiClass/ApiErrorModel.dart';
import '../../../Constants/ApiClass/shared_prefs_helper.dart';
import '../../../Constants/Validators.dart';
import '../../../Constants/constantImages.dart';
import '../../../CustomFiles/Custom_SnackBar.dart';
import '../../../Screens/Home/RootTabbar/RootTabbarScreen.dart';
import '../../../Screens/Onboarding/Subscription/AppleSubscription/AppleSubscriptionScreen.dart';
import '../../../Screens/Onboarding/Subscription/SubscriptionScreen.dart';
import 'login_repository.dart';
import 'login_response_model.dart';
import 'login_state.dart';

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
      // 1. Choose the right GoogleSignIn instance
      final googleSignIn = kIsWeb
          ? GoogleSignIn(
              clientId:
                  '951110180167-9c75t0t460jcmfsm0k5cvg8f424f2a4o.apps.googleusercontent.com',
              scopes: const ['email', 'profile'],
            )
          : GoogleSignIn(scopes: const ['email', 'profile']);

      // 2. Make sure any previous sessions are cleared
      await googleSignIn.signOut();
      await _auth.signOut();

      if (kIsWeb) {
        final userCred = await _auth.signInWithPopup(GoogleAuthProvider());
        if (userCred.user == null) return;

        emit(state.copyWith(status: CommonApiStatus.submitting));

        // You get the OAuth access token from userCred.credential
        final accessToken =
            (userCred.credential as OAuthCredential).accessToken ?? '';

        final result = await LoginRepository().loginUserWithSocialPlatform(
          token: accessToken,
          provider: 'google',
        );

        emit(state.copyWith(status: CommonApiStatus.success));
        await _navigateAfterLogin(context, result);
      } else {
        /* ---------- Mobile / desktop sign‑in ---------- */
        final googleUser = await googleSignIn.signIn();
        if (googleUser == null) return;

        final googleAuth = await googleUser.authentication;

        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        final userCred = await _auth.signInWithCredential(credential);
        if (userCred.user == null) return;

        emit(state.copyWith(status: CommonApiStatus.submitting));

        final result = await LoginRepository().loginUserWithSocialPlatform(
          token: googleAuth.accessToken ?? '',
          provider: 'google',
        );

        emit(state.copyWith(status: CommonApiStatus.success));
        await _navigateAfterLogin(context, result);
      }
    } catch (e, st) {
      debugPrintStack(label: e.toString(), stackTrace: st);
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
      UserCredential userCredential;
      String backendToken = '';

      if (kIsWeb) {
        final facebookProvider = FacebookAuthProvider();
        userCredential = await _auth.signInWithPopup(facebookProvider);
        backendToken = await userCredential.user?.getIdToken() ?? '';
        debugPrint('WEB → Firebase ID Token: $backendToken');
      } else {
        final result = await FacebookAuth.instance.login(
          permissions: ['email', 'public_profile'],
        );
        if (result.status != LoginStatus.success) {
          throw Exception('Facebook login cancelled');
        }

        final accessToken = result.accessToken!;
        backendToken = accessToken.token;
        debugPrint('MOBILE → Facebook Access Token: $backendToken');
        final credential = FacebookAuthProvider.credential(accessToken.token);
        userCredential = await _auth.signInWithCredential(credential);
      }

      debugPrint('User: ${userCredential.user?.displayName}');
      emit(state.copyWith(status: CommonApiStatus.submitting));

      final resultResponse = await LoginRepository()
          .loginUserWithSocialPlatform(
            token: backendToken,
            provider: 'facebook',
          );
      emit(state.copyWith(status: CommonApiStatus.success));
      await _navigateAfterLogin(context, resultResponse);
    } catch (e) {
      emit(
        state.copyWith(
          status: CommonApiStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  // Future<void> signInWithFacebook(BuildContext context) async {
  //   try {
  //
  //     final result = await FacebookAuth.instance.login(
  //       permissions: ['email', 'public_profile'],
  //       loginBehavior: LoginBehavior.dialogOnly,
  //     );
  //
  //     if (result.status != LoginStatus.success) return;
  //
  //     final accessToken = result.accessToken!;
  //     final credential = FacebookAuthProvider.credential(accessToken.token);
  //     final userCredential = await _auth.signInWithCredential(credential);
  //
  //     debugPrint('userCredential User: ${userCredential.user?.displayName}');
  //     debugPrint('credential User: $credential');
  //     debugPrint('accessToken: $accessToken');
  //
  //     emit(state.copyWith(status: CommonApiStatus.submitting));
  //
  //     final resultResponse = await LoginRepository()
  //         .loginUserWithSocialPlatform(
  //           token: accessToken.token,
  //           provider: 'facebook',
  //         );
  //
  //     emit(state.copyWith(status: CommonApiStatus.success));
  //     await _navigateAfterLogin(context, resultResponse);
  //     debugPrint('Facebook User: ${userCredential.user?.displayName}');
  //   } catch (e) {
  //     print(e.toString());
  //     emit(
  //       state.copyWith(
  //         status: CommonApiStatus.failure,
  //         errorMessage: e.toString(),
  //       ),
  //     );
  //   }
  // }

  Future<void> signInWithApple(BuildContext context) async {
    try {
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );
      emit(state.copyWith(status: CommonApiStatus.submitting));

      final String userToken = credential.identityToken ?? "";

      print('User Token: ${credential.identityToken}');
      print('User ID: ${credential.userIdentifier}');
      print('Email: ${credential.email}');
      print('Full Name: ${credential.givenName} ${credential.familyName}');

      final result = await LoginRepository().loginUserWithSocialPlatform(
        token: userToken,
        provider: 'apple',
      );

      if (userToken == "") {
        emit(
          state.copyWith(
            status: CommonApiStatus.failure,
            errorMessage: "Please try again, Login fail....",
          ),
        );
        return;
      }

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

  Future<void> _navigateAfterLogin(
    BuildContext context,
    LoginResponseModel result,
  ) async {
    if (result.userDetails != null) {
      // On Hold Avtar Model
      await SharedPrefsHelper.setAvtarUserType(
        result.userDetails?.userType ?? '',
      );
      await SharedPrefsHelper.setUserAccessToken(result.accessToken ?? '');
      await SharedPrefsHelper.setUserRefreshToken(result.refreshToken ?? '');
      await SharedPrefsHelper.saveIsUserLogin(true);

      // For Social Login Checks
      if (result.userDetails?.userType == '' ||
          result.userDetails?.userType == null) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (_) => AvtarScreen(
              isComeFromSignupScreen: false,
              signupData: {},
              isComeFromSocialLogin: true,
            ),
          ),
          (route) => false,
        );
      } else if (result.userDetails?.isActiveSubscription == null ||
          result.userDetails?.isActiveSubscription == false) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => (defaultTargetPlatform == TargetPlatform.iOS
                ? AppleSubscriptionScreen(isComeFromSignup: true)
                : AppleSubscriptionScreen(
                    isComeFromSignup: true,
                    isComeFromSocialLogin: true,
                  )),
          ),
        );
      } else {
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
