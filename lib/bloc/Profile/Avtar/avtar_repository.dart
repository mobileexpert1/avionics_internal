import 'package:avionics_internal/Constants/ApiClass/baseDetailResponseModel.dart';
import 'package:flutter/cupertino.dart';
import '../../../Constants/ApiClass/api_service.dart';
import '../../../Constants/ConstantStrings.dart';
import 'avtar_model.dart';

class AvtarRepository {
  Future<BaseDetailResponseModel> setAvtarForProfile({
    required String userType,
    required BuildContext context,
  }) async {
    final url = Uri.parse(
      ApiBaseUrlConstant.baseUrl +
          ApiFunctionUrlConstant.userService +
          ApiServiceUrlConstant.setAvatar,
    );

    try {
      final response = await ApiService.post(
        url: url,
        body: {"user_type": userType},
      );
      return BaseDetailResponseModel.fromJson(response);
    } catch (e) {
      throw e.toString();
    }
  }

  Future<BaseDetailResponseModel> setAvtarForProfileWhileSignup({
    required String userType,
    required String userEmail,
  }) async {
    final url = Uri.parse(
      ApiBaseUrlConstant.baseUrl +
          ApiFunctionUrlConstant.userService +
          ApiServiceUrlConstant.setAvatarWhileSignup,
    );

    try {
      final response = await ApiService.post(
        url: url,
        body: {"email": userEmail, "user_type": userType},
      );
      return BaseDetailResponseModel.fromJson(response);
    } catch (e) {
      throw e.toString();
    }
  }


  Future<AvatarListResponseModel> loadAvatars() async {
    final url = Uri.parse(
      ApiBaseUrlConstant.baseUrl +
          ApiFunctionUrlConstant.userService +
          ApiServiceUrlConstant.fetchAvatars,
    );

    try {
      final response = await ApiService.get(url: url);
      return AvatarListResponseModel.fromJson(response);
    } catch (e) {
      throw e.toString();
    }
  }

}
