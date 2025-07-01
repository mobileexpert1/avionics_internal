import 'package:avionics_internal/Constants/ApiClass/baseDetailResponseModel.dart';
import 'package:avionics_internal/bloc/Profile/ManageAccount/manageAcc_model.dart';
import '../../../Constants/ApiClass/api_service.dart';
import '../../../Constants/ConstantStrings.dart';
import '../../../Database/generic_methods.dart';
import '../../login/login_response_model.dart';

class ManageAccountRepository {

  ManageAccountRepository()
      : _users = GenericMethods<UserDetails>(UserDetails.fromMap);

  final GenericMethods<UserDetails> _users;

  Future<ManageAccountModel> getUserDetail() async {

    if (!await GenericMethods.hasInternet()) {
      return _getLocalData();
    }

    final url = Uri.parse(
      ApiBaseUrlConstant.baseUrl +
          ApiFunctionUrlConstant.userService +
          ApiServiceUrlConstant.getAndSetUserDetail,
    );

    try {
      final response = await ApiService.get(url: url);
      return ManageAccountModel.fromJson(response);
    }
    on HttpStatusException catch (e) {
      if (e.statusCode == 400 || e.statusCode == 404) {
        return _getLocalData();
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


  Future<ManageAccountModel> _getLocalData() async {
    final rows = await _users.getAll('user_details');
    if (rows.isEmpty) {
      throw Exception('No cached profile available.');
    }
    final u = rows.first;
    return ManageAccountModel(
      id: u.id,
      firstName: u.firstName,
      lastName: u.lastName,
      email: u.email,
      phone: u.phoneNumber,
      userType: u.userType,
      authType: u.authType,
      isActive: u.isActive,
      isActiveSubscription: u.isActiveSubscription,
      professionalRole: u.professionalRole,
      experienceLevel: u.experienceLevel,
    );
  }
}
