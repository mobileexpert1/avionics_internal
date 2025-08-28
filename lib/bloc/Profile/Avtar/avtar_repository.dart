import 'package:avionics_internal/Constants/ApiClass/baseDetailResponseModel.dart';
import '../../../Constants/ApiClass/api_service.dart';
import '../../../Constants/ConstantStrings.dart';

class AvtarRepository {
  Future<BaseDetailResponseModel> setAvtarForProfile({
    required String userType,
  }) async {
    final url = Uri.parse(
      ApiBaseUrlConstant.baseUrl +
          ApiFunctionUrlConstant.userService +
          ApiServiceUrlConstant.setAvtar,
    );

    try {
      final response = await ApiService.post(
        url: url,
        body: {"user_type": userType},
      );
      return BaseDetailResponseModel.fromJson(response);
    } catch (e) {
      throw e.toString();
    }
  }

  Future<BaseDetailResponseModel> setAvtarForProfileWhileSignup({
    required String userType,
    required String userEmail,
  }) async {
    final url = Uri.parse(
      ApiBaseUrlConstant.baseUrl +
          ApiFunctionUrlConstant.userService +
          ApiServiceUrlConstant.setAvtarWhileSignup,
    );

    try {
      final response = await ApiService.post(
        url: url,
        body: {"email": userEmail, "user_type": userType},
      );
      return BaseDetailResponseModel.fromJson(response);
    } catch (e) {
      throw e.toString();
    }
  }
}
