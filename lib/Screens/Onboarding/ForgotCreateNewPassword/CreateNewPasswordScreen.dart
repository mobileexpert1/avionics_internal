import 'package:avionics_internal/CustomFiles/CustomAppBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../Constants/ApiClass/ApiErrorModel.dart';
import '../../../Constants/AppColors.dart';
import '../../../Constants/ConstantStrings.dart';
import '../../../Constants/constantImages.dart';
import '../../../CustomFiles/CustomBottomButton.dart';
import '../../../CustomFiles/CustomTextField.dart';
import '../../../bloc/Profile/createNewPassword/createNewPassword_cubit.dart';
import '../../../bloc/Profile/createNewPassword/createNewPassword_state.dart';

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
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(ConstantStrings.OtpVerified),
          duration: Duration(seconds: 4),
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
                content: Text(state.errorMessage ?? 'Password reset failed'),
              ),
            );
          }
        },
        builder: (context, state) {
          return Stack(
            children: [
              Scaffold(
                backgroundColor: Colors.white,
                appBar: CustomAppBar(
                  title: ConstantStrings.appBarTitleResetPwd,
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
                          builder: (_, passwordError) {
                            return CustomTextField(
                              label: ConstantStrings.createNewPasswordLabel,
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
                          builder: (_, confirmPasswordError) {
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

                        /// Submit Button
                        BlocSelector<
                          CreateNewPasswordCubit,
                          CreateNewPasswordState,
                          bool
                        >(
                          selector: (state) => state.isButtonEnabled,
                          builder: (_, isButtonEnabled) {
                            return CustomBottomButton(
                              title: ConstantStrings.resetPassword,
                              backgroundColor: isButtonEnabled
                                  ? AppColors.primaryValueColour
                                  : AppColors.darkSeparatorColourAppBar,
                              textColor: Colors.white,
                              icon: const SizedBox(width: 0),
                              isEnabled: isButtonEnabled,
                              onPressed: () {
                                context
                                    .read<CreateNewPasswordCubit>()
                                    .validateAndSubmit(context, widget.email);
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              /// Loading Overlay
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
