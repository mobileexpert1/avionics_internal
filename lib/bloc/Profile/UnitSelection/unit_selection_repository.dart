import 'dart:convert';
import 'package:avionics_internal/bloc/Profile/UnitSelection/unit_selection_model.dart';
import 'package:sqflite/sqflite.dart';
import '../../../Constants/ApiClass/api_service.dart';
import '../../../Constants/ConstantStrings.dart';
import '../../../Database/generic_methods.dart';

class UnitSelectionRepository {
  UnitSelectionRepository()
      : _prefs = GenericMethods<UnitOption>(UnitOption.fromMap);

  final GenericMethods<UnitOption> _prefs;

  Future<UnitSelectionModel> getUnitPreferences({required String token}) async {
    if (!await GenericMethods.hasInternet()) {
      return _getLocalData();
    }

    final url = Uri.parse(
      ApiBaseUrlConstant.baseUrl +
          ApiFunctionUrlConstant.userService +
          ApiServiceUrlConstant.getUnitselection,
    );

    try {
      final response = await ApiService.get(
        url: url,
        headers: {"Authorization": "Bearer $token"},
      );

      final Map<String, dynamic> json = response is String
          ? jsonDecode(response) as Map<String, dynamic>
          : response;

      await _insertPrefs(json);
      return UnitSelectionModel.fromJson(json);
    } on HttpStatusException catch (e) {
      if (e.statusCode == 400 || e.statusCode == 404) {
        return _getLocalData();
      }
      throw e.toString();
    } catch (e) {
      throw e.toString();
    }
  }

  Future<UnitSelectionModel> updateUnitPreferences({
    required String token,
    required String speed,
    required String altitude,
    required String distance,
    required String temperature,
  }) async {
    final body = {
      'speed': speed,
      'altitude': altitude,
      'distance': distance,
      'temperature': temperature,
    };

    final url = Uri.parse(
      ApiBaseUrlConstant.baseUrl +
          ApiFunctionUrlConstant.userService +
          ApiServiceUrlConstant.updateUnitselection,
    );

    try {
      final raw = await ApiService.put(
        url: url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: body,
      );

      final Map<String, dynamic> json = raw is String
          ? jsonDecode(raw) as Map<String, dynamic>
          : raw;

      // await _updatePrefs(json);
      return UnitSelectionModel.fromJson(json);
    } on HttpStatusException catch (e) {
      if (e.statusCode == 400 || e.statusCode == 404) {
        return _getLocalData();
      }
      throw e.toString();
    } catch (e) {
      throw e.toString();
    }
  }

  Future<UnitSelectionModel> _getLocalData() async =>
      UnitSelectionModel.fromPrefs(await _prefs.getAll('unit_prefs'));

  Future<void> _insertPrefs(Map<String, dynamic> json) async {
    final prefs = <UnitOption>[];
    final data = json['preferences'] as Map<String, dynamic>;
    data.forEach((cat, list) {
      for (final item in (list as List<dynamic>)) {
        prefs.add(
          UnitOption.fromJson(
            item as Map<String, dynamic>,
          ).copyWithIdPrefix(cat),
        );
      }
    });
    await _prefs.insertAll(prefs, algo: ConflictAlgorithm.replace);
  }

  Future<void> _updatePrefs(Map<String, String> selected) async {
    final rows = <UnitOption>[];
    selected.forEach((cat, unit) {
      rows.add(UnitOption(unit: unit, isSelected: true).copyWithIdPrefix(cat));
    });
    await _prefs.insertAll(rows, algo: ConflictAlgorithm.replace);
  }
}

extension _UnitOptionExt on UnitOption {
  UnitOption copyWithIdPrefix(String prefix) =>
      UnitOption(unit: unit, isSelected: isSelected)..id = '${prefix}_$unit';
}

