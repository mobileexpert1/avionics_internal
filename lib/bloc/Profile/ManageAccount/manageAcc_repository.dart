import 'package:avionics_internal/bloc/Profile/ManageAccount/manageAcc_model.dart';
import '../../../Constants/ApiClass/api_service.dart';
import '../../../Constants/ConstantStrings.dart';

class ManageAccountRepository {
  Future<ManageAccountModel> getUserDetail({required String token}) async {
    final url = Uri.parse(
      ApiBaseUrlConstant.baseUrl +
          ApiFunctionUrlConstant.userService +
          ApiServiceUrlConstant.getUserDetail,
    );

    try {
      final response = await ApiService.get(
        url: url,
        headers: {"Authorization": "Bearer $token"},
      );

      return ManageAccountModel.fromJson(response);
    } catch (e) {
      throw Exception('Failed to fetch user details: $e');
    }
  }

  Future<void> updateUserDetail({
    required String token,
    required String firstName,
    required String lastName,
  }) async {
    final url = Uri.parse(
      ApiBaseUrlConstant.baseUrl +
          ApiFunctionUrlConstant.userService +
          ApiServiceUrlConstant.updateUserDetail,
    );

    final body = {
      "first_name": firstName,
      "last_name": lastName,
    };

    try {
      final response = await ApiService.patch(
        url: url,
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
        body: body,
      );

      if (!(response['status'] == true || response['success'] == true)) {
        throw Exception(response['message'] ?? 'Failed to update user');
      }
    } catch (e) {
      throw Exception('Failed to update user details: $e');
    }
  }
}