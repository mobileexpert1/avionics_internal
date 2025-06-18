import '../../../Constants/ApiClass/api_service.dart';
import '../../../Constants/ConstantStrings.dart';

class DeleteRepository{
  Future<bool> deleteUser({
    required String token,
  }) async {
    final url = Uri.parse(
      ApiBaseUrlConstant.baseUrl +
          ApiFunctionUrlConstant.userService +
          ApiServiceUrlConstant.delete,
    );

    try {
      final response = await ApiService.delete(
        url: url,
        headers: {"Authorization": "Bearer $token"},
      );
    return response['success'] == true || response['statusCode'] == 200;
    } catch (e) {
      throw Exception('Failed to delete unit preference: $e');
    }
  }
}