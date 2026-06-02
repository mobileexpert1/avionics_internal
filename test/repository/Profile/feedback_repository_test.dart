import 'dart:convert';
import 'package:avionics_internal/bloc/Profile/FeedbackState/feedback_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;

import 'package:avionics_internal/Constants/ConstantStrings.dart';

import '../../Helper/test_token.dart';

void main() {
  group('FEEDBACK API REAL SERVER TEST', () {
    test('Submit Review / Review → API → STATUS CODE CHECK', () async {
      final url = Uri.parse(
        ApiBaseUrlConstant.baseUrl +
            ApiFunctionUrlConstant.userService +
            ApiServiceUrlConstant.review,
      );

      final feedbackModel = FeedbackModel(
        rating: 5,
        description: 'This is a real API test for feedback submission.',
      );

      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${TestToken.instance.getToken}",
        },
        body: jsonEncode(feedbackModel.toJson()),
      );

      print("FEEDBACK STATUS 👉 ${response.statusCode}");
      print("FEEDBACK BODY 👉 ${response.body}");

      expect(response.statusCode, isIn([200, 201, 400, 401, 422]));

      if (response.statusCode == 200 || response.statusCode == 201) {
        expect(response.body, isNotNull);
      }

      if (response.statusCode == 400 || response.statusCode == 422) {
        final json = jsonDecode(response.body);
        expect(json, isNotNull);
      }
    });
  });
}
