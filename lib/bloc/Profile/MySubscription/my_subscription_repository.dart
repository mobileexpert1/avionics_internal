import '../../../Constants/ApiClass/api_service.dart';
import '../../../Constants/ConstantStrings.dart';
import 'my_subscription_model.dart';

class MySubscriptionRepository {
  Future<MySubscriptionResponseModel> getAllSubscriptionDetails(
    page,
  ) async {
    final url = Uri.parse(
      "${ApiBaseUrlConstant.baseUrl}"
      "${ApiFunctionUrlConstant.userService}"
      "${ApiServiceUrlConstant.getSubscriptionList}"
      "${ApiServiceUrlConstant.historySubscription}?=$page",
    );

    try {
      final jsonData = await ApiService.get(url: url);

      return MySubscriptionResponseModel.fromJson(jsonData);
    } catch (e) {
      throw e.toString();
    }
  }
}
