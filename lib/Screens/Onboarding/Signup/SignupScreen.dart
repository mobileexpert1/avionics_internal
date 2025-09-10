import 'package:avionics_internal/Constants/ApiClass/ApiErrorModel.dart';
import 'package:avionics_internal/Constants/ConstantStrings.dart';
import 'package:avionics_internal/CustomFiles/CustomAppBar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../Constants/AppColors.dart';
import '../../../Constants/constantImages.dart';
import '../../../CustomFiles/CustomBottomButton.dart';
import '../../../CustomFiles/CustomTextField.dart';
import '../../../bloc/Onboarding/signup/signup_cubit.dart';
import '../../../bloc/Onboarding/signup/signup_state.dart';
import '../Login/LoginScreen.dart';

class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

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
                  title: ConstantStrings.CreateAccount,
                  leftButton: IconButton(
                    icon: const Icon(
                      Icons.arrow_back_ios,
                      color: Color(0xFF151A6A),
                    ),
                    onPressed: () {
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (_) => LoginScreen()),
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
                      padding: const EdgeInsets.all(16.0),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 20),
                            Center(
                              child: SvgPicture.asset(
                                CommonUi.setSvgImage(AssetsPath.logoMain),
                                height: 80,
                                fit: BoxFit.contain,
                              ),
                            ),
                            const SizedBox(height: 30),

                            // First Name
                            BlocSelector<SignupCubit, SignupState, String?>(
                              selector: (state) => state.firstNameError,
                              builder: (context, firstNameError) {
                                return CustomTextField(
                                  label: ConstantStrings.firstNameLabel,
                                  controller: firstNameController,
                                  errorText: state.firstNameError,
                                  onChanged: (val) => context
                                      .read<SignupCubit>()
                                      .firstNameChanged(val),
                                );
                              },
                            ),
                            const SizedBox(height: 20),

                            // Last Name
                            BlocSelector<SignupCubit, SignupState, String?>(
                              selector: (state) => state.lastNameError,
                              builder: (context, lastNameError) {
                                return CustomTextField(
                                  label: ConstantStrings.lastNameLabel,
                                  controller: lastNameController,
                                  errorText: state.lastNameError,
                                  onChanged: (val) => context
                                      .read<SignupCubit>()
                                      .lastNameChanged(val),
                                );
                              },
                            ),
                            const SizedBox(height: 20),

                            // Email
                            BlocSelector<SignupCubit, SignupState, String?>(
                              selector: (state) => state.emailError,
                              builder: (context, emailError) {
                                return CustomTextField(
                                  label: ConstantStrings.emailLabel,
                                  controller: emailController,
                                  errorText: state.emailError,
                                  onChanged: (val) => context
                                      .read<SignupCubit>()
                                      .emailChanged(val),
                                );
                              },
                            ),
                            const SizedBox(height: 20),

                            // Password
                            BlocSelector<SignupCubit, SignupState, String?>(
                              selector: (state) => state.passwordError,
                              builder: (context, passwordError) {
                                return CustomTextField(
                                  label: ConstantStrings.passwordLabel,
                                  controller: passwordController,
                                  errorText: state.passwordError,
                                  obscureText: true,
                                  onChanged: (val) => context
                                      .read<SignupCubit>()
                                      .passwordChanged(val),
                                );
                              },
                            ),
                            const SizedBox(height: 20),

                            // Confirm Password
                            BlocSelector<SignupCubit, SignupState, String?>(
                              selector: (state) => state.confirmPasswordError,
                              builder: (context, confirmPasswordError) {
                                return CustomTextField(
                                  label: ConstantStrings.confirmPasswordLabel,
                                  controller: confirmPasswordController,
                                  errorText: state.confirmPasswordError,
                                  obscureText: true,
                                  onChanged: (val) => context
                                      .read<SignupCubit>()
                                      .confirmPasswordChanged(val),
                                );
                              },
                            ),
                            const SizedBox(height: 30),

                            // Submit Button
                            BlocSelector<SignupCubit, SignupState, bool>(
                              selector: (state) => state.isButtonEnabled,
                              builder: (context, isButtonEnabled) {
                                return CustomBottomButton(
                                  title: ConstantStrings.next,
                                  backgroundColor: state.isButtonEnabled
                                      ? AppColors.customBottomEnabledColour
                                      : AppColors.customBottomDisableColour,
                                  textColor: Colors.white,
                                  icon: const SizedBox(width: 0),
                                  isEnabled: state.isButtonEnabled,
                                  onPressed: () => context
                                      .read<SignupCubit>()
                                      .verifyEmailRegisteredOrNot(context),
                                );
                              },
                            ),
                            const SizedBox(height: 10),

                            // Login Redirect
                            Center(
                              child: TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => LoginScreen(),
                                    ),
                                  );
                                },
                                child: Text(
                                  ConstantStrings.loginPrompt,
                                  style: TextStyle(
                                    color: AppColors.textColour,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ),
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
