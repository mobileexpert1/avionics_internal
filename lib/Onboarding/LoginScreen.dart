import 'package:avionics_internal/Constants/AppColors.dart';
import 'package:avionics_internal/Constants/OnboardingTexts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../Constants/constantImages.dart';
import '../CustomFiles/CustomBottomButton.dart';
import '../CustomFiles/CustomSocialLoginButtons.dart';
import '../CustomFiles/CustomTextField.dart';
import '../bloc/login/login_cubit.dart';
import '../bloc/login/login_state.dart';
import 'ForgotScreen.dart';
import 'HomeScreen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LoginCubit(),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: Wrap(),
          title: Text(OnboardingTexts.titleLogin),
          surfaceTintColor: Colors.white,
          backgroundColor: Colors.white,
          centerTitle: true,
          shape: Border(bottom: BorderSide(color: Colors.grey, width: 1)),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 20),
                SvgPicture.asset(
                  CommonUi.setSvgImage(AssetsPath.logoMain),
                  fit: BoxFit.fill,
                ),
                SizedBox(height: 20),
                BlocSelector<LoginCubit, LoginState, String?>(
                  selector: (state) => state.emailError,
                  builder: (context, emailError) {
                    return CustomTextField(
                      label: OnboardingTexts.emailLabel,
                      controller: emailController,
                      errorText: emailError,
                      onChanged: (val) =>
                          context.read<LoginCubit>().emailChanged(val),
                    );
                  },
                ),
                SizedBox(height: 15),

                BlocSelector<LoginCubit, LoginState, String?>(
                  selector: (state) => state.passwordError,
                  builder: (context, passwordError) {
                    return CustomTextField(
                      label: OnboardingTexts.passwordLabel,
                      controller: passwordController,
                      obscureText: true,
                      errorText: passwordError,
                      onChanged: (val) =>
                          context.read<LoginCubit>().passwordChanged(val),
                    );
                  },
                ),
                SizedBox(height: 30),

                BlocSelector<LoginCubit, LoginState, bool>(
                  selector: (state) => state.isButtonEnabled,
                  builder: (context, isButtonEnabled) {
                    return CustomBottomButton(
                      title: OnboardingTexts.loginButton,
                      backgroundColor: const Color.fromRGBO(63, 61, 81, 1.0),
                      textColor: Colors.white,
                      icon: const SizedBox(width: 0),
                      // No icon shown
                      isEnabled: isButtonEnabled,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => HomeScreen()),
                        );
                      },
                    );
                  },
                ),
                SizedBox(height: 10),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Forgotscreen()),
                    );
                  },
                  child: Text(
                    OnboardingTexts.forgotPassword,
                    style: TextStyle(color: Color.fromRGBO(63, 61, 81, 1.0)),
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  OnboardingTexts.orContinue,
                  style: TextStyle(color: Color.fromRGBO(63, 61, 81, 1.0)),
                ),
                SizedBox(height: 12),

                CustomSocialLoginButtons(
                  backgroundColor: Colors.white,
                  textColor: Colors.black,
                  title: OnboardingTexts.loginWithGoogle,
                  icon: SvgPicture.asset(
                    CommonUi.setSvgImage(AssetsPath.google),
                    fit: BoxFit.fill,
                  ),
                  onPressed: () {
                    // Google login
                  },
                ),
                SizedBox(height: 12),

                CustomSocialLoginButtons(
                  backgroundColor: Colors.black,
                  textColor: Colors.white,
                  title: OnboardingTexts.loginWithApple,
                  icon: SvgPicture.asset(
                    CommonUi.setSvgImage(AssetsPath.apple),
                    fit: BoxFit.fill,
                  ),
                  onPressed: () {
                    // Apple login
                  },
                ),
                SizedBox(height: 12),
                CustomSocialLoginButtons(
                  backgroundColor: AppColors.facebookButton,
                  textColor: Colors.white,
                  title: OnboardingTexts.loginWithFacebook,
                  icon: SvgPicture.asset(
                    CommonUi.setSvgImage(AssetsPath.facebook),
                    fit: BoxFit.fill,
                  ),
                  onPressed: () {
                    // Facebook login
                  },
                ),
                SizedBox(height: 30),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    OnboardingTexts.signUpPrompt,
                    style: TextStyle(color: Color.fromRGBO(63, 61, 81, 1.0)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
