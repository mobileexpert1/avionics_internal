import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:avionics_internal/Constants/ConstantStrings.dart';
import 'package:avionics_internal/bloc/Onboarding/login/login_response_model.dart';

void main() {
  group('OTP VERIFY API – REAL SERVER TEST', () {

    /// ---------------- OTP VERIFY ----------------
    test('OTP Verify →  API → STATUS CODE CHECK', () async {
      final url = Uri.parse(
        ApiBaseUrlConstant.baseUrl +
            ApiFunctionUrlConstant.userService +
            ApiServiceUrlConstant.verifyOtp,
      );
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "email": "test@yopmail.com",
          "otp": "123456",
          "otp_type": "signup",
        }),
      );
      print("OTP STATUS 👉 ${response.statusCode}");
      print("OTP BODY 👉 ${response.body}");
      expect(response.statusCode, isIn([200, 400, 401, 422]));

      final json = jsonDecode(response.body);
      if (response.statusCode == 200) {
        final model = LoginResponseModel.fromJson(json);

        expect(model.userDetails, isNotNull);
        expect(model.userDetails!.id, isNotEmpty);
        expect(model.userDetails!.email, isNotEmpty);

        print("✅ OTP VERIFIED FOR USER ID 👉 ${model.userDetails!.id}");
      }
      if (response.statusCode != 200) {
        expect(json["detail"], isNotNull);
        print("❌ OTP FAILED 👉 ${json["detail"]}");
      }
    });
  });
}
