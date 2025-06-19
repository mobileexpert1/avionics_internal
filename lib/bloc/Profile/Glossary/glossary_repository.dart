import '../../../Constants/ApiClass/api_service.dart';
import '../../../Constants/ConstantStrings.dart';
import 'glossary_model.dart';

class GlossaryRepository {
  Future<Map<String, List<GlossaryItem>>> getGlossaryData({String? query}) async {
    final uri = Uri.parse(
      ApiBaseUrlConstant.baseUrl +
          ApiFunctionUrlConstant.userService +
          ApiServiceUrlConstant.getGlossary +
          (query != null && query.isNotEmpty ? '?q=$query' : ''),
    );

    try {
      final response = await ApiService.get(url: uri);

      final Map<String, dynamic> jsonData = response;
      final Map<String, List<GlossaryItem>> glossary = {};

      jsonData.forEach((key, value) {
        glossary[key] = (value as List)
            .map((item) => GlossaryItem.fromJson(item))
            .toList();
      });

      return glossary;
    } catch (e) {
      throw Exception('Failed to fetch glossary data: $e');
    }
  }
}
