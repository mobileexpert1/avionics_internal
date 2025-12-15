import 'package:avionics_internal/Constants/ConstantStrings.dart';
import '../../../Constants/ApiClass/api_service.dart';
import '../../../Database/auth_storage.dart';
import '../login/login_response_model.dart';

class OtpRepository {
  Future<LoginResponseModel> otpVerifyApi({
    required String email,
    required String otp,
    required String otp_type,
    bool resend = false,
  }) async {
    final url = Uri.parse(
      ApiBaseUrlConstant.baseUrl +
          ApiFunctionUrlConstant.userService +
          (otp_type == 'sign_up'
              ? ApiServiceUrlConstant.verifyOtp
              : ApiServiceUrlConstant.forgotPasswordVerify) +
          (resend ? '?resend=true' : ''),
    );

    try {
      final response = await ApiService.post(
        url: url,
        body: {"email": email, "otp": otp, "otp_type": otp_type},
      );
      final model = LoginResponseModel.fromJson(response);
      if (model.userDetails?.id != null) {
        await AuthStorage.save(model.userDetails!.id);
      }
      return model;
    } catch (e) {
      throw e.toString();
    }
  }
}
