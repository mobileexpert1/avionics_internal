import '../../../Constants/ApiClass/api_service.dart';
import '../../../Constants/ConstantStrings.dart';
import '../../Database/db_helper.dart';
import 'home_model.dart';


class HomeRepository {
  Future<HomeResponse> getHomeData() async {
    final uri = Uri.parse(
      ApiBaseUrlConstant.baseUrl +
          ApiFunctionUrlAirplaneConstant.airplaneService +
          ApiServiceUrlAirplaneConstant.getExploreData,
    );

    try {
      final response = await ApiService.get(url: uri);
      final Map<String, dynamic> jsonData = response;

      final homeData = HomeResponse.fromJson(jsonData);


      await DBHelper.insertManufacturers(homeData.manufacturers);
      await DBHelper.insertFavourites(homeData.favourites);

      return homeData;
    } catch (e) {
      print('⚠️ API failed, loading from SQLite: $e');

      final manufacturers = await DBHelper.getManufacturersFromDb();
      final favourites = await DBHelper.getFavouritesFromDb();

      return HomeResponse(
        manufacturers: manufacturers,
        favourites: favourites,
        flights: [],
      );
    }
  }
}

