// import 'package:avionics_internal/bloc/SocialLogin/social_user.dart';
// import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
//
//
// class FacebookAuthRepository {
//   final _fb = FacebookAuth.instance;
//
//   Future<SocialUser> signIn() async {
//     await _fb.logOut();
//     final result = await _fb.login(
//       permissions: ['public_profile', 'email'],
//     );
//
//     if (result.status != LoginStatus.success) {
//       throw Exception('cancelled');
//     }
//
//     final userData = await _fb.getUserData();
//     return SocialUser(
//       id: userData['id'],
//       email: userData['email'] ?? '',
//       name: userData['name'] ?? '',
//       idToken: null,
//       accessToken: result.accessToken?.token,
//       provider: 'facebook',
//     );
//   }
// }
