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
}