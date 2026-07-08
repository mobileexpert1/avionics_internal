import 'package:avionics_internal/Constants/ConstantStrings.dart';

import '../../../Constants/ApiClass/api_service.dart';
import '../../../Constants/ApiClass/baseDetailResponseModel.dart';

class SignupRepository {
  Future<BaseDetailResponseModel> checkIsEmailAlreadyResgisteredOrNot({
    required String email,
  }) async {
    final url = Uri.parse(
      ApiBaseUrlConstant.baseUrl +
          ApiFunctionUrlConstant.userService +
          ApiServiceUrlConstant.checkEmail,
    );

    try {
      final response = await ApiService.post(
        url: url,
        body: {"email": email},
      );
      return BaseDetailResponseModel.fromJson(response);
    } catch (e) {
      throw e.toString();
    }
  }

  Future<BaseDetailResponseModel> registerUser({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required String phoneNumber,
    required String professionalRole,
    required String experienceLevel,
    required String userType,
    required String authType,
  }) async {
    final url = Uri.parse(
      ApiBaseUrlConstant.baseUrl +
          ApiFunctionUrlConstant.userService +
          ApiServiceUrlConstant.authSignup,
    );

    try {
      final response = await ApiService.post(
        url: url,
        body: {
          "first_name": firstName,
          "last_name": lastName,
          "email": email,
          "password": password,
          "user_type": userType,
          "auth_type": "email",
        },
      );
      return BaseDetailResponseModel.fromJson(response);
    } catch (e) {
      throw e.toString();
    }
  }
}
