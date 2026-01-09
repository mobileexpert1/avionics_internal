import 'package:flutter/cupertino.dart';

import '../../../Constants/ApiClass/api_service.dart';
import '../../../Constants/ApiClass/shared_prefs_helper.dart';
import '../../../Constants/ConstantStrings.dart';
import '../../../Database/auth_storage.dart';
import '../../../Database/generic_methods.dart';
import '../../../Helpers/DeviceInfo.dart';
import 'login_response_model.dart';

class LoginRepository {
  LoginRepository()
    : _users = GenericMethods<UserDetails>(UserDetails.fromJson);

  final GenericMethods<UserDetails> _users;

  Future<LoginResponseModel> loginUser({
    required String email,
    required String password,
  }) async {
    final url = Uri.parse(
      ApiBaseUrlConstant.baseUrl +
          ApiFunctionUrlConstant.userService +
          ApiServiceUrlConstant.signIn,
    );

    try {
      String? fcmToken;
      try {
        fcmToken = await SharedPrefsHelper.refreshAndUpdateFCMToken();
      } catch (e) {
        debugPrint("⚠️ FCM ignored during login: $e");
        fcmToken = null;
      }
      // String? fcmToken = await SharedPrefsHelper.refreshAndUpdateFCMToken();
      final deviceDetails = await DeviceInfoHelper.getDeviceDetails();
      final Map<String, dynamic> body = {
        "email": email,
        "password": password,
        "fcm": {"token": fcmToken ?? "", ...deviceDetails},
      };
      final user = await ApiService.post(url: url, body: body);
      final response = LoginResponseModel.fromJson(user);

      if (response.userDetails != null) {
        await AuthStorage.save(response.userDetails!.id);
        await _users.insertAll([response.userDetails!]);
      }
      return response;
    } catch (e) {
      throw e.toString();
    }
  }

  Future<LoginResponseModel> loginUserWithSocialPlatform({
    required String provider,
    required String token,
  }) async {
    final url = Uri.parse(
      ApiBaseUrlConstant.baseUrl +
          ApiFunctionUrlConstant.userService +
          ApiServiceUrlConstant.signInSocial,
    );

    try {
      final user = await ApiService.post(
        url: url,
        body: {"provider": provider, "token": token},
      );
      final response = LoginResponseModel.fromJson(user);

      if (response.userDetails != null) {
        await AuthStorage.save(response.userDetails!.id);
        await _users.insertAll([response.userDetails!]);
      }
      return response;
    } catch (e) {
      throw e.toString();
    }
  }
}
