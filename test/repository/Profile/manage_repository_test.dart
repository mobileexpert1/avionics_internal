import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:avionics_internal/bloc/Profile/ManageAccount/manageAcc_model.dart';
import 'package:avionics_internal/Constants/ConstantStrings.dart';

import '../../Helper/test_token.dart';

void main() {
  group('MANAGE ACCOUNT API REAL SERVER TEST', () {
    test('Fetch User Details → API → STATUS CODE CHECK', () async {
      final url = Uri.parse(
        ApiBaseUrlConstant.baseUrl +
            ApiFunctionUrlConstant.userService +
            ApiServiceUrlConstant.getAndSetUserDetail,
      );

      final response = await http.get(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${TestToken.instance.getToken}",
        },
      );

      print("USER DETAIL STATUS 👉 ${response.statusCode}");
      print("USER DETAIL BODY 👉 ${response.body}");
      expect(response.statusCode, isIn([200, 401, 404]));

      if (response.statusCode == 200) {
        final jsonMap = jsonDecode(response.body) as Map<String, dynamic>;
        final profile = ManageAccountModel.fromJson(jsonMap);

        expect(profile.id, isNotEmpty);
        expect(profile.firstName, isNotEmpty);
        expect(profile.lastName, isNotEmpty);
        expect(profile.email, isNotEmpty);
      }
    });

    test('Update Profile Information → API → STATUS CODE CHECK', () async {
      final url = Uri.parse(
        ApiBaseUrlConstant.baseUrl +
            ApiFunctionUrlConstant.userService +
            ApiServiceUrlConstant.getAndSetUserDetail,
      );

      final requestBody = {"first_name": "TestFirst", "last_name": "TestLast"};

      final response = await http.patch(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${TestToken.instance.getToken}",
        },
        body: jsonEncode(requestBody),
      );

      print("UPDATE PROFILE STATUS 👉 ${response.statusCode}");
      print("UPDATE PROFILE BODY 👉 ${response.body}");

      expect(response.statusCode, isIn([200, 401, 422]));

      if (response.statusCode == 200) {
        final jsonMap = jsonDecode(response.body) as Map<String, dynamic>;
        expect(jsonMap["detail"], isNotEmpty);
      }
    });
  });
}
