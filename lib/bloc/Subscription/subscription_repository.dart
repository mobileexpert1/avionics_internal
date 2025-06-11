import 'dart:convert';
import 'package:avionics_internal/bloc/Subscription/subscription_model.dart';
import '../../Constants/ConstantStrings.dart';
import '../../Constants/ApiClass/api_service.dart';

class SubscriptionRepository {
  Future<List<SubscriptionPlanModel>> fetchSubscriptions() async {
    final url = Uri.parse(
      ApiBaseUrlConstant.baseUrl +
          ApiFunctionUrlConstant.userService +
          ApiServiceUrlConstant.subscription,
    );
     print(url);
    try {
      final response = await ApiService.get(url: url);
      final body = jsonDecode(response.body);
      final List data = body['data'];

      return data
          .map((item) => SubscriptionPlanModel.fromJson(item))
          .toList();
    } catch (e) {
      throw Exception("Failed to fetch subscription plans: $e");
    }
  }
}
