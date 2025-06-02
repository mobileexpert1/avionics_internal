class OtpState {
  final String otp;
  final String? otpError;
  final bool isButtonEnabled;

  OtpState({
    this.otp = '',
    this.otpError,
    this.isButtonEnabled = false,
  });

  OtpState copyWith({
    String? otp,
    String? otpError,
    bool? isButtonEnabled,
  }) {
    return OtpState(
      otp: otp ?? this.otp,
      otpError: otpError,
      isButtonEnabled: isButtonEnabled ?? this.isButtonEnabled,
    );
  }
}
