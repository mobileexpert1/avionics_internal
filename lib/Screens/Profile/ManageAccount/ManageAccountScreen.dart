import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../../Constants/ApiClass/ApiErrorModel.dart';
import '../../../Constants/ApiClass/FirebaseAnalytics/analytics_service.dart';
import '../../../Constants/ApiClass/FirebaseAnalytics/event_names.dart';
import '../../../Constants/AppColors.dart';
import '../../../Constants/constantImages.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../CustomFiles/CustomTextField.dart';
import '../../../Helpers/AppTextStyles/AppTextStyles.dart';
import '../ChangePassword/ChangePasswordScreen.dart';
import '../../../CustomFiles/CustomBottomButton.dart';
import 'package:avionics_internal/CustomFiles/CustomAppBar.dart';
import 'package:avionics_internal/Constants/ConstantStrings.dart';
import 'package:avionics_internal/bloc/Profile/ManageAccount/manageAcc_cubit.dart';
import 'package:avionics_internal/bloc/Profile/ManageAccount/manageAcc_state.dart';

class ManageAccountScreen extends StatefulWidget {
  const ManageAccountScreen({Key? key}) : super(key: key);

  @override
  _ManageAccountScreenState createState() => _ManageAccountScreenState();
}

class _ManageAccountScreenState extends State<ManageAccountScreen> {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  String buttonBottomTitle = ConstantStrings.changePassword;
  bool isRightButtonShow = true;
  bool isTextfiledEnabled = false;
  bool isSocialLogin = false;

  @override
  void initState() {
    super.initState();
    AnalyticsService.instance.logVisibleScreen(
      FirebaseEvents.manageAccountScreen,
    );
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ManageaccCubit()..fetchUserDetails(context),
      child: BlocConsumer<ManageaccCubit, ManageAccState>(
        listener: (context, state) {
          if (!state.isLoading) {
            firstNameController.text = state.firstName;
            lastNameController.text = state.lastName;
            emailController.text = state.email;

            isSocialLogin =
            (state.authType == "apple" ||
                state.authType == "facebook" ||
                state.authType == "google");
          } else if (state.status == CommonApiStatus.failure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage ?? 'Profile update failed'),
              ),
            );
          } else if (state.status == CommonApiStatus.success &&
              state.isLoading == false) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Your profile has been successfully updated'),
              ),
            );
          }
        },
        builder: (context, state) {
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: CustomAppBar(
              title: ConstantStrings.manageAccount,
              centerTitle: false,
              leftButton: IconButton(
                icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
              rightButton: isRightButtonShow
                  ? Padding(
                padding: const EdgeInsets.all(15),
                child: GestureDetector(
                  child: SvgPicture.asset(
                    CommonUi.setSvgImage(AssetsPath.editIcon),
                    width: 20,
                    height: 20,
                    color: Colors.white,
                  ),
                  onTap: () {
                    setState(() {
                      isTextfiledEnabled = true;
                      isRightButtonShow = false;
                      buttonBottomTitle = ConstantStrings.saveTitle;
                    });
                  },
                ),
              )
                  : null,
            ),
            body: LayoutBuilder(
              builder: (context, constraints) {
                double maxWidth = constraints.maxWidth > 1500
                    ? 1500
                    : constraints.maxWidth;

                return SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: maxWidth),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const SizedBox(height: 20),
                          CustomTextField(
                            label: ConstantStrings.firstNameLabel,
                            controller: firstNameController,
                            errorText: state.firstNameError,
                            onChanged: (val) => context
                                .read<ManageaccCubit>()
                                .firstNameChanged(val),
                            enabled: isTextfiledEnabled,
                          ),
                          const SizedBox(height: 15),
                          CustomTextField(
                            label: ConstantStrings.lastNameLabel,
                            controller: lastNameController,
                            errorText: state.lastNameError,
                            onChanged: (val) => context
                                .read<ManageaccCubit>()
                                .lastNameChanged(val),
                            enabled: isTextfiledEnabled,
                          ),
                          const SizedBox(height: 15),
                          CustomTextField(
                            label: ConstantStrings.emailLabel,
                            controller: emailController,
                            errorText: state.emailError,
                            enabled: false,
                          ),
                          const SizedBox(height: 30),
                          CustomBottomButton(
                            fontStyle: AppTextStyles.regular(
                              21.46,
                            ).copyWith(height: 1.0, color: Colors.white),
                            title: buttonBottomTitle,
                            backgroundColor: state.isButtonEnabled
                                ? AppColors.primaryValueColour
                                : AppColors.darkSeparatorColourAppBar,
                            textColor: Colors.white,
                            icon: const SizedBox(width: 0),
                            isEnabled:
                            (buttonBottomTitle == ConstantStrings.saveTitle)
                                ? state.isButtonEnabled
                                : !isSocialLogin && state.isButtonEnabled,
                            onPressed: () async {
                              if (buttonBottomTitle ==
                                  ConstantStrings.changePassword) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        ChangePasswordScreen(),
                                  ),
                                );
                              } else if (buttonBottomTitle ==
                                  ConstantStrings.saveTitle) {
                                final cubit = context.read<ManageaccCubit>();
                                if (cubit.validateFields()) {
                                  await cubit.updateUserDetails(context);
                                  setState(() {
                                    isTextfiledEnabled = false;
                                    isRightButtonShow = true;
                                    buttonBottomTitle =
                                        ConstantStrings.changePassword;
                                  });
                                  AnalyticsService.instance.buttonPressed(
                                    FirebaseEvents.saveProfileInfoButton,
                                    FirebaseEvents.manageAccountScreen,
                                  );
                                }
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
