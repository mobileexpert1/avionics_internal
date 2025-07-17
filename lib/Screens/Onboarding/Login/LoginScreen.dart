// LoginScreen.dart

import 'dart:io';

import 'package:avionics_internal/Constants/AppColors.dart';
import 'package:avionics_internal/Constants/ConstantStrings.dart';
import 'package:avionics_internal/Screens/Onboarding/Signup/SignupScreen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../Constants/ApiClass/ApiErrorModel.dart';
import '../../../Constants/constantImages.dart';
import '../../../CustomFiles/CustomAppBar.dart';
import '../../../CustomFiles/CustomBottomButton.dart';
import '../../../CustomFiles/CustomSocialLoginButtons.dart';
import '../../../CustomFiles/CustomTextField.dart';
import '../../../bloc/login/login_cubit.dart';
import '../../../bloc/login/login_state.dart';
import '../ForgotCreateNewPassword/ForgotScreen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

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
      child: BlocConsumer<LoginCubit, LoginState>(
        listenWhen: (prev, curr) => prev.status != curr.status,
        listener: (context, state) {
          if (state.status == CommonApiStatus.failure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.errorMessage ?? 'Login failed')),
            );
          }
        },
        builder: (context, state) {
          return Stack(
            children: [
              Scaffold(
                backgroundColor: Colors.white,
                appBar: CustomAppBar(title: ConstantStrings.loginButton),
                body: Center(
                  child: ConstrainedBox(
                    constraints: kIsWeb
                        ? const BoxConstraints(
                        maxWidth: 450) // Web layout width capped
                        : const BoxConstraints(), // Mobile: no constraint
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            const SizedBox(height: 20),
                            SvgPicture.asset(
                              CommonUi.setSvgImage(AssetsPath.logoMain),
                              fit: BoxFit.fill,
                            ),
                            const SizedBox(height: 20),

                            BlocBuilder<LoginCubit, LoginState>(
                              buildWhen: (prev, curr) =>
                              prev.emailError != curr.emailError,
                              builder: (context, state) {
                                return CustomTextField(
                                  label: ConstantStrings.emailLabel,
                                  controller: emailController,
                                  errorText: state.emailError,
                                  onChanged: (val) =>
                                      context.read<LoginCubit>().emailChanged(
                                          val),
                                );
                              },
                            ),
                            const SizedBox(height: 15),
                            CustomSocialLoginButtons(
                              backgroundColor: AppColors.facebookButton,
                              textColor: Colors.white,
                              title: ConstantStrings.loginWithFacebook,
                              icon: SvgPicture.asset(
                                CommonUi.setSvgImage(AssetsPath.facebook),
                                fit: BoxFit.fill,
                              ),
                              onPressed: () {
                                context.read<LoginCubit>().signInWithFacebook(
                                  context,
                                );
                              },
                            ),
                            const SizedBox(height: 30),

                            BlocBuilder<LoginCubit, LoginState>(
                              buildWhen: (prev, curr) =>
                              prev.passwordError != curr.passwordError,
                              builder: (context, state) {
                                return CustomTextField(
                                  label: ConstantStrings.passwordLabel,
                                  controller: passwordController,
                                  obscureText: true,
                                  errorText: state.passwordError,
                                  onChanged: (val) =>
                                      context
                                          .read<LoginCubit>()
                                          .passwordChanged(val),
                                );
                              },
                            ),
                            const SizedBox(height: 30),

                            BlocSelector<LoginCubit, LoginState, bool>(
                              selector: (state) => state.isButtonEnabled,
                              builder: (context, isButtonEnabled) {
                                return CustomBottomButton(
                                  title: ConstantStrings.loginButton,
                                  backgroundColor: isButtonEnabled
                                      ? AppColors.customBottomEnabledColour
                                      : AppColors.customBottomDisableColour,
                                  textColor: Colors.white,
                                  icon: const SizedBox(width: 0),
                                  isEnabled: isButtonEnabled,
                                  onPressed: () =>
                                      context
                                          .read<LoginCubit>()
                                          .validateAndLogin(context),
                                );
                              },
                            ),

                            const SizedBox(height: 10),
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => Forgotscreen(),
                                  ),
                                );
                              },
                              child: Text(
                                ConstantStrings.forgotPassword,
                                style: TextStyle(
                                  color: AppColors.textColour,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),

                            Text(
                              ConstantStrings.orContinue,
                              style: TextStyle(
                                color: AppColors.textColour,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 20),

                            CustomSocialLoginButtons(
                              backgroundColor: Colors.white,
                              textColor: Colors.black,
                              title: ConstantStrings.loginWithGoogle,
                              icon: SvgPicture.asset(
                                CommonUi.setSvgImage(AssetsPath.google),
                                fit: BoxFit.fill,
                              ),
                              onPressed: () {
                                context.read<LoginCubit>().signInWithGoogle(
                                    context);
                              },
                            ),

                            const SizedBox(height: 12),
                            if (!kIsWeb &&
                                (defaultTargetPlatform == TargetPlatform.iOS ||
                                    defaultTargetPlatform ==
                                        TargetPlatform.macOS)) ...[
                              CustomSocialLoginButtons(
                                backgroundColor: Colors.black,
                                textColor: Colors.white,
                                title: ConstantStrings.loginWithApple,
                                icon: SvgPicture.asset(
                                  CommonUi.setSvgImage(AssetsPath.apple),
                                  fit: BoxFit.fill,
                                ),
                                onPressed: () {
                                  context.read<LoginCubit>().signInWithApple(
                                      context);
                                },
                              ),
                              const SizedBox(height: 12),
                            ],

                            CustomSocialLoginButtons(
                              backgroundColor: AppColors.facebookButton,
                              textColor: Colors.white,
                              title: ConstantStrings.loginWithFacebook,
                              icon: SvgPicture.asset(
                                CommonUi.setSvgImage(AssetsPath.facebook),
                                fit: BoxFit.fill,
                              ),
                              onPressed: () {
                                // context.read<LoginCubit>().signInWithFacebook(context);
                              },
                            ),
                            const SizedBox(height: 30),

                            TextButton(
                              onPressed: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => SignupScreen(),
                                  ),
                                );
                              },
                              child: Text(
                                ConstantStrings.signUpPrompt,
                                style: TextStyle(color: AppColors.textColour),
                              ),
                            ),
                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

              ),
              if (state.status == CommonApiStatus.submitting)
                Container(
                  color: Colors.black.withOpacity(0.3),
                  child: const Center(child: CircularProgressIndicator()),
                ),
            ],
          );
        },
      ),
    );
  }
}
