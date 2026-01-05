import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;

import 'package:avionics_internal/Constants/ConstantStrings.dart';
import 'package:avionics_internal/Constants/ApiClass/baseDetailResponseModel.dart';

void main() {
  group('FORGOT PASSWORD API – REAL SERVER TEST', () {

    /// ---------------- FORGOT PASSWORD ----------------
    test('Forgot Password → API → STATUS CODE CHECK', () async {
      final url = Uri.parse(
        ApiBaseUrlConstant.baseUrl +
            ApiFunctionUrlConstant.userService +
            ApiServiceUrlConstant.forgotEmaiiSend,
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
      print("FORGOT STATUS 👉 ${response.statusCode}");
      print("FORGOT BODY 👉 ${response.body}");
      expect(response.statusCode, isIn([200, 400, 404, 422]));

      final json = jsonDecode(response.body);
      final model = BaseDetailResponseModel.fromJson(json);
      expect(model.detail, isNotEmpty);
    });
  });
}
