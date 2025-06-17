import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../Constants/ApiClass/ApiErrorModel.dart';
import '../../../Constants/AppColors.dart';
import '../../../CustomFiles/CustomAppBar.dart';
import '../../../CustomFiles/CustomTextField.dart';
import '../../../CustomFiles/CustomBottomButton.dart';
import 'package:avionics_internal/Constants/ConstantStrings.dart';
import '../../../bloc/Profile/ChangePassword/changePassword_cubit.dart';
import '../../../bloc/Profile/ChangePassword/changePassword_state.dart';

class ChangePasswordScreen extends StatefulWidget {
  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final TextEditingController oldPasswordController = TextEditingController();
  final TextEditingController namePasswordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  @override
  void dispose() {
    oldPasswordController.dispose();
    namePasswordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ChangePasswordCubit(),
      child: BlocConsumer<ChangePasswordCubit, ChangeNewPasswordState>(
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
                appBar: CustomAppBar(
                  title: ConstantStrings.changePassword,
                  leftButton: IconButton(
                    icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
                body: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(height: 20),
                        BlocSelector<
                          ChangePasswordCubit,
                          ChangeNewPasswordState,
                          String?
                        >(
                          selector: (state) => state.oldPasswordError,
                          builder: (context, firstNameError) {
                            return CustomTextField(
                              obscureText: true,

                              label: ConstantStrings.oldPasswordLabel,
                              controller: oldPasswordController,
                              errorText: firstNameError,
                              onChanged: (val) => context
                                  .read<ChangePasswordCubit>()
                                  .oldPasswordChanged(val),
                            );
                          },
                        ),
                        SizedBox(height: 15),

                        BlocSelector<
                          ChangePasswordCubit,
                          ChangeNewPasswordState,
                          String?
                        >(
                          selector: (state) => state.passwordError,
                          builder: (context, lastNameError) {
                            return CustomTextField(
                              obscureText: true,

                              label: ConstantStrings.newPasswordLabel,
                              controller: namePasswordController,
                              errorText: lastNameError,
                              onChanged: (val) => context
                                  .read<ChangePasswordCubit>()
                                  .newPasswordChanged(val),
                            );
                          },
                        ),
                        SizedBox(height: 15),

                        BlocSelector<
                          ChangePasswordCubit,
                          ChangeNewPasswordState,
                          String?
                        >(
                          selector: (state) => state.confirmPasswordError,
                          builder: (context, emailError) {
                            return CustomTextField(
                              obscureText: true,
                              label: ConstantStrings.confirmPasswordLabel,
                              controller: confirmPasswordController,
                              errorText: emailError,
                              onChanged: (val) => context
                                  .read<ChangePasswordCubit>()
                                  .confirmPasswordChanged(val),
                            );
                          },
                        ),
                        SizedBox(height: 30),

                        BlocSelector<
                          ChangePasswordCubit,
                          ChangeNewPasswordState,
                          bool
                        >(
                          selector: (state) => state.isButtonEnabled,
                          builder: (context, isButtonEnabled) {
                            return CustomBottomButton(
                              title: ConstantStrings.saveTitle,
                              backgroundColor: state.isButtonEnabled == true
                                  ? AppColors.customBottomEnabledColour
                                  : AppColors.customBottomDisableColour,
                              textColor: Colors.white,
                              icon: const SizedBox(width: 0),
                              isEnabled: isButtonEnabled,
                              onPressed: () {
                                context
                                    .read<ChangePasswordCubit>()
                                    .submitIfValid(context);
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
