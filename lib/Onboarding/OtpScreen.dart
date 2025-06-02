import 'package:avionics_internal/Constants/AppColors.dart';
import 'package:avionics_internal/Constants/OnboardingTexts.dart';
import 'package:avionics_internal/Onboarding/CreateNewPasswordScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pinput/pinput.dart';
import '../Constants/constantImages.dart';
import '../bloc/otp/otp_cubit.dart';
import '../bloc/otp/otp_state.dart';


class OtpScreen extends StatefulWidget {
  @override
  _OtpScreenState createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final defaultPinTheme = PinTheme(
    width: 50,
    height: 55,
    textStyle: TextStyle(fontSize: 30, color: Colors.black, fontWeight: FontWeight.w600,),
    decoration: BoxDecoration(
      border: Border(
        bottom: BorderSide(color: Colors.grey.shade400, width: 2),
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => OtpCubit(),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: BackButton(color: Colors.black),
          centerTitle: true,
          title: Text(
            OnboardingTexts.appBarTitleForgotPwd,
            style: TextStyle(color: AppColors.fogotPwd),
          ),
          backgroundColor: Colors.white,
          elevation: 0,
          shape: Border(bottom: BorderSide(color: Colors.grey, width: 1)),
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
                  OnboardingTexts.Otptitle,
                  style: TextStyle(color: Colors.grey.shade600),
                ),
              ),
              SizedBox(height: 16),

              BlocBuilder<OtpCubit, OtpState>(
                buildWhen: (previous, current) => previous.otp != current.otp,
                builder: (context, state) {
                  return Pinput(
                    length: 4,
                    defaultPinTheme: defaultPinTheme,
                    focusedPinTheme: defaultPinTheme.copyWith(
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(color: Colors.grey.shade400, width: 4),
                        ),
                      ),
                    ),
                    separatorBuilder: (index) => const SizedBox(width: 60),
                    showCursor: true,
                    onChanged: (otp) {
                      context.read<OtpCubit>().otpChanged(otp);
                    },
                  );
                },
              ),

              BlocSelector<OtpCubit, OtpState, String?>(
                selector: (state) => state.otpError,
                builder: (context, otpError) {
                  if (otpError == null) return SizedBox.shrink();
                  return Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      otpError,
                      style: TextStyle(color: Colors.red, fontSize: 14),
                    ),
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
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CreateNewPasswordScreen()),
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
                          borderRadius: BorderRadius.circular(8)),
                    ),
                    child: Text(
                      OnboardingTexts.continuee,
                      style: TextStyle(fontSize: 20),
                    ),
                  );
                },
              ),

              SizedBox(height: 18),

              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  OnboardingTexts.goBack,
                  style: TextStyle(color: AppColors.goBack, fontSize: 18),
                ),
              ),

              Spacer(flex: 2),
            ],
          ),
        ),
      ),
    );
  }
}
