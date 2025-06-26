import 'dart:convert';
import 'home_model.dart';
import '../../../Constants/ApiClass/api_service.dart';
import '../../../Constants/ConstantStrings.dart';
import '../../Database/db_helper.dart';

class HomeRepository {
  Future<HomeResponse> getHomeData({onUnauthorized}) async {
    final uri = Uri.parse(
      ApiBaseUrlConstant.baseUrl +
          ApiFunctionUrlAirplaneConstant.airplaneService +
          ApiServiceUrlAirplaneConstant.getExploreData,
    );

    try {
      final response = await ApiService.get(
        url: uri,
        onUnauthorized: onUnauthorized,
      );
      final Map<String, dynamic> json = response is String
          ? jsonDecode(response) as Map<String, dynamic>
          : response as Map<String, dynamic>;
      final homeData = HomeResponse.fromJson(json);

      await DBHelper.insertManufacturers(homeData.manufacturers);
      await DBHelper.insertFavourites(homeData.favourites);

      return homeData;
    } catch (e) {
      final manufacturers = await DBHelper.getManufacturersFromDb();
      final favourites = await DBHelper.getFavouritesFromDb();
      if (manufacturers.isNotEmpty || favourites.isNotEmpty) {
        return HomeResponse(
          manufacturers: manufacturers,
          favourites: favourites,
          flights: const [],
        );
      }
      rethrow;
    }
  }
}
