import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../Constants/ApiClass/ApiErrorModel.dart';
import '../../Constants/ConstantStrings.dart';

class LoginRepository {
  Future<String> loginUser({
    required String email,
    required String password,
  }) async {
    final url = Uri.parse(
      ApiBaseUrlConstant.baseUrl +
          ApiFunctionUrlConstant.userService +
          ApiServiceUrlConstant.signIn,
    );

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({"email": email, "password": password}),
    );

    print('URL: $url');
    print(
      'Request Body: ${jsonEncode({"email": email, "password": password})}',
    );
    print('Response Code: ${response.statusCode}');
    print('Response Body: ${response.body}');

    if (response.statusCode == 200) {
      return response.body;
    } else if (response.statusCode == 201) {
      final body = jsonDecode(response.body);
      return body['detail'] ?? "Login successfully";
    } else if (response.statusCode == 422) {
      final body = jsonDecode(response.body);
      final error = ApiErrorModel.fromJson(body);
      throw error.toString();
    } else if (response.statusCode == 400) {
      final body = jsonDecode(response.body);
      final messages = body.entries.map((e) => '${e.value}').join('\n');
      throw messages;
    } else {
      throw 'Login failed: ${response.statusCode}';
    }
  }
}
