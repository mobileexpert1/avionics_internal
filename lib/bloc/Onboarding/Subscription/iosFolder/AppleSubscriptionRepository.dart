import 'package:avionics_internal/Constants/ApiClass/baseDetailResponseModel.dart';
import '../../../../Constants/ApiClass/api_service.dart';
import '../../../../Constants/ConstantStrings.dart';
import '../subscriptionResponseModel.dart';

class AppleSubscriptionRepository {
  Future<BaseDetailResponseModel> postSubscriptionApi({
    required token,
    required selectedSubscritionId,
    required platform,
    required packageName,
    String? originalTransactionId,
    String? appTransactionId,
    String? type,
    String? currency,
    String? price,
    String? startDate,
    String? expiryDate,
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
          "original_transaction_id": originalTransactionId,
          "app_transaction_id": appTransactionId,
          "type": type,
          "currency": currency,
          "price": price,
          "start_date": startDate,
          "expiry_date": expiryDate,
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
