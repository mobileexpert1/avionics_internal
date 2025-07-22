import 'package:avionics_internal/bloc/Onboarding/SocialLogin/social_user.dart';
import 'package:google_sign_in/google_sign_in.dart';


class GoogleAuthRepository {
  final _google = GoogleSignIn(scopes: ['email', 'profile']);

  Future<SocialUser> signIn() async {
    await _google.signOut();
    final account = await _google.signIn();
    if (account == null) throw Exception('cancelled');

    final auth = await account.authentication;

    return SocialUser(
      id: account.id,
      email: account.email,
      name: account.displayName ?? '',
      idToken: auth.idToken,
      accessToken: auth.accessToken,
      provider: 'google',
    );
  }
}
