import 'package:avionics_internal/Constants/ApiClass/baseDetailResponseModel.dart';
import 'package:avionics_internal/bloc/Profile/ManageAccount/manageAcc_model.dart';
import '../../../Constants/ApiClass/api_service.dart';
import '../../../Constants/ConstantStrings.dart';

class RefreshAccesstokenRepository {
  Future<BaseDetailResponseModel> getAndUpdateTheRefreshToken({
    required String refreshToken,
  }) async {
    final url = Uri.parse(
      ApiBaseUrlConstant.baseUrl +
          ApiFunctionUrlConstant.userService +
          ApiServiceUrlConstant.getAndSetUserDetail,
    );

    try {
      final response = await ApiService.put(
        url: url,
        body: {"refreshToken":refreshToken},
      );
      return BaseDetailResponseModel.fromJson(response);
    } catch (e) {
      throw e.toString();
    }
  }
}
