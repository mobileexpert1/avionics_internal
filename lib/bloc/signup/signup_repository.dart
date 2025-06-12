import 'dart:convert';
import 'package:avionics_internal/Constants/ConstantStrings.dart';

import '../../Constants/ApiClass/api_service.dart';
import '../../Constants/ApiClass/baseDetailResponseModel.dart';

class SignupRepository {
  Future<BaseDetailResponseModel> registerUser({
    required String first_name,
    required String last_name,
    required String email,
    required String username,
    required String password,
    required String phone_number,
    required String professional_role,
    required String experience_level,
    required String user_type,
    required String auth_type,
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
          "first_name": first_name,
          "last_name": last_name,
          "email": email,
          "username": username,
          "password": password,
          "user_type": user_type,
        },
      );

      return BaseDetailResponseModel.fromJson(response);
    } catch (e) {
      throw e.toString();
    }
  }
}
