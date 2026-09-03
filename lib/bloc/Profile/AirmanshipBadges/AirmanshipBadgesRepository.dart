import '../../../../../Constants/ApiClass/api_service.dart';
import '../../../../../Constants/ConstantStrings.dart';
import 'AirmanshipBadgeModel.dart';

class AirmanshipBadgesRepository {
  Future<AirmanshipBadgeModel?> getAirmanshipBadges() async {
    final uri = Uri.parse(
      "${ApiBaseUrlConstant.baseUrl}"
      "${ApiFunctionUrlConstant.userService}"
      "${ApiServiceUrlConstant.airmanshipBadges}",
    );

    try {
      final jsonData = await ApiService.get(url: uri) as Map<String, dynamic>;

      if (jsonData.containsKey('data')) {
        return AirmanshipBadgeModel.fromJson(jsonData);
      }

      return null;
    } catch (e) {
      throw e.toString();
    }
  }
}
