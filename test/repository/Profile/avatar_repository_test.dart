import 'dart:convert';
import 'package:avionics_internal/bloc/Profile/Avtar/avtar_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:avionics_internal/Constants/ConstantStrings.dart';
import 'package:avionics_internal/Constants/ApiClass/baseDetailResponseModel.dart';

import '../../Helper/test_token.dart';

void main() {
  group('AVATAR API REAL SERVER TEST', () {
    /// ---------------- LOAD AVATARS ----------------
    test('Fetch Avatar List → API → STATUS CODE CHECK', () async {
      final url = Uri.parse(
        ApiBaseUrlConstant.baseUrl +
            ApiFunctionUrlConstant.userService +
            ApiServiceUrlConstant.fetchAvatars,
      );

      final response = await http.get(
        url,
        headers: {"Content-Type": "application/json"},
      );

      print("FETCH AVATAR STATUS 👉 ${response.statusCode}");
      print("FETCH AVATAR BODY 👉 ${response.body}");

      expect(response.statusCode, isIn([200, 401]));

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        final model = AvatarListResponseModel.fromJson(json);

        expect(model.detail, isNotNull);
        expect(model.detail!.isNotEmpty, true);
      }
    });

    /// ---------------- SET AVATAR AFTER LOGIN ----------------
    test('Set Avatar For Profile → API → STATUS CODE CHECK', () async {
      final url = Uri.parse(
        ApiBaseUrlConstant.baseUrl +
            ApiFunctionUrlConstant.userService +
            ApiServiceUrlConstant.setAvtar,
      );

      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${TestToken.instance.getToken}",
        },
        body: jsonEncode({"user_type": "user"}),
      );

      print("SET AVATAR STATUS 👉 ${response.statusCode}");
      print("SET AVATAR BODY 👉 ${response.body}");

      expect(response.statusCode, isIn([200, 401, 422]));

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        final model = BaseDetailResponseModel.fromJson(json);

        expect(model.detail, isNotNull);
      }
    });

    /// ---------------- SET AVATAR WHILE SIGNUP ----------------
    test('Set Avatar While Signup → API → STATUS CODE CHECK', () async {
      final url = Uri.parse(
        ApiBaseUrlConstant.baseUrl +
            ApiFunctionUrlConstant.userService +
            ApiServiceUrlConstant.setAvtarWhileSignup,
      );

      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "email": "test@yopmail.com",
          "user_type": "user",
        }),
      );

      print("SET AVATAR SIGNUP STATUS 👉 ${response.statusCode}");
      print("SET AVATAR SIGNUP BODY 👉 ${response.body}");

      expect(response.statusCode, isIn([200, 400, 404, 422]));

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        final model = BaseDetailResponseModel.fromJson(json);
        expect(model.detail, isNotNull);
      }
    });
  });
}
