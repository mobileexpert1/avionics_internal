import 'package:avionics_internal/Constants/AppColors.dart';
import 'package:avionics_internal/Constants/ConstantStrings.dart';
import 'package:avionics_internal/Onboarding/ForgotCreateNewPassword/CreateNewPasswordScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pinput/pinput.dart';
import '../../Constants/ApiErrorModel.dart';
import '../../Constants/constantImages.dart';
import '../../bloc/otp/otp_cubit.dart';
import '../../bloc/otp/otp_state.dart';

class OtpScreen extends StatefulWidget {
  final String email;
  final bool isComeFromSignup;

  const OtpScreen({
    super.key,
    required this.email,
    required this.isComeFromSignup,
  });

  @override
  _OtpScreenState createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final defaultPinTheme = PinTheme(
    width: 50,
    height: 55,
    textStyle: TextStyle(
      fontSize: 30,
      color: Colors.black,
      fontWeight: FontWeight.w600,
    ),
    decoration: BoxDecoration(
      border: Border(bottom: BorderSide(color: Colors.grey.shade400, width: 2)),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => OtpCubit(),
      child: BlocConsumer<OtpCubit, OtpState>(
        listenWhen: (prev, curr) => prev.status != curr.status,
        listener: (context, state) {
          if (state.status == CommonApiStatus.failure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage ?? 'Otp verification failed'),
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
                  leading: BackButton(color: Colors.black),
                  centerTitle: true,
                  title: Text(
                    widget.isComeFromSignup == true
                        ? ConstantStrings.appBarTitleOTPScreen
                        : ConstantStrings.appBarTitleForgotPwd,
                    style: TextStyle(color: AppColors.fogotPwd),
                  ),
                  backgroundColor: Colors.white,
                  elevation: 0,
                  shape: Border(
                    bottom: BorderSide(color: Colors.grey, width: 1),
                  ),
                ),
                body: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: 80),
                      SvgPicture.asset(
                        CommonUi.setSvgImage(AssetsPath.logoMain),
                        fit: BoxFit.fill,
                      ),
                      SizedBox(height: 20),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          ConstantStrings.Otptitle,
                          style: TextStyle(color: Colors.grey.shade600),
                        ),
                      ),
                      SizedBox(height: 16),

                      BlocBuilder<OtpCubit, OtpState>(
                        buildWhen: (previous, current) =>
                            previous.otp != current.otp,
                        builder: (context, state) {
                          return Pinput(
                            length: 4,
                            defaultPinTheme: defaultPinTheme,
                            focusedPinTheme: defaultPinTheme.copyWith(
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: Colors.grey.shade400,
                                    width: 4,
                                  ),
                                ),
                              ),
                            ),
                            separatorBuilder: (index) =>
                                const SizedBox(width: 60),
                            showCursor: true,
                            onChanged: (otp) {
                              context.read<OtpCubit>().otpChanged(otp);
                            },
                          );
                        },
                      ),

                      SizedBox(height: 24),
                      BlocSelector<OtpCubit, OtpState, bool>(
                        selector: (state) => state.isButtonEnabled,
                        builder: (context, isButtonEnabled) {
                          return ElevatedButton(
                            onPressed: isButtonEnabled
                                ? () {
                                    context.read<OtpCubit>().submitOtpApi(
                                      context,
                                      widget.email,
                                      widget.isComeFromSignup,
                                    );
                                  }
                                : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: isButtonEnabled
                                  ? Color.fromRGBO(63, 61, 81, 1.0)
                                  : Colors.grey.shade300,
                              foregroundColor: isButtonEnabled
                                  ? Colors.white
                                  : Colors.grey.shade600,
                              minimumSize: Size.fromHeight(52),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Text(
                              ConstantStrings.continueText,
                              style: TextStyle(fontSize: 20),
                            ),
                          );
                        },
                      ),

                      SizedBox(height: 18),
                      if (widget.isComeFromSignup == false)
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text(
                            ConstantStrings.goBack,
                            style: TextStyle(
                              color: AppColors.goBack,
                              fontSize: 18,
                            ),
                          ),
                        ),

                      Spacer(flex: 2),
                    ],
                  ),
                ),
              ),

              // Full-screen loading indicator
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
