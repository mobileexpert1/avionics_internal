import '../../../Constants/ApiClass/api_service.dart';
import '../../../Constants/ConstantStrings.dart';
import 'feedback_model.dart';


class FeedbackRepository {
  Future<void> submitReview(FeedbackModel feedback) async {
    final url = Uri.parse(
      ApiBaseUrlConstant.baseUrl +
          ApiFunctionUrlConstant.userService +
          ApiServiceUrlConstant.review,
    );

    try {
      final response = await ApiService.post(
        url: url,
        body: feedback.toJson(),
      );
    } catch (e) {
      throw e.toString();
    }
  }
}
