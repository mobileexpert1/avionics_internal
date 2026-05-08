import '../../../Constants/ApiClass/api_service.dart';
import '../../../Constants/ConstantStrings.dart';
import 'my_subscription_model.dart';

class MySubscriptionRepository {
  Future<MySubscriptionResponseModel> getAllSubscriptionDetails() async {
    final url = Uri.parse(
      "${ApiBaseUrlConstant.baseUrl}"
      "${ApiFunctionUrlConstant.userService}"
      "${ApiServiceUrlConstant.getSubscritionList}"
      "${ApiServiceUrlConstant.historySubscription}",
    );

    try {
      final jsonData = await ApiService.get(url: url);

      return MySubscriptionResponseModel.fromJson(jsonData);
    } catch (e) {
      throw e.toString();
    }
  }
}
