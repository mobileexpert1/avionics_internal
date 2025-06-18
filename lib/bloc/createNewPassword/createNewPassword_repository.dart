import 'dart:convert';
import 'dart:ui';
import 'package:avionics_internal/Constants/ConstantStrings.dart';

import '../../Constants/ApiClass/api_service.dart';
import '../../Constants/ApiClass/baseDetailResponseModel.dart';

class CreateNewPasswordRepository {
  Future<BaseDetailResponseModel> resetPasswordApi({
    required String email,
    required String password,
    required String confirmPassword,
    VoidCallback? onUnauthorized,
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

      if (response['statusCode'] == 401 || response['code'] == 401) {
        onUnauthorized?.call();
        throw 'Unauthorized';
      }
      return BaseDetailResponseModel.fromJson(response);
    } catch (e) {

      if (e.toString().contains('401')) {
        onUnauthorized?.call(); // 👈 call callback if 401 found in error
      }
      throw e.toString();
    }
  }
}
