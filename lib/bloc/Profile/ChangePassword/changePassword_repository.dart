import 'package:avionics_internal/Constants/ApiClass/baseDetailResponseModel.dart';
import '../../../Constants/ApiClass/api_service.dart';
import '../../../Constants/ConstantStrings.dart';

class ChangePasswordRepository {
  Future<BaseDetailResponseModel> changeCurrentPassword({
    required String oldPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    final url = Uri.parse(
      ApiBaseUrlConstant.baseUrl +
          ApiFunctionUrlConstant.userService +
          ApiServiceUrlConstant.changeCurrentPassword,
    );

    try {
      final response = await ApiService.post(
        url: url,
        body: {
          "old_password": oldPassword,
          "new_password": newPassword,
          "confirm_password": confirmPassword,
        },
      );
      return BaseDetailResponseModel.fromJson(response);
    } catch (e) {
      throw e.toString();
    }
  }
}
