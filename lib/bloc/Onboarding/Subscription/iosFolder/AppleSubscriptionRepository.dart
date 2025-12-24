import 'package:avionics_internal/Constants/ApiClass/baseDetailResponseModel.dart';
import '../../../../Constants/ApiClass/api_service.dart';
import '../../../../Constants/ConstantStrings.dart';

class AppleSubscriptionRepository {
  Future<BaseDetailResponseModel> postSubscriptionApi({
    required token,
    required selectedSubscritionId,
    required platform,
    required packageName,
  }) async {
    final url = Uri.parse(
      ApiBaseUrlConstant.baseUrl +
          ApiFunctionUrlConstant.userService +
          ApiServiceUrlConstant.verfiyPostSubscrition,
    );
    try {
      final response = await ApiService.post(
        url: url,
        body: {
          "platform": platform,
          "product_id": selectedSubscritionId,
          "package_name": packageName,
          "token": token,
        },
      );
      return BaseDetailResponseModel.fromJson(response);
    } catch (e) {
      throw e.toString();
    }
  }
}

