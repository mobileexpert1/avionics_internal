import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../Constants/ApiErrorModel.dart';
import '../../Constants/ConstantStrings.dart';

class SignupRepository {
  Future<String> register({
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

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "first_name": first_name,
        "last_name": last_name,
        "email": email,
        "username": username,
        "password": password,
        "user_type": user_type,
      }),
    );
    // final response = await http.post(
    //   url,
    //   headers: {'Content-Type': 'application/json'},
    //   body: jsonEncode({
    //     "first_name": first_name,
    //     "last_name": last_name,
    //     "email": email,
    //     "username": username,
    //     "password": password,
    //     "phone_number": phone_number,
    //     "professional_role": professional_role,
    //     "experience_level": experience_level,
    //     "user_type": user_type,
    //     "auth_type": auth_type,
    //   }),
    // );

    if (response.statusCode == 200) {
      return response.body;
    } else if (response.statusCode == 201) {
      final body = jsonDecode(response.body);
      return body['detail'] ?? "Signup success";
    } else if (response.statusCode == 422) {
      final body = jsonDecode(response.body);
      final error = ApiErrorModel.fromJson(body);
      throw error.toString();
    } else if (response.statusCode == 400) {
      final body = jsonDecode(response.body);
      final messages = body.entries.map((e) => '${e.value}').join('\n');
      throw messages;
    } else {
      throw 'Signup failed: ${response.statusCode}';
    }
  }
}
