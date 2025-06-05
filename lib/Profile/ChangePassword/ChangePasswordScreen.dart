import 'package:avionics_internal/Constants/OnboardingTexts.dart';
import 'package:avionics_internal/Subscription/SubscriptionScreen.dart';
import 'package:avionics_internal/bloc/Profile/ManageAccount/manageAcc_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
        appBar: AppBar(
          title: Text(
            OnboardingTexts.changePasswordLabel,
            style: TextStyle(fontSize: 16),
          ),
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
                BlocSelector<ChangePasswordCubit, ChangepasswordState, String?>(
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

                BlocSelector<ChangePasswordCubit, ChangepasswordState, String?>(
                  selector: (state) => state.newPasswordError,
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

                BlocSelector<ChangePasswordCubit, ChangepasswordState, String?>(
                  selector: (state) => state.newConfirmPasswordError,
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

                BlocSelector<ChangePasswordCubit, ChangepasswordState, bool>(
                  selector: (state) => state.isButtonEnabled,
                  builder: (context, isButtonEnabled) {
                    return CustomBottomButton(
                      title: OnboardingTexts.saveTitle,
                      backgroundColor: const Color.fromRGBO(63, 61, 81, 1.0),
                      textColor: Colors.white,
                      icon: const SizedBox(width: 0),
                      // use SizedBox or an actual icon if needed
                      isEnabled: true,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SubscriptionScreen(),
                          ),
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
