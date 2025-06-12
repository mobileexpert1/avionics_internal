import 'dart:convert';
import 'package:avionics_internal/Constants/ConstantStrings.dart';

import '../../Constants/ApiClass/api_service.dart';
import '../../Constants/ApiClass/baseDetailResponseModel.dart';

class CreateNewPasswordRepository {
  Future<BaseDetailResponseModel> resetPasswordApi({
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    final url = Uri.parse(
      ApiBaseUrlConstant.baseUrl +
          ApiFunctionUrlConstant.userService +
          ApiServiceUrlConstant.resetPassword,
    );

    try {
      final response = await ApiService.post(
        url: url,
        body: {
          "email": email,
          "new_password": password,
          "confirm_password": confirmPassword,
        },
      );

      return BaseDetailResponseModel.fromJson(response);
    } catch (e) {
      throw e.toString();
    }
  }
}
