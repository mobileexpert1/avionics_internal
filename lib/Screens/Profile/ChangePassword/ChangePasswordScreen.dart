import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../Constants/ApiClass/ApiErrorModel.dart';
import '../../../Constants/ApiClass/FirebaseAnalytics/analytics_service.dart';
import '../../../Constants/ApiClass/FirebaseAnalytics/event_names.dart';
import '../../../Constants/AppColors.dart';
import '../../../CustomFiles/CustomAppBar.dart';
import '../../../CustomFiles/CustomTextField.dart';
import '../../../CustomFiles/CustomBottomButton.dart';
import 'package:avionics_internal/Constants/ConstantStrings.dart';
import '../../../Helpers/AppTextStyles/AppTextStyles.dart';
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
  void initState() {
    super.initState();
    AnalyticsService.instance.logVisibleScreen(
      FirebaseEvents.changePasswordScreen,
    );
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
                  centerTitle: false,
                  leftButton: IconButton(
                    icon: const Icon(Icons.arrow_back_ios, color: Colors.white,size: 30),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
                body: LayoutBuilder(
                  builder: (context, constraints) {
                    double maxWidth = constraints.maxWidth > 1500
                        ? 1500
                        : constraints.maxWidth;

                    return SingleChildScrollView(
                      padding: const EdgeInsets.all(16.0),
                      child: Align(
                        alignment: Alignment.topCenter,
                        child: ConstrainedBox(
                          constraints: BoxConstraints(maxWidth: maxWidth),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              const SizedBox(height: 20),
                              BlocSelector<
                                ChangePasswordCubit,
                                ChangeNewPasswordState,
                                String?
                              >(
                                selector: (state) => state.oldPasswordError,
                                builder: (context, oldPasswordError) {
                                  return CustomTextField(
                                    obscureText: true,
                                    label: ConstantStrings.oldPasswordLabel,
                                    controller: oldPasswordController,
                                    errorText: oldPasswordError,
                                    onChanged: (val) => context
                                        .read<ChangePasswordCubit>()
                                        .oldPasswordChanged(val),
                                  );
                                },
                              ),
                              const SizedBox(height: 15),
                              BlocSelector<
                                ChangePasswordCubit,
                                ChangeNewPasswordState,
                                String?
                              >(
                                selector: (state) => state.passwordError,
                                builder: (context, passwordError) {
                                  return CustomTextField(
                                    obscureText: true,
                                    label: ConstantStrings.newPasswordLabel,
                                    controller: namePasswordController,
                                    errorText: passwordError,
                                    onChanged: (val) => context
                                        .read<ChangePasswordCubit>()
                                        .newPasswordChanged(val),
                                  );
                                },
                              ),
                              const SizedBox(height: 15),
                              BlocSelector<
                                ChangePasswordCubit,
                                ChangeNewPasswordState,
                                String?
                              >(
                                selector: (state) => state.confirmPasswordError,
                                builder: (context, confirmPasswordError) {
                                  return CustomTextField(
                                    obscureText: true,
                                    label: ConstantStrings.confirmPasswordLabel,
                                    controller: confirmPasswordController,
                                    errorText: confirmPasswordError,
                                    onChanged: (val) => context
                                        .read<ChangePasswordCubit>()
                                        .confirmPasswordChanged(val),
                                  );
                                },
                              ),
                              const SizedBox(height: 30),
                              BlocSelector<
                                ChangePasswordCubit,
                                ChangeNewPasswordState,
                                bool
                              >(
                                selector: (state) => state.isButtonEnabled,
                                builder: (context, isButtonEnabled) {
                                  return CustomBottomButton(
                                    fontStyle: AppTextStyles.regular(21.46).copyWith(
                                      height: 1.0,
                                      color: isButtonEnabled
                                          ? Colors.white
                                          : Colors.grey.shade600,
                                    ),
                                    title: ConstantStrings.saveTitle,
                                    backgroundColor: isButtonEnabled
                                        ? AppColors.primaryValueColour
                                        : AppColors.darkSeparatorColourAppBar,
                                    textColor: Colors.white,
                                    icon: const SizedBox(width: 0),
                                    isEnabled: isButtonEnabled,
                                    onPressed: () {
                                      context
                                          .read<ChangePasswordCubit>()
                                          .submitIfValid(context);
                                      AnalyticsService.instance.buttonPressed(
                                        FirebaseEvents.changePasswordButton,
                                        FirebaseEvents.changePasswordScreen,
                                      );
                                    },
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
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
