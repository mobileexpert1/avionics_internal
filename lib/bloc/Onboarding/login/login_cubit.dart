import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:avionics_internal/Screens/Onboarding/Otp/OtpScreen.dart';
import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
// import 'package:flutter_uxcam/flutter_uxcam.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../../../Constants/ApiClass/ApiErrorModel.dart';
import '../../../Constants/ApiClass/shared_prefs_helper.dart';
import '../../../Constants/ConstantStrings.dart';
import '../../../Constants/Validators.dart';
import '../../../Constants/constantImages.dart';
import '../../../CustomFiles/Custom_SnackBar.dart';
import '../../../Helpers/AppNavigator.dart';
import '../../../Helpers/AppleSignInErrorHandler.dart';
import '../../../Helpers/NoInternetDialog.dart';
import '../../../Screens/Home/RootTabbar/RootTabbarScreen.dart';
import '../../../Screens/Onboarding/Subscription/SubscriptionPlanDetailScreen.dart';
import '../../../Screens/Profile/SettingScreen/SettingMenuScreen/0_Avtar/AvtarScreen.dart';
import 'login_repository.dart';
import 'login_response_model.dart';
import 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginState());

  bool _googleInitialized = false;

  Future<void> initGoogle(BuildContext context) async {
    debugPrint("================================");
    debugPrint("INIT GOOGLE CALLED");
    debugPrint("_googleInitialized = $_googleInitialized");
    debugPrint("================================");

    if (_googleInitialized) {
      debugPrint("INIT GOOGLE SKIPPED");
      return;
    }

    try {
      debugPrint("GOOGLE INITIALIZE START");

      await GoogleSignIn.instance.initialize(
        clientId: kIsWeb
            ? '951110180167-9c75t0t460jcmfsm0k5cvg8f424f2a4o.apps.googleusercontent.com'
            : (Platform.isIOS
                  ? '951110180167-a4d8j4fjjvpibaa8or8kthl310p81q7i.apps.googleusercontent.com'
                  : null),
      );

      debugPrint("GOOGLE INITIALIZE SUCCESS");

      GoogleSignIn.instance.authenticationEvents.listen((event) async {
        debugPrint("GOOGLE EVENT => ${event.runtimeType}");

        if (event is GoogleSignInAuthenticationEventSignIn) {
          try {
            final user = event.user;

            final idToken = user.authentication.idToken;

            debugPrint("GOOGLE ID TOKEN => $idToken");

            if (idToken == null || idToken.isEmpty) {
              throw Exception("Google ID token missing");
            }

            emit(state.copyWith(status: CommonApiStatus.submitting));

            final result = await LoginRepository().loginUserWithSocialPlatform(
              token: idToken,
              provider: 'google',
            );

            emit(state.copyWith(status: CommonApiStatus.success));

            await _navigateAfterLogin(context, result);
          } catch (e, stackTrace) {
            debugPrint("GOOGLE WEB LOGIN ERROR => $e");
            debugPrint("$stackTrace");

            final message = GoogleSignInErrorHandler.getMessage(e);

            emit(
              state.copyWith(
                status: CommonApiStatus.failure,
                errorMessage: message,
              ),
            );
          }
        }
      });

      _googleInitialized = true;

      debugPrint("_googleInitialized SET TO TRUE");
    } catch (e, stackTrace) {
      debugPrint("GOOGLE INITIALIZE ERROR => $e");
      debugPrint("$stackTrace");
    }
  }

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
    if (await InternetConnection().hasInternetAccess) {
      emit(
        state.copyWith(status: CommonApiStatus.submitting, errorMessage: null),
      );
      try {
        final result = await LoginRepository().loginUser(
          email: state.email,
          password: state.password,
        );
        emit(state.copyWith(status: CommonApiStatus.success));
        if (!context.mounted) return;
        await _navigateAfterLogin(context, result);
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
        onRetry: () async {
          await loginWithSocialPlatform(context, provider, token);
        },
      );
    }
  }

  Future<void> signInWithGoogle(BuildContext context) async {
    try {
      if (kIsWeb) {
        return;
      }

      if (_googleInitialized) return;

      await GoogleSignIn.instance.initialize(
        clientId: kIsWeb
            ? '951110180167-9c75t0t460jcmfsm0k5cvg8f424f2a4o.apps.googleusercontent.com'
            : (Platform.isIOS
                  ? '951110180167-a4d8j4fjjvpibaa8or8kthl310p81q7i.apps.googleusercontent.com'
                  : null),
      );

      emit(state.copyWith(status: CommonApiStatus.submitting));

      try {
        final GoogleSignInAccount account = await GoogleSignIn.instance
            .authenticate();

        final auth = await account.authorizationClient.authorizationForScopes([
          'email',
          'profile',
        ]);

        final accessToken = auth?.accessToken ?? '';

        final result = await LoginRepository().loginUserWithSocialPlatform(
          token: accessToken,
          provider: 'google',
        );

        emit(state.copyWith(status: CommonApiStatus.success));

        await _navigateAfterLogin(context, result);
      } catch (e) {
        final message = GoogleSignInErrorHandler.getMessage(e);
        emit(
          state.copyWith(
            status: CommonApiStatus.failure,
            errorMessage: message,
          ),
        );
      }
    } catch (e) {
      final message = GoogleSignInErrorHandler.getMessage(e);
      emit(
        state.copyWith(status: CommonApiStatus.failure, errorMessage: message),
      );
    }
  }

  Future<void> signInWithFacebook(BuildContext context) async {
    try {
      emit(state.copyWith(status: CommonApiStatus.submitting));

      String backendToken = '';

      if (kIsWeb) {
        final facebookProvider = FacebookAuthProvider();

        final userCredential = await FirebaseAuth.instance.signInWithPopup(
          facebookProvider,
        );

        backendToken = await userCredential.user?.getIdToken(true) ?? '';

        if (backendToken.isEmpty) {
          throw Exception('Unable to get Firebase token');
        }
      } else {
        final rawNonce = generateNonce();
        final nonce = sha256ofString(rawNonce);

        final LoginResult loginResult = await FacebookAuth.instance.login(
          permissions: ['email', 'public_profile'],
          loginTracking: LoginTracking.limited,
          nonce: nonce,
        );

        debugPrint('Facebook Status: ${loginResult.status}');
        debugPrint('Facebook Token Type: ${loginResult.accessToken?.type}');

        if (loginResult.status != LoginStatus.success ||
            loginResult.accessToken == null) {
          throw Exception('Facebook login cancelled or failed');
        }

        OAuthCredential credential;

        if (Platform.isIOS) {
          switch (loginResult.accessToken!.type) {
            case AccessTokenType.classic:
              final token = loginResult.accessToken as ClassicToken;

              credential = FacebookAuthProvider.credential(token.tokenString);
              break;

            case AccessTokenType.limited:
              final token = loginResult.accessToken as LimitedToken;

              credential = OAuthCredential(
                providerId: 'facebook.com',
                signInMethod: 'oauth',
                idToken: token.tokenString,
                rawNonce: rawNonce,
              );
              break;
          }
        } else {
          credential = FacebookAuthProvider.credential(
            loginResult.accessToken!.tokenString,
          );
        }

        final userCredential = await FirebaseAuth.instance.signInWithCredential(
          credential,
        );

        backendToken = await userCredential.user?.getIdToken(true) ?? '';

        if (backendToken.isEmpty) {
          throw Exception('Unable to get Firebase token');
        }

        debugPrint('FIREBASE TOKEN LENGTH: ${backendToken.length}');
      }

      final resultResponse = await LoginRepository()
          .loginUserWithSocialPlatform(
            token: backendToken,
            provider: 'facebook',
          );

      emit(state.copyWith(status: CommonApiStatus.success));

      await _navigateAfterLogin(context, resultResponse);
    } catch (e, st) {
      debugPrintStack(label: 'Facebook Login Error', stackTrace: st);

      emit(
        state.copyWith(
          status: CommonApiStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  String generateNonce([int length = 32]) {
    const charset =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';

    final random = Random.secure();

    return List.generate(
      length,
      (_) => charset[random.nextInt(charset.length)],
    ).join();
  }

  String sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

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
      final message = AppleSignInErrorHandler.getMessage(e);
      emit(
        state.copyWith(status: CommonApiStatus.failure, errorMessage: message),
      );
    }
  }

  Future<void> _handleLogin(BuildContext context) async {
    if (await InternetConnection().hasInternetAccess) {
      emit(state.copyWith(status: CommonApiStatus.submitting));
      try {
        final result = await LoginRepository().loginUser(
          email: state.email,
          password: state.password,
        );
        emit(state.copyWith(status: CommonApiStatus.success));
        await _navigateAfterLogin(context, result);
      } catch (e) {
        // FlutterUxcam.logEvent('Login Failed');
        emit(
          state.copyWith(
            status: CommonApiStatus.failure,
            errorMessage: mapStatusCode(e.toString()),
          ),
        );
      }
    } else {
      NoInternetDialog.show(
        context,
        onRetry: () async {
          _handleLogin(context);
        },
      );
    }
  }

  Future<void> _navigateAfterLogin(
    BuildContext context,
    LoginResponseModel result,
  ) async {
    if (!context.mounted) return;

    if (result.userDetails != null) {
      //
      // /// for Ux cam
      // FlutterUxcam.setUserIdentity(
      //   result.userDetails?.email ?? '',
      // );
      //
      // FlutterUxcam.logEvent('Login Success');

      await SharedPrefsHelper.setAvtarUserType(
        result.userDetails?.userType ?? '',
      );

      String userTypeUrl = result.userDetails?.userTypeUrl ?? '';

      if (result.userDetails!.userTypeUrl.toLowerCase().contains(
        "Radar.svg".toLowerCase(),
      )) {
        userTypeUrl =
            "${ApiBaseUrlConstant.baseUrl}s3/manufacturer/57ATSEPWhite.svg";
      }
      await SharedPrefsHelper.setAvtarUserUrl(userTypeUrl);

      await SharedPrefsHelper.setUserProfileName(
        '${result.userDetails?.firstName ?? ''} ${result.userDetails?.lastName ?? ''}'
            .trim(),
      );

      await SharedPrefsHelper.saveEmail(result.userDetails?.email ?? '');
      await SharedPrefsHelper.setUserAccessToken(result.accessToken ?? '');
      await SharedPrefsHelper.setUserRefreshToken(result.refreshToken ?? '');
      await SharedPrefsHelper.saveIsUserLogin(true);

      if (!context.mounted) return;

      if (result.userDetails!.userType == '') {
        AppNavigator.pushAndRemoveUntil(
          context,
          AvtarScreen(
            isComeFromSignupScreen: false,
            signupData: {},
            isComeFromSocialLogin: true,
          ),
          disableSwipeBack: true,
        );
        return;
      } else if (result.userDetails!.isActiveSubscription == false) {
        AppNavigator.pushAndRemoveUntil(
          context,
          SubscriptionPlanDetailScreen(isComeFromSignup: true),
          disableSwipeBack: true,
        );
        return;
      } else {
        AppSnackBar.custom(
          context,
          message: 'Login Successfully',
          svgAsset: CommonUi.setSvgImage(AssetsPath.loginSuccessIcon),
        );
        AppNavigator.pushAndRemoveUntil(
          context,
          RootTabbarscreen(),
          disableSwipeBack: true,
        );
      }
    } else if (result.isVerified == false) {
      if (!context.mounted) return;

      AppSnackBar.custom(
        context,
        message: 'OTP sent successfully! Please verify your email.',
        svgAsset: CommonUi.setSvgImage(AssetsPath.otpIconForAlert),
        backgroundColor: const Color(0xFF3F3D56),
      );

      AppNavigator.push(
        context,
        OtpScreen(email: state.email, isComeFromSignup: true),
        disableSwipeBack: true,
      );
    } else if (result.isAvatar == false) {
      if (!context.mounted) return;

      AppNavigator.pushAndRemoveUntil(
        context,
        AvtarScreen(
          isComeFromSignupScreen: true,
          signupData: {'email': state.email},
        ),
        disableSwipeBack: true,
      );
    }
  }
}
