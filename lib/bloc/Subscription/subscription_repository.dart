import '../../Constants/ConstantStrings.dart';
import '../../Constants/ApiClass/api_service.dart';
import 'package:avionics_internal/bloc/Subscription/subscription_list_model.dart';

import '../../Database/auth_storage.dart';

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
      throw e.toString();
    }
  }

  Future<SubscriptionItemModel> postSubscriptionApi({
    required subscription_id,
  }) async {
    final userId = await AuthStorage.read();
    if (userId == null) throw 'User not logged in.';
    final url = Uri.parse(
      ApiBaseUrlConstant.baseUrl +
          ApiFunctionUrlConstant.userService +
          ApiServiceUrlConstant.postSubscrition,
    );

    try {
      final response = await ApiService.post(
        url: url,
        body: {"subscription_id": subscription_id,"current_user_id": userId},
      );

      return SubscriptionItemModel.fromJson(response);
    } catch (e) {
      throw e.toString();
    }
  }
}
