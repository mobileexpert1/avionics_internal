import 'dart:ui';

import 'package:avionics_internal/Constants/ApiClass/baseDetailResponseModel.dart';

import '../../../../Constants/ApiClass/api_service.dart';
import '../../../../Constants/ConstantStrings.dart';
import '../../../../Helpers/StringCommonMethods.dart';
import 'SubscriptionResponseModel.dart';

class SubscriptionBuyPlanRepository {
  Future<BaseDetailResponseModel> postSubscriptionApi({
    required String token,
    required String selectedSubscriptionId,
    required String platform,
    required String packageName,
  }) async {
    final url = Uri.parse(
      ApiBaseUrlConstant.baseUrl +
          ApiFunctionUrlConstant.userService +
          ApiServiceUrlConstant.verifyPostSubscription,
    );
    try {
      final response = await ApiService.post(
        url: url,
        body: {
          "platform": platform,
          "product_id": selectedSubscriptionId,
          "package_name": packageName,
          "token": token,
          "isComeFrom": token,
        },
      );

      printFullText(token);
      return BaseDetailResponseModel.fromJson(response);
    } catch (e) {
      throw e.toString();
    }
  }

  Future<SubscriptionBuyPlanStateModel> getSubscriptionDetails() async {
    final uri = Uri.parse(
      ApiBaseUrlConstant.baseUrl +
          ApiFunctionUrlConstant.userService +
          ApiServiceUrlConstant.getSubscriptionList,
    );
    try {
      final jsonData = await ApiService.get(url: uri) as Map<String, dynamic>;
      return SubscriptionBuyPlanStateModel.fromJson(jsonData);
    } catch (e) {
      throw e.toString();
    }
  }

  Future<SubscriptionBuyPlanStateModel> getSubscriptionSessionToken(
  ) async {
    final uri = Uri.parse(
      ApiBaseUrlConstant.baseUrl +
          ApiFunctionUrlConstant.userService +
          ApiServiceUrlConstant.getSubscriptionList +
          ApiServiceUrlConstant.checkoutSession,
    );
    try {
      final jsonData = await ApiService.get(url: uri) as Map<String, dynamic>;
      return SubscriptionBuyPlanStateModel.fromJson(jsonData);
    } catch (e) {
      throw e.toString();
    }
  }
}
