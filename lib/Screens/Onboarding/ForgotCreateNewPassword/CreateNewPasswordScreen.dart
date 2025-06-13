import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../Constants/ApiClass/ApiErrorModel.dart';
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

  @override
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            ConstantStrings.OtpVerified
          ),
          duration: const Duration(seconds: 4),
        ),
      );
    });
  }

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
      child: BlocConsumer<CreateNewPasswordCubit, CreateNewPasswordState>(
        listenWhen: (prev, curr) => prev.status != curr.status,
        listener: (context, state) {
          if (state.status == CommonApiStatus.failure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage ?? 'Forgot email failed'),
              ),
            );
          }
        },
        builder: (context, state) {
          return Stack(
            children: [
              Scaffold(
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
                            return CustomTextField(
                              label: ConstantStrings.createPasswordLabel,
                              controller: passwordController,
                              errorText: passwordError,
                               obscureText: true,
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
                            return CustomTextField(
                              label: ConstantStrings.confirmPasswordLabel,
                              controller: confirmPasswordController,
                              errorText: confirmPasswordError,
                              obscureText: true,
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
                                context
                                    .read<CreateNewPasswordCubit>()
                                    .resetPasswordApi(context, widget.email);
                              },
                            );
                          },
                        ),
                      ],
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
