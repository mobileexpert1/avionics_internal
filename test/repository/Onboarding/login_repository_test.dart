import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:avionics_internal/Constants/ConstantStrings.dart';
import 'package:avionics_internal/bloc/Onboarding/login/login_response_model.dart';

void main() {
  group('LOGIN API REAL SERVER TEST', () {
    test('Login → API → STATUS CODE CHECK', () async {
      final url = Uri.parse(
        ApiBaseUrlConstant.baseUrl +
            ApiFunctionUrlConstant.userService +
            ApiServiceUrlConstant.signIn,
      );
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "email": "avi123@yopmail.com",
          "password": "Admin@123",
        }),
      );
      print("STATUS CODE 👉 ${response.statusCode}");
      print("RESPONSE BODY 👉 ${response.body}");
      expect(response.statusCode, isIn([200, 401, 422]));

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        final model = LoginResponseModel.fromJson(json);
        expect(model.userDetails, isNotNull);
        expect(model.userDetails!.email, isNotEmpty);
      }
      if (response.statusCode == 401) {
        final json = jsonDecode(response.body);
        expect(json["message"], isNotEmpty);
      }
    });

    /// ---------------- SOCIAL LOGIN ----------------
    // test('Social Login → API → STATUS CODE CHECK', () async {
    //   final url = Uri.parse(
    //     ApiBaseUrlConstant.baseUrl +
    //         ApiFunctionUrlConstant.userService +
    //         ApiServiceUrlConstant.signInSocial,
    //   );
    //   final response = await http.post(
    //     url,
    //     headers: {
    //       "Content-Type": "application/json",
    //     },
    //     body: jsonEncode({
    //       "provider": "google",
    //       "token": "",
    //     }),
    //   );
    //   print("SOCIAL STATUS 👉 ${response.statusCode}");
    //   print("SOCIAL BODY 👉 ${response.body}");
    //   expect(response.statusCode, isIn([200, 401, 422]));
    //
    //   if (response.statusCode == 200) {
    //     final json = jsonDecode(response.body);
    //     final model = LoginResponseModel.fromJson(json);
    //
    //     expect(model.userDetails, isNotNull);
    //   }
    // });
  });
}

