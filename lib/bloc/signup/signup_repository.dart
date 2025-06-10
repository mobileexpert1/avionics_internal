import '../../Constants/ConstantStrings.dart';
import '../../CustomFiles/CustomService/PostService.dart';

class SignupRepository {
  Future<String> register({
    required String first_name,
    required String last_name,
    required String email,
    required String username,
    required String password,
    required String phone_number,
    required String professional_role,
    required String experience_level,
    required String user_type,
    required String auth_type,
  }) async {
    final url = ApiBaseUrlConstant.baseUrl +
        ApiFunctionUrlConstant.userService +
        ApiServiceUrlConstant.authSignup;

    final body = {
      "first_name": first_name,
      "last_name": last_name,
      "email": email,
      "username": username,
      "password": password,
      "user_type": user_type,
    };

    final result = await PostService.postRequest(url, body);
    return result.toString();
  }
}
