import 'dart:ui';
import 'home_model.dart';
import '../../../Constants/ApiClass/api_service.dart';
import '../../../Constants/ConstantStrings.dart';

class HomeRepository {
  Future<HomeResponse> getHomeData({VoidCallback? onUnauthorized}) async {
    final uri = Uri.parse(
      ApiBaseUrlConstant.baseUrl +
          ApiFunctionUrlAirplaneConstant.airplaneService +
          ApiServiceUrlAirplaneConstant.getExploreData,
    );

    try {
      final response = await ApiService.get(
        url: uri,
      );

      final Map<String, dynamic> jsonData = response;
      return HomeResponse.fromJson(jsonData);
    } catch (e) {
      throw e.toString();
    }
  }
}
