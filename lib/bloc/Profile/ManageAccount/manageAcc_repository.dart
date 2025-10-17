import 'dart:convert';

import 'package:avionics_internal/Constants/ApiClass/baseDetailResponseModel.dart';
import 'package:avionics_internal/bloc/Profile/ManageAccount/manageAcc_model.dart';
import '../../../Constants/ApiClass/api_service.dart';
import '../../../Constants/ConstantStrings.dart';
import '../../../Database/auth_storage.dart';
import '../../../Database/generic_methods.dart';

class ManageAccountRepository {
  ManageAccountRepository()
      : _profiles =
  GenericMethods<ManageAccountModel>(ManageAccountModel.fromMap);

  final GenericMethods<ManageAccountModel> _profiles;

  Future<ManageAccountModel> getUserDetail() async {
    // Not Working in web section
    // if (!await GenericMethods.hasInternet()) {
    //   return _getLocalRow();
    // }

    final url = Uri.parse(
      ApiBaseUrlConstant.baseUrl +
          ApiFunctionUrlConstant.userService +
          ApiServiceUrlConstant.getAndSetUserDetail,
    );

    try {
      final raw = await ApiService.get(url: url);

      final Map<String, dynamic> json =
      raw is String ? jsonDecode(raw) as Map<String, dynamic> : raw;

      final profile = ManageAccountModel.fromJson(json);

      // 2️⃣ Remember UID and cache
      await AuthStorage.save(profile.id);
      await _profiles.insertAll([profile]);

      return profile;
    }
    on HttpStatusException catch (e) {
      if (e.statusCode == 400 || e.statusCode == 404) {
        return _getLocalRow();
      }
      throw e.toString();
    }
    catch (e) {
      throw e.toString();
    }
  }

  Future<BaseDetailResponseModel> updateProfileInformation({
    required String firstName,
    required String lastName,
  }) async {
    final url = Uri.parse(
      ApiBaseUrlConstant.baseUrl +
          ApiFunctionUrlConstant.userService +
          ApiServiceUrlConstant.getAndSetUserDetail,
    );

    try {
      final response = await ApiService.patch(
        url: url,
        body: {"first_name": firstName, "last_name": lastName},
      );
      return BaseDetailResponseModel.fromJson(response);
    } catch (e) {
      throw e.toString();
    }
  }

  Future<ManageAccountModel> _getLocalRow() async {
    final uid = await AuthStorage.read();
    if (uid == null || uid.isEmpty) {
      throw Exception('No logged-in user id stored');
    }

    final profile = await _profiles.getById('user_profile', uid);

    if (profile == null) {
      throw Exception('No cached profile available for user $uid');
    }
    return profile;
  }
}
