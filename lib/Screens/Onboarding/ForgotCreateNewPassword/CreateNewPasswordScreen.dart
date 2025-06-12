import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../Constants/ConstantStrings.dart';
import '../../../Constants/constantImages.dart';
import '../../../CustomFiles/CustomBottomButton.dart';
import '../../../CustomFiles/CustomTextField.dart';
import '../../../bloc/createNewPassword/createNewPassword_cubit.dart';
import '../../../bloc/createNewPassword/createNewPassword_state.dart';

class CreateNewPasswordScreen extends StatefulWidget {

  final String email;
  const CreateNewPasswordScreen({super.key, required this.email});

  @override
  _CreateNewPasswordState createState() => _CreateNewPasswordState();
}

class _CreateNewPasswordState extends State<CreateNewPasswordScreen> {
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CreateNewPasswordCubit(),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(ConstantStrings.appBarTitleForgotPwd),
          backgroundColor: Colors.white,
          centerTitle: true,
          surfaceTintColor: Colors.white,
          shape: Border(
            bottom: BorderSide(color: Colors.grey.shade300, width: 1),
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

                /// Password Field
                BlocSelector<
                  CreateNewPasswordCubit,
                  CreateNewPasswordState,
                  String?
                >(
                  selector: (state) => state.passwordError,
                  builder: (context, passwordError) {
                    print("BlocSelector ------ 👀 UI passwordError: $passwordError");

                    return CustomTextField(
                      label: ConstantStrings.createPasswordLabel,
                      controller: passwordController,
                      errorText: passwordError,
                      obscureText: _obscurePassword,
                      onChanged: (val) => context
                          .read<CreateNewPasswordCubit>()
                          .passwordChanged(val),
                    );
                  },
                ),

                const SizedBox(height: 15),

                /// Confirm Password Field
                BlocSelector<
                  CreateNewPasswordCubit,
                  CreateNewPasswordState,
                  String?
                >(
                  selector: (state) => state.confirmPasswordError,
                  builder: (context, confirmPasswordError) {
                    print("BlocSelector ------ 👀 UI confirmPasswordError: $confirmPasswordError");

                    return CustomTextField(
                      label: ConstantStrings.confirmPasswordLabel,
                      controller: confirmPasswordController,
                      errorText: confirmPasswordError,
                      obscureText: _obscureConfirmPassword,
                      onChanged: (val) => context
                          .read<CreateNewPasswordCubit>()
                          .confirmPasswordChanged(val),
                    );
                  },
                ),

                const SizedBox(height: 30),

                // Submit Button
                BlocSelector<
                  CreateNewPasswordCubit,
                  CreateNewPasswordState,
                  bool
                >(
                  selector: (state) => state.isButtonEnabled,
                  builder: (context, isButtonEnabled) {
                    return CustomBottomButton(
                      title: ConstantStrings.resetPassword,
                      backgroundColor: const Color.fromRGBO(63, 61, 81, 1.0),
                      textColor: Colors.white,
                      icon: const SizedBox(width: 0),
                      isEnabled: isButtonEnabled,
                      onPressed: () {
                        context.read<CreateNewPasswordCubit>().resetPasswordApi(
                          context,
                          widget.email,
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
