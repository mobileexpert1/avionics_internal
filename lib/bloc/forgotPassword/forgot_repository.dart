import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../Constants/ApiClass/ApiErrorModel.dart';
import '../../Constants/ApiClass/api_service.dart';
import '../../Constants/ApiClass/baseDetailResponseModel.dart';
import '../../Constants/ConstantStrings.dart';

class ForgotRepository {
  Future<BaseDetailResponseModel> forgotUserApi({required String email}) async {
    final url = Uri.parse(
      ApiBaseUrlConstant.baseUrl +
          ApiFunctionUrlConstant.userService +
          ApiServiceUrlConstant.forgot,
    );

    try {
      final response = await ApiService.post(url: url, body: {"email": email});
      return BaseDetailResponseModel.fromJson(response);
    } catch (e) {
      throw e.toString();
    }
  }
}
