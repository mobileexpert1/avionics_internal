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

      // final decoded = decodeJwt(token);
      //
      // print("FULL PAYLOAD => $decoded");
      //
      // final expiry = decoded['expiresDate'];
      // final purchaseDate = decoded['purchaseDate'];
      //
      // if (expiry != null) {
      //   print("Expiry (IST 12h) => ${formatDateUniversal(expiry, toIST: true, use12Hour: true)}");
      //   print("Expiry (IST 24h) => ${formatDateUniversal(expiry, toIST: true, use12Hour: false)}");
      //
      //   print("Expiry (UTC 12h) => ${formatDateUniversal(expiry, toIST: false, use12Hour: true)}");
      //   print("Expiry (UTC 24h) => ${formatDateUniversal(expiry, toIST: false, use12Hour: false)}");
      // }
      //
      // if (purchaseDate != null) {
      //   print("Purchase (IST 12h) => ${formatDateUniversal(purchaseDate, toIST: true, use12Hour: true)}");
      //   print("Purchase (IST 24h) => ${formatDateUniversal(purchaseDate, toIST: true, use12Hour: false)}");
      //
      //   print("Purchase (UTC 12h) => ${formatDateUniversal(purchaseDate, toIST: false, use12Hour: true)}");
      //   print("Purchase (UTC 24h) => ${formatDateUniversal(purchaseDate, toIST: false, use12Hour: false)}");
     // }

      // int? expiry1 = decoded['expiresDate'] is int
      //     ? decoded['expiresDate']
      //     : int.tryParse(decoded['expiresDate'].toString());
      //
      // int? purchaseDate1 = decoded['purchaseDate'] is int
      //     ? decoded['purchaseDate']
      //     : int.tryParse(decoded['purchaseDate'].toString());

      // if (expiry1 != null) {
      //   final expiryDate1 = DateTime
      //       .fromMillisecondsSinceEpoch(expiry1, isUtc: true)
      //       .toLocal(); // ✅ IST
      //
      //   print("IST Expiry Date => $expiryDate1");
      // }
      //
      // if (purchaseDate1 != null) {
      //   final purchase1 = DateTime
      //       .fromMillisecondsSinceEpoch(purchaseDate1, isUtc: true)
      //       .toLocal(); // ✅ IST
      //
      //   print("IST Purchase Date => $purchase1");
      // }

      // print("TransactionId => ${decoded['transactionId']}");
      // print("OriginalTransactionId => ${decoded['originalTransactionId']}");
      // print("Environment => ${decoded['environment']}");

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