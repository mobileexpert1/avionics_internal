import 'package:avionics_internal/Constants/ApiClass/baseDetailResponseModel.dart';
import '../../../../Constants/ApiClass/api_service.dart';
import '../../../../Constants/ConstantStrings.dart';
import '../subscriptionResponseModel.dart';

class AppleSubscriptionRepository {
  Future<BaseDetailResponseModel> postSubscriptionApi({
    required String token,
    required String selectedSubscriptionId,
    required String platform,
    required String packageName,
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
          "product_id": selectedSubscriptionId,
          "package_name": packageName,
          "token": token,
        },
      );
      return BaseDetailResponseModel.fromJson(response);
    } catch (e) {
      throw e.toString();
    }
  }

  Future<SubscriptionResponseModel> getSubscriptionDetails() async {
    final uri = Uri.parse(
      ApiBaseUrlConstant.baseUrl +
          ApiFunctionUrlConstant.userService +
          ApiServiceUrlConstant.getSubscritionList,
    );
    try {
      final jsonData = await ApiService.get(url: uri) as Map<String, dynamic>;
      return SubscriptionResponseModel.fromJson(jsonData);
    } catch (e) {
      throw e.toString();
    }
  }
}
