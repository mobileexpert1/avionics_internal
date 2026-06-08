import 'dart:ui';

import 'package:avionics_internal/Constants/ConstantStrings.dart';

import '../../../Constants/ApiClass/api_service.dart';
import '../../../Constants/ApiClass/shared_prefs_helper.dart';
import '../login/login_response_model.dart';

class OtpRepository {
  Future<LoginResponseModel> otpVerifyApi({
    required String email,
    required String otp,
    required String otpType,
    bool resend = false,
  }) async {
    final url = Uri.parse(
      ApiBaseUrlConstant.baseUrl +
          ApiFunctionUrlConstant.userService +
          (otpType == 'sign_up'
              ? ApiServiceUrlConstant.verifyOtp
              : ApiServiceUrlConstant.forgotPasswordVerify) +
          (resend ? '?resend=true' : ''),
    );

    try {
      final response = await ApiService.post(
        url: url,
        body: {"email": email, "otp": otp, "otp_type": otpType},
      );
      final model = LoginResponseModel.fromJson(response);
      if (model.userDetails?.id != null) {
        await SharedPrefsHelper.save(model.userDetails!.id);
      }
      return model;
    } catch (e) {
      throw e.toString();
    }
  }
}
