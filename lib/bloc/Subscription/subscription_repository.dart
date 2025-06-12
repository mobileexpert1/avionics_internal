import 'dart:ffi';

import '../../Constants/ApiClass/baseDetailResponseModel.dart';
import '../../Constants/ConstantStrings.dart';
import '../../Constants/ApiClass/api_service.dart';
import 'package:avionics_internal/bloc/Subscription/subscription_list_model.dart';

class SubscriptionRepository {
  Future<List<SubscriptionItemModel>> fetchSubscriptions() async {
    final url = Uri.parse(
      ApiBaseUrlConstant.baseUrl +
          ApiFunctionUrlConstant.userService +
          ApiServiceUrlConstant.subscrition,
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
    required int duration,
    required bool is_yearly,
    required int price,
    required int trial,
  }) async {
    final url = Uri.parse(
      ApiBaseUrlConstant.baseUrl +
          ApiFunctionUrlConstant.userService +
          ApiServiceUrlConstant.subscrition,
    );

    try {
      final response = await ApiService.post(
        url: url,
        body: {
          "duration": duration,
          "is_yearly": is_yearly,
          "price": price,
          "trial": trial,
        },
      );

      return SubscriptionItemModel.fromJson(response);
    } catch (e) {
      throw e.toString();
    }
  }
}
