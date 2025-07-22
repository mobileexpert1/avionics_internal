class SocialUser {
  SocialUser({
    required this.id,
    required this.email,
    required this.name,
    required this.idToken,
    required this.accessToken,
    required this.provider,          // 'google' | 'facebook'
  });

  final String id;
  final String email;
  final String name;
  final String? idToken;
  final String? accessToken;
  final String provider;
}
