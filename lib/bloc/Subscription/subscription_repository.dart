import '../../Constants/ConstantStrings.dart';
import '../../Constants/ApiClass/api_service.dart';
import 'package:avionics_internal/bloc/Subscription/subscription_list_model.dart';

class SubscriptionRepository {
  Future<List<SubscriptionItemModel>> fetchSubscriptions() async {
    final url = Uri.parse(
      ApiBaseUrlConstant.baseUrl +
          ApiFunctionUrlConstant.userService +
          ApiServiceUrlConstant.getSubscritionList,
    );

    try {
      final response = await ApiService.get(url: url);
      final dataList = response['data'] as List;

      return dataList
          .map((jsonItem) => SubscriptionItemModel.fromJson(jsonItem))
          .toList();
    } catch (e) {
      throw Exception("Error parsing subscription list: $e");
    }
  }

  Future<SubscriptionItemModel> postSubscriptionApi({
    required String subscription_id,
  }) async {
    final url = Uri.parse(
      ApiBaseUrlConstant.baseUrl +
          ApiFunctionUrlConstant.userService +
          ApiServiceUrlConstant.postSubscrition,
    );

    try {
      final response = await ApiService.post(
        url: url,
        body: {"subscription_id": subscription_id},
      );

      return SubscriptionItemModel.fromJson(response);
    } catch (e) {
      throw e.toString();
    }
  }
}
