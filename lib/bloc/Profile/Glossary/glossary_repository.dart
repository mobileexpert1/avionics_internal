import 'dart:convert';
import 'package:sqflite/sqflite.dart';
import '../../../Constants/ApiClass/api_service.dart';
import '../../../Constants/ConstantStrings.dart';
import '../../../Database/generic_methods.dart';
import 'glossary_model.dart';

class GlossaryRepository {
  GlossaryRepository()
    : _glossary = GenericMethods<GlossaryItem>(GlossaryItem.fromJson);

  final GenericMethods<GlossaryItem> _glossary;
  Future<Map<String, List<GlossaryItem>>> getGlossaryData({
    String? query,
  }) async {
    // Not Working in Web Section
    // if (!await GenericMethods.hasInternet()) {
    //   return _getLocalData();
    // }

    final uri = Uri.parse(
      ApiBaseUrlConstant.baseUrl +
          ApiFunctionUrlConstant.userService +
          ApiServiceUrlConstant.getGlossary +
          (query != null && query.isNotEmpty ? '?q=$query' : ''),
    );

    try {
      final raw = await ApiService.get(url: uri);
      final Map<String, dynamic> json = raw is String
          ? jsonDecode(raw) as Map<String, dynamic>
          : raw;

      final List<GlossaryItem> all = [];
      json.forEach((_, list) {
        for (final el in (list as List<dynamic>)) {
          all.add(GlossaryItem.fromJson(el as Map<String, dynamic>));
        }
      });
      await _glossary.insertAll(all, algo: ConflictAlgorithm.replace);

      return json.map(
        (k, v) => MapEntry(
          k,
          (v as List<dynamic>)
              .map((e) => GlossaryItem.fromJson(e as Map<String, dynamic>))
              .toList(),
        ),
      );
    } on HttpStatusException catch (e) {
      if (e.statusCode == 400 || e.statusCode == 404) {
        return _getLocalData();
      }
      throw e.toString();
    } catch (e) {
      throw e.toString();
    }
  }

  Future<Map<String, List<GlossaryItem>>> _getLocalData() async {
    final list = await _glossary.getAll('glossary');
    final Map<String, List<GlossaryItem>> grouped = {};
    for (final item in list) {
      final key = item.title.isNotEmpty
          ? item.title[0].toUpperCase()
          : '#';
      grouped.putIfAbsent(key, () => []).add(item);
    }
    return grouped;
  }
}
