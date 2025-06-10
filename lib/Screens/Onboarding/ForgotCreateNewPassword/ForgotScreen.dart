import 'package:avionics_internal/Constants/ConstantStrings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../Constants/constantImages.dart';
import '../../../CustomFiles/CustomBottomButton.dart';
import '../../../CustomFiles/CustomTextField.dart';
import '../../../bloc/forgotPassword/forgot_cubit.dart';
import '../../../bloc/forgotPassword/forgot_state.dart';
import '../Otp/OtpScreen.dart';

class Forgotscreen extends StatefulWidget {
  @override
  _ForgotScreenState createState() => _ForgotScreenState();
}

class _ForgotScreenState extends State<Forgotscreen> {
  final TextEditingController emailController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ForgotCubit(),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(ConstantStrings.appBarTitleForgotPwd),
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
                SizedBox(height: 20),
                BlocSelector<ForgotCubit, ForgotState, String?>(
                  selector: (state) => state.emailError,
                  builder: (context, emailError) {
                    return CustomTextField(
                      label: ConstantStrings.emailLabel,
                      controller: emailController,
                      errorText: emailError,
                      onChanged: (val) =>
                          context.read<ForgotCubit>().emailChanged(val),
                    );
                  },
                ),
                SizedBox(height: 20),

                BlocSelector<ForgotCubit, ForgotState, bool>(
                  selector: (state) => state.isButtonEnabled,
                  builder: (context, isButtonEnabled) {
                    return CustomBottomButton(
                      title: ConstantStrings.sendEmailButton,
                      backgroundColor: const Color.fromRGBO(63, 61, 81, 1.0),
                      textColor: Colors.white,
                      icon: const SizedBox(width: 0),
                      // No icon shown
                      isEnabled: isButtonEnabled,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => OtpScreen(email: '', isComeFromSignup: false)));
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
