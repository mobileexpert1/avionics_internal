class LoginResponseModel {
  final String detail;
  final String accessToken;
  final String refreshToken;
  final String tokenType;
  final UserDetails userDetails;

  LoginResponseModel({
    required this.detail,
    required this.accessToken,
    required this.refreshToken,
    required this.tokenType,
    required this.userDetails,
  });

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(
      detail: json['detail'],
      accessToken: json['access'],
      refreshToken: json['refresh'],
      tokenType: json['token_type'],
      userDetails: UserDetails.fromJson(json['user_details']),
    );
  }
}

class UserDetails {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String username;
  final String? phoneNumber;
  final String professionalRole;
  final String experienceLevel;
  final String userType;
  final String authType;

  UserDetails({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.username,
    this.phoneNumber,
    required this.professionalRole,
    required this.experienceLevel,
    required this.userType,
    required this.authType,
  });

  factory UserDetails.fromJson(Map<String, dynamic> json) {
    return UserDetails(
      id: json['id'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      email: json['email'],
      username: json['username'],
      phoneNumber: json['phone_number'],
      professionalRole: json['professional_role'],
      experienceLevel: json['experience_level'],
      userType: json['user_type'],
      authType: json['auth_type'],
    );
  }
}
