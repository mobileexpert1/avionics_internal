import 'package:avionics_internal/Constants/AppColors.dart';
import 'package:avionics_internal/Constants/ConstantStrings.dart';
import 'package:avionics_internal/Screens/Onboarding/Signup/SignupScreen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_uxcam/flutter_uxcam.dart';

import '../../../Constants/ApiClass/ApiErrorModel.dart';
import '../../../Constants/ApiClass/FirebaseAnalytics/analytics_service.dart';
import '../../../Constants/ApiClass/FirebaseAnalytics/event_names.dart';
import '../../../Constants/constantImages.dart';
import '../../../CustomFiles/CustomAppBar.dart';
import '../../../CustomFiles/CustomBottomButton.dart';
import '../../../CustomFiles/CustomSocialLoginButtons.dart';
import '../../../CustomFiles/CustomTextField.dart';
import '../../../Helpers/AppNavigator.dart';
import '../../../Helpers/AppTextStyles/AppTextStyles.dart';
import '../../../bloc/Onboarding/login/login_cubit.dart';
import '../../../bloc/Onboarding/login/login_state.dart';
import '../ForgotCreateNewPassword/ForgotScreen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    AnalyticsService.instance.logVisibleScreen(FirebaseEvents.loginScreen);
    FlutterUxcam.tagScreenName("Login Screen");
  }

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
          if (!mounted) return;
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
                appBar: CustomAppBar(
                  isClearBackgroundColour: true,
                  title: ConstantStrings.loginButton,
                ),
                body: Center(
                  child: ConstrainedBox(
                    constraints: kIsWeb
                        ? const BoxConstraints(maxWidth: 450)
                        : const BoxConstraints(),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            SvgPicture.asset(
                              CommonUi.setSvgImage(AssetsPath.mainLogo),
                              fit: BoxFit.fill,
                            ),

                            const SizedBox(height: 20),

                            // -------- Email --------
                            BlocBuilder<LoginCubit, LoginState>(
                              buildWhen: (p, c) => p.emailError != c.emailError,
                              builder: (context, state) {
                                return CustomTextField(
                                  label: ConstantStrings.email,
                                  controller: emailController,
                                  errorText: state.emailError,
                                  onChanged: (val) => context
                                      .read<LoginCubit>()
                                      .emailChanged(val),
                                );
                              },
                            ),

                            const SizedBox(height: 15),

                            // -------- Password --------
                            BlocBuilder<LoginCubit, LoginState>(
                              buildWhen: (p, c) =>
                                  p.passwordError != c.passwordError,
                              builder: (context, state) {
                                return CustomTextField(
                                  label: ConstantStrings.password,
                                  controller: passwordController,
                                  obscureText: true,
                                  errorText: state.passwordError,
                                  onChanged: (val) => context
                                      .read<LoginCubit>()
                                      .passwordChanged(val),
                                  onEnterPressed: (val) {
                                    context.read<LoginCubit>().passwordChanged(
                                      val,
                                    );

                                    if (kIsWeb && mounted) {
                                      context
                                          .read<LoginCubit>()
                                          .validateAndLogin(context);
                                    }
                                  },
                                );
                              },
                            ),

                            const SizedBox(height: 30),

                            // -------- Login Button --------
                            BlocSelector<LoginCubit, LoginState, bool>(
                              selector: (state) => state.isButtonEnabled,
                              builder: (_, enabled) {
                                return CustomBottomButton(
                                  fontStyle: AppTextStyles.regular(21.46)
                                      .copyWith(
                                        height: 1.0,
                                        color: enabled
                                            ? Colors.white
                                            : Colors.grey.shade600,
                                      ),
                                  title: ConstantStrings.loginButton,
                                  backgroundColor: enabled
                                      ? AppColors.primaryValueColour
                                      : AppColors.darkSeparatorColourAppBar,
                                  textColor: Colors.white,
                                  icon: const SizedBox(width: 0),
                                  isEnabled: enabled,
                                  onPressed: () {
                                    if (!mounted) return;
                                    FlutterUxcam.logEvent("Login Button Clicked");
                                    context.read<LoginCubit>().validateAndLogin(
                                      context,
                                    );
                                  },
                                );
                              },
                            ),

                            const SizedBox(height: 10),

                            // -------- Forgot Password --------
                            TextButton(
                              onPressed: () {
                                if (!mounted) return;
                                AppNavigator.push(
                                  context,
                                  ForgotScreen(),
                                  disableSwipeBack: true,
                                );

                                AnalyticsService.instance.buttonPressed(
                                  FirebaseEvents.forgotButton,
                                  FirebaseEvents.loginScreen,
                                );
                              },
                              child: Text(
                                ConstantStrings.forgotPassword,
                                style: AppTextStyles.medium(19.31).copyWith(
                                  height: 1.0,
                                  color: AppColors.textColour,
                                ),
                              ),
                            ),

                            const SizedBox(height: 15),

                            Text(
                              ConstantStrings.orContinue,
                              style: AppTextStyles.regular(19.31).copyWith(
                                height: 1.0,
                                color: AppColors.textColour,
                              ),
                            ),

                            const SizedBox(height: 20),

                            // -------- Google --------
                            CustomSocialLoginButtons(
                              backgroundColor: Colors.white,
                              textColor: Colors.black,
                              title: ConstantStrings.loginWithGoogle,
                              icon: SvgPicture.asset(
                                CommonUi.setSvgImage(AssetsPath.googleIcon),
                                fit: BoxFit.fill,
                              ),
                              onPressed: () {
                                if (!mounted) return;
                                context.read<LoginCubit>().signInWithGoogle(
                                  context,
                                );
                              },
                            ),

                            const SizedBox(height: 12),

                            // -------- Apple --------
                            if (!kIsWeb &&
                                (defaultTargetPlatform == TargetPlatform.iOS ||
                                    defaultTargetPlatform ==
                                        TargetPlatform.macOS)) ...[
                              CustomSocialLoginButtons(
                                backgroundColor: Colors.black,
                                textColor: Colors.white,
                                title: ConstantStrings.loginWithApple,
                                icon: SvgPicture.asset(
                                  CommonUi.setSvgImage(AssetsPath.appleIcon),
                                  fit: BoxFit.fill,
                                ),
                                onPressed: () {
                                  if (!mounted) return;
                                  context.read<LoginCubit>().signInWithApple(
                                    context,
                                  );
                                },
                              ),
                              const SizedBox(height: 12),
                            ],

                            // -------- Facebook --------
                            CustomSocialLoginButtons(
                              backgroundColor: AppColors.facebookButton,
                              textColor: Colors.white,
                              title: ConstantStrings.loginWithFacebook,
                              icon: SvgPicture.asset(
                                CommonUi.setSvgImage(AssetsPath.facebookIcon),
                                fit: BoxFit.fill,
                              ),
                              onPressed: () {
                                if (!mounted) return;
                                context.read<LoginCubit>().signInWithFacebook(
                                  context,
                                );
                              },
                            ),

                            const SizedBox(height: 20),

                            // -------- Signup --------
                            TextButton(
                              onPressed: () {
                                if (!mounted) return;
                                AppNavigator.pushReplacement(
                                  context,
                                  SignupScreen(),
                                  disableSwipeBack: true,
                                );
                                AnalyticsService.instance.buttonPressed(
                                  FirebaseEvents.signupButton,
                                  FirebaseEvents.loginScreen,
                                );
                              },
                              child: Text(
                                ConstantStrings.signUpPrompt,
                                style: AppTextStyles.regular(19.31).copyWith(
                                  height: 1.0,
                                  color: AppColors.textColour,
                                ),
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

              // -------- Loader --------
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
