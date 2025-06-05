import 'package:avionics_internal/Constants/OnboardingTexts.dart';
import 'package:avionics_internal/Home/HomeScreen.dart';
import 'package:avionics_internal/Subscription/SubscriptionScreen.dart';
import 'package:avionics_internal/bloc/Profile/ManageAccount/manageAcc_cubit.dart';
import 'package:avionics_internal/bloc/Profile/ManageAccount/manageAcc_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import '../../Constants/constantImages.dart';
import '../../CustomFiles/CustomBottomButton.dart';
import '../../CustomFiles/CustomTextField.dart';
import '../ChangePassword/ChangePasswordScreen.dart';

class ManageAccountScreen extends StatefulWidget {
  @override
  _ManageAccountScreenState createState() => _ManageAccountScreenState();
}

class _ManageAccountScreenState extends State<ManageAccountScreen> {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  String buttonBottomTitle = OnboardingTexts.changePassword;
  bool isRightButtonShow = true;
  bool isTextfiledEnabled = false;

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
      create: (_) => ManageaccCubit(),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(
            OnboardingTexts.manageAccount,
            style: TextStyle(fontSize: 16),
          ),
          surfaceTintColor: Colors.white,
          backgroundColor: Colors.white,
          centerTitle: true,
          shape: Border(bottom: BorderSide(color: Colors.grey, width: 1)),
          actions: [
            if (isRightButtonShow)
              Padding(
                padding: const EdgeInsets.all(15),
                child: GestureDetector(
                  child: SvgPicture.asset(
                    CommonUi.setSvgImage(AssetsPath.editIcon),
                    width: 20,
                    height: 20,
                  ),
                  onTap: () {
                    setState(() {
                      isTextfiledEnabled = true;
                      isRightButtonShow = false;
                      buttonBottomTitle = OnboardingTexts.saveTitle;
                    });
                  },
                ),
              ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 20),
                BlocSelector<ManageaccCubit, ManageAccState, String?>(
                  selector: (state) => state.firstNameError,
                  builder: (context, firstNameError) {
                    return CustomTextField(
                      label: OnboardingTexts.firstNameLabel,
                      controller: firstNameController,
                      errorText: firstNameError,
                      onChanged: (val) =>
                          context.read<ManageaccCubit>().firstNameChanged(val),
                      enabled: isTextfiledEnabled,
                    );
                  },
                ),
                SizedBox(height: 15),

                BlocSelector<ManageaccCubit, ManageAccState, String?>(
                  selector: (state) => state.lastNameError,
                  builder: (context, lastNameError) {
                    return CustomTextField(
                      label: OnboardingTexts.lastNameLabel,
                      controller: lastNameController,
                      errorText: lastNameError,
                      onChanged: (val) =>
                          context.read<ManageaccCubit>().lastNameChanged(val),
                      enabled: isTextfiledEnabled,
                    );
                  },
                ),
                SizedBox(height: 15),

                BlocSelector<ManageaccCubit, ManageAccState, String?>(
                  selector: (state) => state.emailError,
                  builder: (context, emailError) {
                    return CustomTextField(
                      label: OnboardingTexts.emailLabel,
                      controller: emailController,
                      errorText: emailError,
                      //onChanged: (val) =>   context.read<ManageaccCubit>().emailChanged(val),
                      enabled: false,
                    );
                  },
                ),
                SizedBox(height: 30),

                BlocSelector<ManageaccCubit, ManageAccState, bool>(
                  selector: (state) => state.isButtonEnabled,
                  builder: (context, isButtonEnabled) {
                    return CustomBottomButton(
                      title: buttonBottomTitle,
                      backgroundColor: const Color.fromRGBO(63, 61, 81, 1.0),
                      textColor: Colors.white,
                      icon: const SizedBox(width: 0),
                      // use SizedBox or an actual icon if needed
                      isEnabled: true,
                      onPressed: () {
                        switch (buttonBottomTitle) {
                          case OnboardingTexts.changePassword:
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ChangePasswordScreen(),
                              ),
                            );
                            break;
                          case OnboardingTexts.saveTitle:
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => HomeScreen(),
                              ),
                            );
                            break;
                          default:
                            print("Unhandled button title: $buttonBottomTitle");
                            break;
                        }
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
