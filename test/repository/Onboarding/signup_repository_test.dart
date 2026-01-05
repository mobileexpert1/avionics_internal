import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;

import 'package:avionics_internal/Constants/ConstantStrings.dart';
import 'package:avionics_internal/Constants/ApiClass/baseDetailResponseModel.dart';

void main() {
  group('SIGNUP API REAL SERVER TEST', () {
    /// ---------------- CHECK EMAIL ----------------
    test('Check Email → API → STATUS CODE CHECK', () async {
      final url = Uri.parse(
        ApiBaseUrlConstant.baseUrl +
            ApiFunctionUrlConstant.userService +
            ApiServiceUrlConstant.checkEmail,
      );

      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "email": "test@yopmail.com",
        }),
      );

      print("CHECK EMAIL STATUS 👉 ${response.statusCode}");
      print("CHECK EMAIL BODY 👉 ${response.body}");

      expect(response.statusCode, isIn([200, 400, 422]));

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        final model = BaseDetailResponseModel.fromJson(json);

        expect(model.detail, isNotNull);
      }
    });

    /// ---------------- REGISTER USER ----------------
    test('Register User → API → STATUS CODE CHECK', () async {
      final url = Uri.parse(
        ApiBaseUrlConstant.baseUrl +
            ApiFunctionUrlConstant.userService +
            ApiServiceUrlConstant.authSignup,
      );

      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "first_name": "Test",
          "last_name": "Email",
          "email": "test${DateTime.now().millisecondsSinceEpoch}@yopmail.com",
          "password": "Admin@123",
          "user_type": "user",
          "auth_type": "email",
        }),
      );

      print("SIGNUP STATUS 👉 ${response.statusCode}");
      print("SIGNUP BODY 👉 ${response.body}");

      expect(response.statusCode, isIn([200, 201, 400, 422]));

      if (response.statusCode == 200 || response.statusCode == 201) {
        final json = jsonDecode(response.body);
        final model = BaseDetailResponseModel.fromJson(json);

        expect(model.detail, isNotNull);
      }
    });
  });
}
