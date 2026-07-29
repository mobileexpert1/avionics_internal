import 'dart:ui';

import 'package:avionics_internal/Constants/ApiClass/shared_prefs_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../Constants/ApiClass/api_service.dart';
import '../../../../Constants/ConstantStrings.dart';
import '../../../bloc/Onboarding/login/login_response_model.dart';

class RefreshAccessTokenRepository {
  Future<LoginResponseModel> getAndUpdateTheRefreshToken({
    VoidCallback? onUnauthorized,
  }) async {
    final url = Uri.parse(
      ApiBaseUrlConstant.baseUrl +
          ApiFunctionUrlConstant.userService +
          ApiServiceUrlConstant.authRefreshToken,
    );

    try {
      final prefs = await SharedPreferences.getInstance();
      final refreshToken = prefs.getString('UserRefreshTokenKey');

      final response = await ApiService.post(
        url: url,
        body: {"refresh": refreshToken},
        retry: false,
        onUnauthorized: onUnauthorized,
      );
      final tokenModel = LoginResponseModel.fromJson(response);
      await SharedPrefsHelper.setUserAccessToken(tokenModel.accessToken ?? '');
      await SharedPrefsHelper.setUserRefreshToken(
        tokenModel.refreshToken ?? '',
      );
      return tokenModel;
    } catch (e) {
      onUnauthorized?.call();
      throw e.toString();
    }
  }
}
