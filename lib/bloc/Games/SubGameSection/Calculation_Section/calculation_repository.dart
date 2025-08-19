import '../../../../Constants/ApiClass/api_service.dart';
import '../../../../Constants/ConstantStrings.dart';
import '../../../../Database/generic_methods.dart';
import 'calculation_lock_model.dart';

class CalculationLockRepository {
  Future<CalculationLock?> getCalculationLock() async {
    if (!await GenericMethods.hasInternet()) {
      return null;
    }

    final uri = Uri.parse(
      "${ApiBaseUrlConstant.baseUrl}"
          "${ApiFunctionUrlGamesConstant.calculation}",
    );

    try {
      final jsonData = await ApiService.get(url: uri) as Map<String, dynamic>;

      if (jsonData.containsKey('data')) {
        return CalculationLock.fromJson(jsonData['data']);
      }
      return null;
    } catch (e) {
      throw e.toString();
    }
  }
}
