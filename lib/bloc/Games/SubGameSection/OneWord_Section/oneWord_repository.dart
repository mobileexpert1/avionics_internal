import 'package:avionics_internal/bloc/Games/SubGameSection/OneWord_Section/oneWord_model.dart';
import '../../../../Constants/ApiClass/api_service.dart';
import '../../../../Constants/ConstantStrings.dart';

class OneWordTopicRepository {
  Future<OneWordTopicModel?> getOneWordTopic() async {
    final uri = Uri.parse(
      "${ApiBaseUrlConstant.baseUrl}"
          "${ApiFunctionUrlGamesConstant.oneWord}",
    );

    try {
      final jsonData = await ApiService.get(url: uri) as Map<String, dynamic>;

      if (jsonData.containsKey('data')) {
        return OneWordTopicModel.fromJson(jsonData);
      }
      return null;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<OneWordTopicModel?> getQuizTopic() async {
    final uri = Uri.parse(
      "${ApiBaseUrlConstant.baseUrl}"
          "${ApiFunctionUrlGamesConstant.quiz}",
    );

    try {
      final jsonData = await ApiService.get(url: uri) as Map<String, dynamic>;

      if (jsonData.containsKey('data')) {
        return OneWordTopicModel.fromJson(jsonData);
      }
      return null;
    } catch (e) {
      throw Exception(e.toString());
    }
  }


  Future<OneWordTopicModel?> getCalculationTopic() async {
    final uri = Uri.parse(
      "${ApiBaseUrlConstant.baseUrl}"
          "${ApiFunctionUrlGamesConstant.calculation}",
    );

    try {
      final jsonData = await ApiService.get(url: uri) as Map<String, dynamic>;

      if (jsonData.containsKey('data')) {
        return OneWordTopicModel.fromJson(jsonData);
      }
      return null;
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
