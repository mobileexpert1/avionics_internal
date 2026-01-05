import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:avionics_internal/Constants/ConstantStrings.dart';
import 'package:avionics_internal/Constants/ApiClass/baseDetailResponseModel.dart';
import 'package:avionics_internal/bloc/Profile/ContactSupport/contactsupport_model.dart';

import '../../Helper/test_token.dart';

void main() {
  group('PROFILE API REAL SERVER TESTS', () {

    /// ================= CHANGE PASSWORD =================
    test('Change Current Password → API → STATUS CODE CHECK', () async {
      final url = Uri.parse(
        ApiBaseUrlConstant.baseUrl +
            ApiFunctionUrlConstant.userService +
            ApiServiceUrlConstant.changeCurrentPassword,
      );

      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${TestToken.instance.getToken}",
        },
        body: jsonEncode({
          "old_password": "Admin@123",
          "new_password": "Admin@1234",
          "confirm_password": "Admin@1234",
        }),
      );

      print("CHANGE PASSWORD STATUS 👉 ${response.statusCode}");
      print("CHANGE PASSWORD BODY 👉 ${response.body}");

      expect(response.statusCode, isIn([200, 400, 401, 422]));

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        final model = BaseDetailResponseModel.fromJson(json);
        expect(model.detail, isNotNull);
      }
    });

    /// ================= CONTACT SUPPORT =================
    test('Submit Contact Support → API → STATUS CODE CHECK', () async {
      final url = Uri.parse(
        ApiBaseUrlConstant.baseUrl +
            ApiFunctionUrlConstant.userService +
            ApiServiceUrlConstant.contactSupport,
      );

      final contactModel = ContactSupportModel(
        email: "test@yopmail.com",
        description: '',
      );

      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${TestToken.instance.getToken}",
        },
        body: jsonEncode(contactModel.toJson()),
      );
      print("CONTACT SUPPORT STATUS 👉 ${response.statusCode}");
      print("CONTACT SUPPORT BODY 👉 ${response.body}");

      expect(response.statusCode, isIn([200, 201, 400, 401, 422]));

      if (response.statusCode == 200 || response.statusCode == 201) {
        expect(response.body, isNotNull);
      }
    });
  });
}
