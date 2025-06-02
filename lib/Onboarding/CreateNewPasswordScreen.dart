import 'package:avionics_internal/Constants/OnboardingTexts.dart';
import 'package:avionics_internal/bloc/createNewPassword/createNewPassword_cubit.dart';
import 'package:avionics_internal/bloc/createNewPassword/createNewPassword_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../Constants/constantImages.dart';
import '../CustomFiles/CustomBottomButton.dart';
import '../CustomFiles/CustomTextField.dart';
import '../bloc/login/login_cubit.dart';
import 'HomeScreen.dart';

class CreateNewPasswordScreen extends StatefulWidget {
  @override
  _CreateNewPasswordState createState() => _CreateNewPasswordState();
}

class _CreateNewPasswordState extends State<CreateNewPasswordScreen> {
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  @override
  void dispose() {
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
                SizedBox(height: 30),

                BlocSelector<
                  CreateNewPasswordCubit,
                  CreateNewPasswordState,
                  String?
                >(
                  selector: (state) => state.passwordError,
                  builder: (context, passwordError) {
                    return CustomTextField(
                      label: OnboardingTexts.createPasswordLabel,
                      controller: passwordController,
                      errorText: passwordError,
                      obscureText: true,
                      onChanged: (val) => context
                          .read<CreateNewPasswordCubit>()
                          .passwordChanged(val),
                    );
                  },
                ),
                SizedBox(height: 15),

                BlocSelector<
                  CreateNewPasswordCubit,
                  CreateNewPasswordState,
                  String?
                >(
                  selector: (state) => state.confirmPasswordError,
                  builder: (context, confirmPasswordError) {
                    return CustomTextField(
                      label: OnboardingTexts.confirmPasswordLabel,
                      controller: confirmPasswordController,
                      errorText: confirmPasswordError,
                      obscureText: true,
                      onChanged: (val) => context
                          .read<CreateNewPasswordCubit>()
                          .confirmPasswordChanged(val),
                    );
                  },
                ),
                SizedBox(height: 30),

                BlocSelector<
                  CreateNewPasswordCubit,
                  CreateNewPasswordState,
                  bool
                >(
                  selector: (state) => state.isButtonEnabled,
                  builder: (context, isButtonEnabled) {
                    return CustomBottomButton(
                      title: OnboardingTexts.resetPassword,
                      backgroundColor: const Color.fromRGBO(63, 61, 81, 1.0),
                      textColor: Colors.white,
                      icon: const SizedBox(width: 0),
                      // No icon needed
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
