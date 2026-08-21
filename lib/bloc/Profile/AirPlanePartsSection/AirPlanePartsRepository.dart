import '../../../Constants/ApiClass/api_service.dart';
import '../../../Constants/ConstantStrings.dart';
import 'AirPlanePartsModel.dart';

class AirPlanePartsRepository {
  Future<List<AirPlanePartsModel>> getAirplaneParts() async {
    final uri = Uri.parse(
      "${ApiBaseUrlConstant.baseUrl}"
      "${ApiFunctionUrlGamesConstant.imageBased}"
      "${ApiServiceUrlConstant.airplaneParts}",
    );

    try {
      final jsonData = await ApiService.get(url: uri) as Map<String, dynamic>;

      final data = jsonData['data'] as List? ?? [];

      final aircraftPath = jsonData['aircraft']?.toString() ?? '';

      return data
          .map(
            (e) => AirPlanePartsModel.fromJson(
              e as Map<String, dynamic>,
              aircraftPath: aircraftPath,
            ),
          )
          .toList();
    } catch (e) {
      throw e.toString();
    }
  }
}
