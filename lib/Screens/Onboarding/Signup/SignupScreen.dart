import 'package:avionics_internal/Constants/ApiClass/ApiErrorModel.dart';
import 'package:avionics_internal/Constants/ConstantStrings.dart';
import 'package:avionics_internal/CustomFiles/CustomAppBar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../Constants/ApiClass/FirebaseAnalytics/analytics_service.dart';
import '../../../Constants/ApiClass/FirebaseAnalytics/event_names.dart';
import '../../../Constants/AppColors.dart';
import '../../../Constants/constantImages.dart';
import '../../../CustomFiles/CustomBottomButton.dart';
import '../../../CustomFiles/CustomTextField.dart';
import '../../../Helpers/AppTextStyles/AppTextStyles.dart';
import '../../../bloc/Onboarding/signup/signup_cubit.dart';
import '../../../bloc/Onboarding/signup/signup_state.dart';
import '../Login/LoginScreen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    AnalyticsService.instance.logVisibleScreen(FirebaseEvents.signupScreen);
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SignupCubit(),
      child: BlocConsumer<SignupCubit, SignupState>(
        listenWhen: (prev, curr) => prev.status != curr.status,
        listener: (context, state) {
          if (!mounted) return;

          if (state.status == CommonApiStatus.failure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.errorMessage ?? 'Signup failed')),
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
                  title: ConstantStrings.CreateAccount,
                  leftButton: IconButton(
                    icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
                    onPressed: () {
                      if (!mounted) return;
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (_) => const LoginScreen()),
                        (route) => false,
                      );
                    },
                  ),
                ),
                body: Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: kIsWeb ? 450 : double.infinity,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                              child: SvgPicture.asset(
                                CommonUi.setSvgImage(AssetsPath.mainLogo),
                                height: 80,
                                fit: BoxFit.contain,
                              ),
                            ),
                            const SizedBox(height: 30),

                            // -------- First Name --------
                            BlocSelector<SignupCubit, SignupState, String?>(
                              selector: (state) => state.firstNameError,
                              builder: (_, error) {
                                return CustomTextField(
                                  label: ConstantStrings.firstNameLabel,
                                  controller: firstNameController,
                                  errorText: error,
                                  onChanged: (val) => context
                                      .read<SignupCubit>()
                                      .firstNameChanged(val),
                                );
                              },
                            ),
                            const SizedBox(height: 20),

                            // -------- Last Name --------
                            BlocSelector<SignupCubit, SignupState, String?>(
                              selector: (state) => state.lastNameError,
                              builder: (_, error) {
                                return CustomTextField(
                                  label: ConstantStrings.lastNameLabel,
                                  controller: lastNameController,
                                  errorText: error,
                                  onChanged: (val) => context
                                      .read<SignupCubit>()
                                      .lastNameChanged(val),
                                );
                              },
                            ),
                            const SizedBox(height: 20),

                            // -------- Email --------
                            BlocSelector<SignupCubit, SignupState, String?>(
                              selector: (state) => state.emailError,
                              builder: (_, error) {
                                return CustomTextField(
                                  label: ConstantStrings.emailLabel,
                                  controller: emailController,
                                  errorText: error,
                                  onChanged: (val) => context
                                      .read<SignupCubit>()
                                      .emailChanged(val),
                                );
                              },
                            ),
                            const SizedBox(height: 20),

                            // -------- Password --------
                            BlocSelector<SignupCubit, SignupState, String?>(
                              selector: (state) => state.passwordError,
                              builder: (_, error) {
                                return CustomTextField(
                                  label: ConstantStrings.passwordLabel,
                                  controller: passwordController,
                                  errorText: error,
                                  obscureText: true,
                                  onChanged: (val) => context
                                      .read<SignupCubit>()
                                      .passwordChanged(val),
                                );
                              },
                            ),
                            const SizedBox(height: 20),

                            // -------- Confirm Password --------
                            BlocSelector<SignupCubit, SignupState, String?>(
                              selector: (state) => state.confirmPasswordError,
                              builder: (_, error) {
                                return CustomTextField(
                                  label: ConstantStrings.confirmPasswordLabel,
                                  controller: confirmPasswordController,
                                  errorText: error,
                                  obscureText: true,
                                  onChanged: (val) => context
                                      .read<SignupCubit>()
                                      .confirmPasswordChanged(val),
                                  onEnterPressed: (val) {
                                    context
                                        .read<SignupCubit>()
                                        .confirmPasswordChanged(val);

                                    if (kIsWeb && mounted) {
                                      context
                                          .read<SignupCubit>()
                                          .verifyEmailRegisteredOrNot(context);
                                    }
                                  },
                                );
                              },
                            ),
                            const SizedBox(height: 30),

                            // -------- Submit Button --------
                            BlocSelector<SignupCubit, SignupState, bool>(
                              selector: (state) => state.isButtonEnabled,
                              builder: (_, enabled) {
                                return CustomBottomButton(
                                  fontStyle: AppTextStyles.regular(21.46).copyWith(
                                    height: 1.0,
                                    color: enabled
                                        ? Colors.white
                                        : Colors.grey.shade600,
                                  ),
                                  title: ConstantStrings.next,
                                  backgroundColor: enabled
                                      ? AppColors.primaryValueColour
                                      : AppColors.darkSeparatorColourAppBar,
                                  textColor: Colors.white,
                                  icon: const SizedBox(width: 0),
                                  isEnabled: enabled,
                                  onPressed: () {
                                    if (!mounted) return;

                                    context
                                        .read<SignupCubit>()
                                        .verifyEmailRegisteredOrNot(context);

                                    AnalyticsService.instance.buttonPressed(
                                      FirebaseEvents.signupButton,
                                      FirebaseEvents.signupScreen,
                                    );
                                  },
                                );
                              },
                            ),
                            const SizedBox(height: 20),

                            // -------- Login Redirect --------
                            Center(
                              child: TextButton(
                                onPressed: () {
                                  if (!mounted) return;

                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => const LoginScreen(),
                                    ),
                                  );

                                  AnalyticsService.instance.buttonPressed(
                                    FirebaseEvents.loginButton,
                                    FirebaseEvents.signupScreen,
                                  );
                                },
                                child: Text(
                                  ConstantStrings.loginPrompt,
                                  style: AppTextStyles.regular(19.31).copyWith(
                                    height: 1.0,
                                    color: AppColors.textColour,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 80),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // -------- Loader Overlay --------
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
