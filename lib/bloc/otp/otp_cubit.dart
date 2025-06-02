import 'package:flutter_bloc/flutter_bloc.dart';
import 'otp_state.dart';

class OtpCubit extends Cubit<OtpState> {
  OtpCubit() : super(OtpState());

  void otpChanged(String otp) {
    final error = _validateOtp(otp);
    _emitUpdatedState(otp: otp, otpError: error);
  }

  String? _validateOtp(String otp) {
    if (otp.length != 4) return 'Enter 4 digits';
    if (!RegExp(r'^\d+$').hasMatch(otp)) return 'Only numbers allowed';
    return null;
  }

  void _emitUpdatedState({String? otp, String? otpError}) {
    final newOtp = otp ?? state.otp;
    final updatedOtpError = otpError ?? _validateOtp(newOtp);

    final isValid = updatedOtpError == null && newOtp.isNotEmpty;

    emit(
      state.copyWith(
        otp: newOtp,
        otpError: updatedOtpError,
        isButtonEnabled: isValid,
      ),
    );
  }
}
