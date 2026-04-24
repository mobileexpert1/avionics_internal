import 'package:avionics_internal/Constants/ApiClass/baseDetailResponseModel.dart';
import 'package:flutter/cupertino.dart';
import '../../../../Constants/ApiClass/api_service.dart';
import '../../../../Constants/ConstantStrings.dart';
import '../subscriptionResponseModel.dart';
import 'AppleSubscriptionCubit.dart';

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
          "isComeFrom": token,
        },
      );

      printFullText(token);

      final decoded = decodeJwt(token);

      print("FULL PAYLOAD => $decoded");

      final expiry = decoded['expiresDate'];
      final purchaseDate = decoded['purchaseDate'];

      if (expiry != null) {
        print("Expiry Date => ${formatDate(expiry)}");
      }

      if (purchaseDate != null) {
        print("Purchase Date => ${formatDate(purchaseDate)}");
      }

      print("TransactionId => ${decoded['transactionId']}");
      print("OriginalTransactionId => ${decoded['originalTransactionId']}");
      print("Environment => ${decoded['environment']}");

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

  Future<WebSessionResponseModel> getSubscriptionSessionToken() async {
    final uri = Uri.parse(
      ApiBaseUrlConstant.baseUrl +
          ApiFunctionUrlConstant.userService +
          ApiServiceUrlConstant.getSubscritionList +
          ApiServiceUrlConstant.checkoutSession,
    );
    try {
      final jsonData = await ApiService.get(url: uri) as Map<String, dynamic>;
      return WebSessionResponseModel.fromJson(jsonData);
    } catch (e) {
      throw e.toString();
    }
  }
}

void printFullText(String text) {
  const int chunkSize = 800; // safe limit

  for (int i = 0; i < text.length; i += chunkSize) {
    int end = (i + chunkSize < text.length) ? i + chunkSize : text.length;
    print(text.substring(i, end));
  }
}