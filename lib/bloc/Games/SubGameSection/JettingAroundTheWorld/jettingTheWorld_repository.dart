import '../../../../Constants/ApiClass/api_service.dart';
import '../../../../Constants/ConstantStrings.dart';
import 'JettingAroundBoardingPasses/jetting_BoardingPasses_model.dart';
import 'jettingTheWorld_model.dart';

class JettingTheWorldRepository {
  Future<JettingTheWorldModel?> getAirports() async {
    final uri = Uri.parse(
      "${ApiBaseUrlConstant.baseUrl}"
      "${ApiFunctionUrlGamesConstant.trivia}"
      "${ApiFunctionUrlMapSectionConstant.airport}",
    );

    try {
      final jsonData = await ApiService.get(url: uri) as Map<String, dynamic>;
      if (jsonData.containsKey('data')) {
        return JettingTheWorldModel.fromJson(jsonData);
      }
      return null;
    } catch (e) {
      throw e.toString();
    }
  }

  Future<JettingBoardingPassModel?> getUnlockedAirports() async {
    final uri = Uri.parse(
      "${ApiBaseUrlConstant.baseUrl}"
      "${ApiFunctionUrlGamesConstant.trivia}"
      "${ApiFunctionUrlMapSectionConstant.boardingPassHistory}",
    );

    try {
      final jsonData = await ApiService.get(url: uri) as Map<String, dynamic>;

      return JettingBoardingPassModel.fromJson(jsonData);
    } catch (e) {
      throw e.toString();
    }
  }
}
