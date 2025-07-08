// import 'dart:convert';
// import 'package:shared_preferences/shared_preferences.dart';
//
// import '../../Constants/ApiClass/api_service.dart';
// import '../../Constants/ConstantStrings.dart';          // ApiBaseUrlConstant, ApiFunctionUrlConstant, etc.
// import '../../Database/auth_storage.dart';
// import '../../Database/generic_methods.dart';
// import '../login/login_response_model.dart';           // adjust path if different
//
// class AuthRepository {
//   AuthRepository()
//       : _users = GenericMethods<UserDetails>(UserDetails.fromJson);
//
//   final GenericMethods<UserDetails> _users;
//
//   /// Google / Facebook social‑login check.
//   ///
//   /// * [provider] should be `'google'`, `'facebook'`, etc.
//   /// * Returns a fully‑parsed [LoginResponseModel].
//   Future<LoginResponseModel> socialLoginCheck({
//     required String socialId,
//     required String email,
//     required String roleType,
//     required String provider,
//   }) async {
//     final url = Uri.parse(
//       ApiBaseUrlConstant.baseUrl +
//           ApiFunctionUrlConstant.userService +
//           ApiServiceUrlConstant.socialLoginCheck, // create in your constants
//     );
//
//     try {
//       final rawJson = await ApiService.post(
//         url: url,
//         headers:,
//         body: jsonEncode({
//           'socialId': socialId,
//           'email': email,
//           'roleType': roleType,
//           'provider': provider,
//         }),
//       );
//
//       final response = LoginResponseModel.fromJson(rawJson);
//
//       /* ─── Persist user & tokens ───────────────────────────────────────── */
//       if (response.userDetails != null) {
//         await AuthStorage.save(response.userDetails!.id);
//         await _users.insertAll([response.userDetails!]);
//       }
//
//       final prefs = await SharedPreferences.getInstance();
//       if (response.accessToken != null) {
//         await prefs.setString('UserAccessTokenKey', response.accessToken!);
//       }
//       if (response.refreshToken != null) {
//         await prefs.setString('UserRefreshTokenKey', response.refreshToken!);
//       }
//
//       return response;
//     } catch (e) {
//       throw Exception('Social login failed: $e');
//     }
//   }
// }
