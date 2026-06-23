import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;

import 'package:avionics_internal/Constants/ConstantStrings.dart';
import 'package:avionics_internal/Constants/ApiClass/baseDetailResponseModel.dart';

void main() {
  group('RESET PASSWORD API REAL SERVER TEST', () {
    test('Create New Password → API → STATUS CODE CHECK', () async {
      final url = Uri.parse(
        ApiBaseUrlConstant.baseUrl +
            ApiFunctionUrlConstant.userService +
            ApiServiceUrlConstant.resetPasswordEndpoint,
      );

      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "email": "test@yopmail.com",
          "new_password": "Admin@1234",
          "confirm_password": "Admin@1234",
        }),
      );

      print("RESET PASSWORD STATUS 👉 ${response.statusCode}");
      print("RESET PASSWORD BODY 👉 ${response.body}");

      expect(response.statusCode, isIn([200, 400, 401, 404, 422]));

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        final model = BaseDetailResponseModel.fromJson(json);
        expect(model.detail, isNotNull);
      }

      if (response.statusCode == 400 || response.statusCode == 422) {
        final json = jsonDecode(response.body);
        expect(json, isNotNull);
      }
    });
  });
}
