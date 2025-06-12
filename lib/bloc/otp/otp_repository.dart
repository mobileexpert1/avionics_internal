import 'dart:convert';
import 'package:avionics_internal/Constants/ConstantStrings.dart';

import '../../Constants/ApiClass/api_service.dart';
import '../login/login_response_model.dart';

class OtpRepository {
  Future<LoginResponseModel> otpVerifyApi({
    required String email,
    required String otp,
    required String otp_type,
  }) async {
    final url = Uri.parse(
      ApiBaseUrlConstant.baseUrl +
          ApiFunctionUrlConstant.userService +
          (otp_type == 'sign_up'
              ? ApiServiceUrlConstant.verifyOtp
              : ApiServiceUrlConstant.forgotPasswordVerify),
    );

    try {
      final response = await ApiService.post(
        url: url,
        body: {"email": email, "otp": otp, "otp_type": otp_type},
      );
      return LoginResponseModel.fromJson(response);
    } catch (e) {
      throw e.toString();
    }
  }
}
