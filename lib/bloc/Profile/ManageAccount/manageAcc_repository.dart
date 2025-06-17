import 'package:avionics_internal/Constants/ApiClass/baseDetailResponseModel.dart';
import 'package:avionics_internal/bloc/Profile/ManageAccount/manageAcc_model.dart';
import '../../../Constants/ApiClass/api_service.dart';
import '../../../Constants/ConstantStrings.dart';

class ManageAccountRepository {
  Future<ManageAccountModel> getUserDetail() async {
    final url = Uri.parse(
      ApiBaseUrlConstant.baseUrl +
          ApiFunctionUrlConstant.userService +
          ApiServiceUrlConstant.getAndSetUserDetail,
    );

    try {
      final response = await ApiService.get(url: url);
      return ManageAccountModel.fromJson(response);
    } catch (e) {
      throw e.toString();
    }
  }

  Future<BaseDetailResponseModel> updateProfileInformation({
    required String firstName,
    required String lastName,
  }) async {
    final url = Uri.parse(
      ApiBaseUrlConstant.baseUrl +
          ApiFunctionUrlConstant.userService +
          ApiServiceUrlConstant.getAndSetUserDetail,
    );

    try {
      final response = await ApiService.patch(
        url: url,
        body: {"first_name": firstName, "last_name": lastName},
      );
      return BaseDetailResponseModel.fromJson(response);
    } catch (e) {
      throw e.toString();
    }
  }
}
