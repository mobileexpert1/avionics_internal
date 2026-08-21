import '../../../../Constants/ApiClass/api_service.dart';
import '../../../../Constants/ConstantStrings.dart';
import 'AllMySticker_model.dart';

class AllMyStickerRepository {
  Future<AllMyStickerResponseModel?> getListAllStickerTopic() async {
    final uri = Uri.parse(
      "${ApiBaseUrlConstant.baseUrl}"
      "${ApiFunctionUrlGamesConstant.encyclopaedia}"
      "${ApiFunctionUrlGamesConstant.sticker}",
    );
    try {
      final jsonData = await ApiService.get(url: uri) as Map<String, dynamic>;
      if (jsonData.containsKey('data')) {
        return AllMyStickerResponseModel.fromJson(jsonData);
      }
      return null;
    } catch (e) {
      throw e.toString();
    }
  }
}
