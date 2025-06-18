import 'package:avionics_internal/Constants/ApiClass/baseDetailResponseModel.dart';

import '../../../Constants/ApiClass/api_service.dart';
import '../../../Constants/ConstantStrings.dart';

class DeleteRepository{
  Future<BaseDetailResponseModel> deleteUser(
  ) async {
    final url = Uri.parse(
      ApiBaseUrlConstant.baseUrl +
          ApiFunctionUrlConstant.userService +
          ApiServiceUrlConstant.delete,
    );

    try {
      final response = await ApiService.delete(
        url: url,
      );
      return BaseDetailResponseModel.fromJson(response);
    } catch (e) {
      throw Exception('Failed to delete unit preference: $e');
    }
  }
}