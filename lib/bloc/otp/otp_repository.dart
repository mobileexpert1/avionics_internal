import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../Constants/ApiErrorModel.dart';
import '../../Constants/ConstantStrings.dart';

class OtpRepository {
  Future<String> register({
    required String email,
    required String otp,
    required String otp_type,
  }) async {
    final url = Uri.parse(
      ApiBaseUrlConstant.baseUrl +
          ApiFunctionUrlConstant.userService +
          ApiServiceUrlConstant.verifyOtp,
    );

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({"email": email, "otp": otp, "otp_type": otp_type}),

    );

    print('URL: $url');
    print('Request Body: ${jsonEncode({"email": email, "otp": otp, "otp_type": otp_type})}');
    print('Response Code: ${response.statusCode}');
    print('Response Body: ${response.body}');

    if (response.statusCode == 200) {
      return response.body;
    } else if (response.statusCode == 201) {
      final body = jsonDecode(response.body);
      return body['detail'] ?? "otp verified successfully";
    } else if (response.statusCode == 422) {
      final body = jsonDecode(response.body);
      final error = ApiErrorModel.fromJson(body);
      throw error.toString();
    } else if (response.statusCode == 400) {
      final body = jsonDecode(response.body);
      final messages = body.entries.map((e) => '${e.value}').join('\n');
      throw messages;
    } else {
      throw 'Otp verification failed: ${response.statusCode}';
    }
  }
}
