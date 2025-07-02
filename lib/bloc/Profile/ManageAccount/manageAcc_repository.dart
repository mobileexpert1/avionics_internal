import 'dart:convert';

import 'package:avionics_internal/Constants/ApiClass/baseDetailResponseModel.dart';
import '../../../Constants/ApiClass/api_service.dart';
import '../../../Constants/ConstantStrings.dart';
import '../../../Database/generic_methods.dart';
import '../../login/login_response_model.dart';

class ManageAccountRepository {

  ManageAccountRepository()
      : _users = GenericMethods<UserDetails>(UserDetails.fromMap);

  final GenericMethods<UserDetails> _users;

  Future<UserDetails> getUserDetail() async {

    if (!await GenericMethods.hasInternet()) {
      return _getLocalRow();
    }
    final url = Uri.parse(
      ApiBaseUrlConstant.baseUrl +
          ApiFunctionUrlConstant.userService +
          ApiServiceUrlConstant.getAndSetUserDetail,
    );

    try {
      final raw = await ApiService.get(url: url);
      final json = raw is String
          ? jsonDecode(raw) as Map<String, dynamic>
          : raw as Map<String, dynamic>;

      final user = UserDetails.fromJson(json);
      await _users.insertAll([user]);
      return user;
    } catch (e) {
      throw e.toString();
    }
  }

  Future<Object> updateProfileInformation({
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
    }
    catch (e) {
      throw e.toString();
    }
  }

  Future<UserDetails> _getLocalRow() async {
    final rows = await _users.getAll('user_details');
    if (rows.isEmpty) throw Exception('No cached profile available');
    return rows.first;
  }
}


