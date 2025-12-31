import 'blackBox_model.dart';
import 'blackBox_question_model.dart';
import '../../../../Constants/ConstantStrings.dart';
import '../../../../Constants/ApiClass/api_service.dart';

class BlackboxRepository {

  Future<List<BlackBoxSummaryModel>?> getBlackboxSummary(int gameNo) async {
    final uri = Uri.parse(
      "${ApiBaseUrlConstant.baseUrl}${ApiFunctionUrlGamesConstant.blackBoxSummary}?game_no=$gameNo",
    );

    try {
      final jsonData = await ApiService.get(url: uri) as Map<String, dynamic>;
      final model = BlackBoxSummaryModel.fromJson(jsonData);
      return model.data != null && model.data!.isNotEmpty ? [model] : [];
    } catch (e) {
      throw e.toString();
    }
  }

  Future<BlackBoxQuestionModel?> getBlackBoxQuestions(String questionNo) async {
    final uri = Uri.parse(
      "${ApiBaseUrlConstant.baseUrl}${ApiFunctionUrlGamesConstant.blackBoxQuestions}/$questionNo",
    );
    try {
      final jsonData = await ApiService.get(url: uri) as Map<String, dynamic>;
      if (jsonData.isEmpty) {
        return null;
      }
      final model = BlackBoxQuestionModel.fromJson(jsonData);
      return model;
    } catch (e) {
      throw e.toString();
    }
  }

  Future<BlackBoxSubmitResponse?> submitBlackBoxAnswers(
    Map<String, dynamic> payload,
  ) async {
    final uri = Uri.parse(
      "${ApiBaseUrlConstant.baseUrl}${ApiFunctionUrlGamesConstant.blackBoxSubmit}",
    );
    try {
      final response = await ApiService.post(url: uri, body: payload);
      return BlackBoxSubmitResponse.fromJson(response);
    } catch (e) {
      throw e.toString();
    }
  }

  Future<BlackBoxTopicResponse?> getBlackBoxTopic() async {
    final uri = Uri.parse(
      "${ApiBaseUrlConstant.baseUrl}"
      "${ApiFunctionUrlGamesConstant.blackBoxTopic}",
    );
    try {
      final jsonData = await ApiService.get(url: uri) as Map<String, dynamic>;
      if (jsonData.containsKey('data')) {
        return BlackBoxTopicResponse.fromJson(jsonData);
      }
      return null;
    } catch (e) {
      throw e.toString();
    }
  }
}