import 'package:avionics_internal/Constants/OnboardingTexts.dart';
import 'package:avionics_internal/Subscription/SubscriptionScreen.dart';
import 'package:avionics_internal/bloc/Profile/ManageAccount/manageAcc_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../CustomFiles/CustomAppBar.dart';
import '../../CustomFiles/CustomBottomButton.dart';
import '../../CustomFiles/CustomTextField.dart';
import '../../bloc/Profile/ChangePassword/changePassword_cubit.dart';
import '../../bloc/Profile/ChangePassword/changePassword_state.dart';

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
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: CustomAppBar(
          title: OnboardingTexts.changePassword,
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
                  CreateNewPasswordState,
                  String?
                >(
                  selector: (state) => state.oldPasswordError,
                  builder: (context, firstNameError) {
                    return CustomTextField(
                      obscureText: true,

                      label: OnboardingTexts.oldPasswordLabel,
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
                  CreateNewPasswordState,
                  String?
                >(
                  selector: (state) => state.passwordError,
                  builder: (context, lastNameError) {
                    return CustomTextField(
                      obscureText: true,

                      label: OnboardingTexts.newPasswordLabel,
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
                  CreateNewPasswordState,
                  String?
                >(
                  selector: (state) => state.confirmPasswordError,
                  builder: (context, emailError) {
                    return CustomTextField(
                      obscureText: true,
                      label: OnboardingTexts.confirmPasswordLabel,
                      controller: confirmPasswordController,
                      errorText: emailError,
                      onChanged: (val) => context
                          .read<ChangePasswordCubit>()
                          .confirmPasswordChanged(val),
                    );
                  },
                ),
                SizedBox(height: 30),

                BlocSelector<ChangePasswordCubit, CreateNewPasswordState, bool>(
                  selector: (state) => state.isButtonEnabled,
                  builder: (context, isButtonEnabled) {
                    return CustomBottomButton(
                      title: OnboardingTexts.saveTitle,
                      backgroundColor: const Color.fromRGBO(63, 61, 81, 1.0),
                      textColor: Colors.white,
                      icon: const SizedBox(width: 0),
                      // use SizedBox or an actual icon if needed
                      isEnabled: isButtonEnabled,
                      onPressed: () {
                        Navigator.pop(context);
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
