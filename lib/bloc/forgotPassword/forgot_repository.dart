import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../Constants/ApiClass/ApiErrorModel.dart';
import '../../Constants/ApiClass/api_service.dart';
import '../../Constants/ConstantStrings.dart';

class ForgotRepository {
  Future<String> forgotUserApi({required String email}) async {
    final url = Uri.parse(
      ApiBaseUrlConstant.baseUrl +
          ApiFunctionUrlConstant.userService +
          ApiServiceUrlConstant.forgot,
    );

    try {
      final response = await ApiService.post(url: url, body: {"email": email});

      print('URL: $url');
      print('Request Body: ${jsonEncode({"email": email})}');
      print('Response Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      return response['detail'] ?? "Login successfully";
    } catch (e) {
      throw e.toString();
    }
  }
}
