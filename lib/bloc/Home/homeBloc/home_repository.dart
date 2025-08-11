import 'dart:convert';
import 'dart:ui';
import 'package:avionics_internal/Database/generic_methods.dart';
import 'package:flutter/foundation.dart';
import '../manufacturer/manufacturer_list_model.dart';
import 'home_model.dart';
import '../../../../Constants/ApiClass/api_service.dart';
import '../../../../Constants/ConstantStrings.dart';

class HomeRepository {
  HomeRepository()
      : _manufacturers = GenericMethods<ManufacturerListModel>(ManufacturerListModel.fromMap),
        _favorites = GenericMethods<Favourite>(Favourite.fromMap);

  final GenericMethods<ManufacturerListModel> _manufacturers;
  final GenericMethods<Favourite> _favorites;

  Future<HomeResponse> getHomeData({VoidCallback? onUnauthorized}) async {
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

      await _manufacturers.insertAll(homeData.manufacturers);
     // await _favorites.insertAll(homeData.favourites);

      return homeData;
    } on HttpStatusException catch (e) {
      if (e.statusCode == 400 || e.statusCode == 404) {
        return _getLocalData();
      }
      throw e.toString();
    } catch (e) {
      throw e.toString();
    }
  }

  Future<HomeResponse> _getLocalData() async {
    final manufacturers = await _manufacturers.getAll('manufacturers');
    //final favourites = await _favorites.getAll('favourites');

    return HomeResponse(
      detail: '',
      isActiveSubscription: false,
      manufacturers: manufacturers,
      favourites: [],
      flights: const [],
    );
  }
}


// import 'dart:convert';
// import 'package:flutter/foundation.dart';
// import 'package:avionics_internal/Database/generic_methods.dart';
// import '../manufacturer/manufacturer_list_model.dart';
// import 'home_model.dart';
// import '../../../Constants/ApiClass/api_service.dart';
// import '../../../Constants/ConstantStrings.dart';
//
// class HomeRepository {
//   HomeRepository()
//       : _manufacturers = GenericMethods<ManufacturerListModel>(ManufacturerListModel.fromMap),
//         _favorites = GenericMethods<Favourite>(Favourite.fromMap);
//
//   final GenericMethods<ManufacturerListModel> _manufacturers;
//   final GenericMethods<Favourite> _favorites;
//
//   Future<HomeResponse> getHomeData({VoidCallback? onUnauthorized}) async {
//     final hasInternet = await GenericMethods.hasInternet();
//     if (kIsWeb) {
//       if (!hasInternet) {
//         return HomeResponse(manufacturers: [], favourites: [], flights: []);
//       }
//       return _getDataFromApi(onUnauthorized: onUnauthorized);
//     }
//     if (hasInternet) {
//       try {
//         final data = await _getDataFromApi(onUnauthorized: onUnauthorized);
//         await _saveToLocalDb(data);
//         return data;
//       } catch (e) {
//         debugPrint("⚠️ API failed, falling back to local DB: $e");
//         return _getLocalData();
//       }
//     } else {
//       return _getLocalData();
//     }
//   }
//
//   Future<HomeResponse> _getDataFromApi({VoidCallback? onUnauthorized}) async {
//     final uri = Uri.parse(
//       ApiBaseUrlConstant.baseUrl +
//           ApiFunctionUrlAirplaneConstant.airplaneService +
//           ApiServiceUrlAirplaneConstant.getExploreData,
//     );
//
//     final response = await ApiService.get(
//       url: uri,
//       onUnauthorized: onUnauthorized,
//     );
//
//     final Map<String, dynamic> json = response is String
//         ? jsonDecode(response) as Map<String, dynamic>
//         : response as Map<String, dynamic>;
//
//     return HomeResponse.fromJson(json);
//   }
//
//   Future<void> _saveToLocalDb(HomeResponse homeData) async {
//     await _manufacturers.insertAll(homeData.manufacturers);
//     await _favorites.insertAll(homeData.favourites);
//   }
//
//   Future<HomeResponse> _getLocalData() async {
//     final manufacturers = await _manufacturers.getAll('manufacturers');
//     final favourites = await _favorites.getAll('favourites');
//
//     return HomeResponse(
//       manufacturers: manufacturers,
//       favourites: favourites,
//       flights: const [],
//     );
//   }
// }
