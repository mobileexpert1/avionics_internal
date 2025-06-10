import 'package:avionics_internal/Constants/ApiErrorModel.dart';
import 'package:avionics_internal/Constants/ConstantStrings.dart';
import 'package:avionics_internal/Onboarding/Otp/OtpScreen.dart';
import 'package:avionics_internal/Subscription/SubscriptionScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../Constants/constantImages.dart';
import '../../CustomFiles/CustomBottomButton.dart';
import '../../CustomFiles/CustomTextField.dart';
import '../../bloc/signup/signup_cubit.dart';
import '../../bloc/signup/signup_state.dart';
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
                appBar: AppBar(
                  leading: Wrap(),
                  title: Text(ConstantStrings.CreateAccount),
                  surfaceTintColor: Colors.white,
                  backgroundColor: Colors.white,
                  centerTitle: true,
                  shape: Border(
                    bottom: BorderSide(color: Colors.grey, width: 1),
                  ),
                ),
                body: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        const SizedBox(height: 20),
                        SvgPicture.asset(
                          CommonUi.setSvgImage(AssetsPath.logoMain),
                          fit: BoxFit.fill,
                        ),
                        const SizedBox(height: 30),

                        // First Name
                        BlocSelector<SignupCubit, SignupState, String?>(
                          selector: (state) => state.firstNameError,
                          builder: (context, firstNameError) {
                            return CustomTextField(
                              label: ConstantStrings.firstNameLabel,
                              controller: firstNameController,
                              errorText: firstNameError,
                              onChanged: (val) => context
                                  .read<SignupCubit>()
                                  .firstNameChanged(val),
                            );
                          },
                        ),
                        const SizedBox(height: 15),

                        // Last Name
                        BlocSelector<SignupCubit, SignupState, String?>(
                          selector: (state) => state.lastNameError,
                          builder: (context, lastNameError) {
                            return CustomTextField(
                              label: ConstantStrings.lastNameLabel,
                              controller: lastNameController,
                              errorText: lastNameError,
                              onChanged: (val) => context
                                  .read<SignupCubit>()
                                  .lastNameChanged(val),
                            );
                          },
                        ),
                        const SizedBox(height: 15),

                        // Email
                        BlocSelector<SignupCubit, SignupState, String?>(
                          selector: (state) => state.emailError,
                          builder: (context, emailError) {
                            return CustomTextField(
                              label: ConstantStrings.emailLabel,
                              controller: emailController,
                              errorText: emailError,
                              onChanged: (val) =>
                                  context.read<SignupCubit>().emailChanged(val),
                            );
                          },
                        ),
                        const SizedBox(height: 15),

                        // Password
                        BlocSelector<SignupCubit, SignupState, String?>(
                          selector: (state) => state.passwordError,
                          builder: (context, passwordError) {
                            return CustomTextField(
                              label: ConstantStrings.passwordLabel,
                              controller: passwordController,
                              errorText: passwordError,
                              obscureText: true,
                              onChanged: (val) => context
                                  .read<SignupCubit>()
                                  .passwordChanged(val),
                            );
                          },
                        ),
                        const SizedBox(height: 15),

                        // Confirm Password
                        BlocSelector<SignupCubit, SignupState, String?>(
                          selector: (state) => state.confirmPasswordError,
                          builder: (context, confirmPasswordError) {
                            return CustomTextField(
                              label: ConstantStrings.confirmPasswordLabel,
                              controller: confirmPasswordController,
                              errorText: confirmPasswordError,
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
                              title: ConstantStrings.startSubscription,
                              backgroundColor: const Color.fromRGBO(
                                63,
                                61,
                                81,
                                1.0,
                              ),
                              textColor: Colors.white,
                              icon: const SizedBox(width: 0),
                              isEnabled: isButtonEnabled,
                              onPressed: () {
                                context.read<SignupCubit>().submitSignupApi(
                                  context,
                                );
                              },
                            );
                          },
                        ),
                        const SizedBox(height: 15),

                        // Login Redirect
                        TextButton(
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
                              color: Color.fromRGBO(63, 61, 81, 1.0),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Full-screen loading indicator
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
