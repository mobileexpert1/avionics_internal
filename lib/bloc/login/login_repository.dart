import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../Constants/ApiClass/ApiErrorModel.dart';
import '../../Constants/ApiClass/api_service.dart';
import '../../Constants/ConstantStrings.dart';
import '../../Database/generic_methods.dart';
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
      final user = await ApiService.post(
        url: url,
        body: {"email": email, "password": password},
      );
      final response = LoginResponseModel.fromJson(user);

      if (response.userDetails != null) {
        await _users.insertAll([response.userDetails!]);
      }

      final prefs = await SharedPreferences.getInstance();
      if (response.accessToken != null) {
        await prefs.setString('UserAccessTokenKey', response.accessToken!);
      }
      if (response.refreshToken != null) {
        await prefs.setString('UserRefreshTokenKey', response.refreshToken!);
      }
      return response;
    } catch (e) {
      throw e.toString();
    }
  }
}
