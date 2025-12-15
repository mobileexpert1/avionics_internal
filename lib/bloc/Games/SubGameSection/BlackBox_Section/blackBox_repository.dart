import '../../../../Constants/ApiClass/api_service.dart';
import '../../../../Constants/ConstantStrings.dart';
import '../../../../Database/generic_methods.dart';
import 'blackBox_model.dart';
import 'blackBox_question_model.dart';
String questionNo = "";
class BlackboxRepository {
  Future<List<BlackBoxSummaryModel>?> getBlackboxSummary() async {
    // Not Working in Web Section
    // if (!await GenericMethods.hasInternet()) {
    //   return null;
    // }

    final uri = Uri.parse(
      "${ApiBaseUrlConstant.baseUrl}${ApiFunctionUrlGamesConstant.blackBoxSummary}",
    );

    try {
      final jsonData = await ApiService.get(url: uri) as Map<String, dynamic>;
      print('API Response: $jsonData'); // Debug

      // Parse the response as a single BlackBoxSummaryModel
      final model = BlackBoxSummaryModel.fromJson(jsonData);
      questionNo = model.questionNo.toString();
      print('Parsed Model: $model'); // Debug
      print('Parsed Model Data: ${model.data}'); // Debug

      // Return a list containing the single model
      return model.data != null && model.data!.isNotEmpty ? [model] : [];
    } catch (e) {
      print('Error fetching blackbox summary: $e'); // Debug
      throw Exception('Failed to fetch blackbox summary: $e');
    }
  }

  // Future<BlackBoxQuestionModel?> getBlackBoxQuestions(String question_no) async {
  Future<BlackBoxQuestionModel?> getBlackBoxQuestions() async {
    // Not Working in Web Section
    // if (!await GenericMethods.hasInternet()) {
    //   return null;
    // }

    final uri = Uri.parse(
      // "${ApiBaseUrlConstant.baseUrl}${ApiFunctionUrlGamesConstant.blackBoxQuestions}/$question_no",
      "${ApiBaseUrlConstant.baseUrl}${ApiFunctionUrlGamesConstant.blackBoxQuestions}/$questionNo",
    );

    try {
      final jsonData = await ApiService.get(url: uri) as Map<String, dynamic>;
      print('API Response: $jsonData');
      if (jsonData.isEmpty) {
        print('Empty response data');
        return null;
      }
      final model = BlackBoxQuestionModel.fromJson(jsonData);
      print('Parsed Model: $model');
      return model;
    } catch (e) {
      print('Error fetching blackbox questions: $e');
      throw Exception('Failed to fetch blackbox questions: $e');
    }
  }

  Future<BlackBoxSubmitResponse?> submitBlackBoxAnswers(Map<String, dynamic> payload) async {
    // Not Working in Web Section
    // if (!await GenericMethods.hasInternet()) {
    //   return null;
    // }
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
}