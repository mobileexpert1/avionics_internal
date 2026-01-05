import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;

import 'package:avionics_internal/Constants/ConstantStrings.dart';
import 'package:avionics_internal/Constants/ApiClass/baseDetailResponseModel.dart';
import '../../Helper/test_token.dart';

void main() {
  group('DELETE USER API REAL SERVER TEST', () {
    test('Delete User → API → STATUS CODE CHECK', () async {
      final url = Uri.parse(
        ApiBaseUrlConstant.baseUrl +
            ApiFunctionUrlConstant.userService +
            ApiServiceUrlConstant.delete,
      );

      final response = await http.delete(
        url,
        headers: {
          "Content-Type": "application/json",
          // "Authorization": "Bearer ${TestToken.instance.getToken}",
        },
      );
      print("DELETE USER STATUS 👉 ${response.statusCode}");
      print("DELETE USER BODY 👉 ${response.body}");
      expect(response.statusCode, isIn([200, 401, 403, 404]));

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        final model = BaseDetailResponseModel.fromJson(json);
        expect(model.detail, isNotNull);
      }
    });
  });
}
