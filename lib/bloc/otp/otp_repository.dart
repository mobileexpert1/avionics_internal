import 'dart:convert';
import 'package:avionics_internal/Constants/ConstantStrings.dart';

import '../../Constants/ApiClass/api_service.dart';

class OtpRepository {
  Future<String> otpVerifyApi({
    required String email,
    required String otp,
    required String otp_type,
  }) async {
    final url = Uri.parse(
      ApiBaseUrlConstant.baseUrl +
          ApiFunctionUrlConstant.userService +
          ApiServiceUrlConstant.verifyOtp,
    );

    try {
      final response = await ApiService.post(
        url: url,
        body: {"email": email, "otp": otp, "otp_type": otp_type},
      );

      return response['detail'] ?? "OTP verified successfully";
    } catch (e) {
      throw e.toString();
    }
  }
}
