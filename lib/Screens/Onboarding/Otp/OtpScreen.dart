import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pinput/pinput.dart';
import '../../../Constants/ConstantStrings.dart';
import '../../../Constants/ApiClass/ApiErrorModel.dart';
import '../../../Constants/constantImages.dart';
import '../../../CustomFiles/CustomAppBar.dart';
import '../../../bloc/Onboarding/otp/otp_cubit.dart';
import '../../../bloc/Onboarding/otp/otp_state.dart';

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
  final TextEditingController _otpController = TextEditingController();
  final defaultPinTheme = PinTheme(
    width: 50,
    height: 55,
    textStyle: const TextStyle(
      fontSize: 30,
      color: Colors.black,
      fontWeight: FontWeight.w600,
    ),
    decoration: BoxDecoration(
      border: Border(bottom: BorderSide(color: Colors.grey.shade400, width: 2)),
    ),
  );
  int _secondsRemaining = 60;
  Timer? _timer;
  bool _isResendEnabled = false;

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  void _startCountdown() {
    setState(() {
      _isResendEnabled = false;
      _secondsRemaining = 60;
    });
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining <= 1) {
        timer.cancel();
        setState(() {
          _isResendEnabled = true;
          _secondsRemaining = 0;
        });
      } else {
        setState(() {
          _secondsRemaining--;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => OtpCubit(),
      child: BlocConsumer<OtpCubit, OtpState>(
        listenWhen: (prev, curr) => prev.status != curr.status,
        listener: (context, state) {
          if (state.status == CommonApiStatus.failure) {
            _otpController.clear();
            context.read<OtpCubit>().otpChanged('');
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
                resizeToAvoidBottomInset: true,
                backgroundColor: Colors.white,
                appBar: CustomAppBar(
                  isClearBackgroundColour: true,
                  title: widget.isComeFromSignup == true
                      ? ConstantStrings.appBarTitleOTPScreen
                      : ConstantStrings.appBarTitleForgotPwd,
                  leftButton: IconButton(
                    icon: SvgPicture.asset(
                      CommonUi.setSvgImage(AssetsPath.backArrowButton),
                      fit: BoxFit.cover,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  centerTitle: true,
                ),
                body: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        const SizedBox(height: 80),
                        SvgPicture.asset(
                          CommonUi.setSvgImage(AssetsPath.logoMain),
                          fit: BoxFit.fill,
                        ),
                        const SizedBox(height: 20),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            ConstantStrings.Otptitle,
                            style: TextStyle(color: Colors.grey.shade600),
                          ),
                        ),
                        const SizedBox(height: 16),
                        BlocBuilder<OtpCubit, OtpState>(
                          buildWhen: (previous, current) =>
                              previous.otp != current.otp,
                          builder: (context, state) {
                            return Pinput(
                              controller: _otpController,
                              autofocus: true,
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
                        const SizedBox(height: 24),
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
                                    ? const Color.fromRGBO(63, 61, 81, 1.0)
                                    : Colors.grey.shade300,
                                foregroundColor: isButtonEnabled
                                    ? Colors.white
                                    : Colors.grey.shade600,
                                minimumSize: const Size.fromHeight(52),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: const Text(
                                ConstantStrings.continueText,
                                style: TextStyle(fontSize: 20),
                              ),
                            );
                          },
                        ),
                        TextButton(
                          onPressed: _isResendEnabled
                              ? () {
                                  _otpController.clear();
                                  context.read<OtpCubit>().otpChanged('');
                                  _startCountdown();
                                  context.read<OtpCubit>().resendOtp(
                                    widget.email,
                                    widget.isComeFromSignup,
                                  );
                                }
                              : null,
                          child: Text(
                            _isResendEnabled
                                ? "Resend Code"
                                : "Resend Code in $_secondsRemaining sec",
                            style: TextStyle(
                              color: _isResendEnabled
                                  ? Colors.blue
                                  : Colors.grey,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        const SizedBox(height: 50),
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
