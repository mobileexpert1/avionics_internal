import 'package:avionics_internal/Constants/OnboardingTexts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../Constants/constantImages.dart';
import '../CustomFiles/CustomBottomButton.dart';
import '../CustomFiles/CustomTextField.dart';
import '../bloc/signup/signup_cubit.dart';
import '../bloc/signup/signup_state.dart';
import 'HomeScreen.dart';
import 'LoginScreen.dart';

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
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: Wrap(),
          title: Text(OnboardingTexts.CreateAccount),
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
                SizedBox(height: 30),

                BlocSelector<SignupCubit, SignupState, String?>(
                  selector: (state) => state.firstNameError,
                  builder: (context, firstNameError) {
                    return CustomTextField(
                      label: OnboardingTexts.firstNameLabel,
                      controller: firstNameController,
                      errorText: firstNameError,
                      onChanged: (val) =>
                          context.read<SignupCubit>().firstNameChanged(val),
                    );
                  },
                ),
                SizedBox(height: 15),

                BlocSelector<SignupCubit, SignupState, String?>(
                  selector: (state) => state.lastNameError,
                  builder: (context, lastNameError) {
                    return CustomTextField(
                      label: OnboardingTexts.lastNameLabel,
                      controller: lastNameController,
                      errorText: lastNameError,
                      onChanged: (val) =>
                          context.read<SignupCubit>().lastNameChanged(val),
                    );
                  },
                ),
                SizedBox(height: 15),

                BlocSelector<SignupCubit, SignupState, String?>(
                  selector: (state) => state.emailError,
                  builder: (context, emailError) {
                    return CustomTextField(
                      label: OnboardingTexts.emailLabel,
                      controller: emailController,
                      errorText: emailError,
                      onChanged: (val) =>
                          context.read<SignupCubit>().emailChanged(val),
                    );
                  },
                ),
                SizedBox(height: 15),

                BlocSelector<SignupCubit, SignupState, String?>(
                  selector: (state) => state.passwordError,
                  builder: (context, passwordError) {
                    return CustomTextField(
                      label: OnboardingTexts.passwordLabel,
                      controller: passwordController,
                      errorText: passwordError,
                      obscureText: true,
                      onChanged: (val) =>
                          context.read<SignupCubit>().passwordChanged(val),
                    );
                  },
                ),
                SizedBox(height: 15),

                BlocSelector<SignupCubit, SignupState, String?>(
                  selector: (state) => state.confirmPasswordError,
                  builder: (context, confirmPasswordError) {
                    return CustomTextField(
                      label: OnboardingTexts.confirmPasswordLabel,
                      controller: confirmPasswordController,
                      errorText: confirmPasswordError,
                      obscureText: true,
                      onChanged: (val) => context
                          .read<SignupCubit>()
                          .confirmPasswordChanged(val),
                    );
                  },
                ),
                SizedBox(height: 30),

                BlocSelector<SignupCubit, SignupState, bool>(
                  selector: (state) => state.isButtonEnabled,
                  builder: (context, isButtonEnabled) {
                    return CustomBottomButton(
                      title: OnboardingTexts.startSubscription,
                      backgroundColor: const Color.fromRGBO(63, 61, 81, 1.0),
                      textColor: Colors.white,
                      icon: const SizedBox(width: 0),
                      // use SizedBox or an actual icon if needed
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
                SizedBox(height: 15),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LoginScreen()),
                    );
                  },
                  child: Text(
                    OnboardingTexts.loginPrompt,
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
