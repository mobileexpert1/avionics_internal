import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../Constants/ApiClass/ApiErrorModel.dart';
import '../../Constants/ApiClass/api_service.dart';
import '../../Constants/ConstantStrings.dart';
import 'login_response_model.dart'; // <- Import the model here

class LoginRepository {
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
      final response = await ApiService.post(
        url: url,
        body: {"email": email, "password": password},
      );

      print('URL: $url');
      print('Request Body: ${jsonEncode({"email": email, "password": password})}');
      print('Response: $response');

      return LoginResponseModel.fromJson(response);
    } catch (e) {
      throw e.toString();
    }
  }
}
