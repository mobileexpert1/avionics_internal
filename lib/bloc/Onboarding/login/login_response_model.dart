import '../../../Database/db_helper.dart';

class LoginResponseModel {
  final String detail;
  final bool? isVerified;
  final bool? isAvatar;
  final String? accessToken;
  final String? refreshToken;
  final String? tokenType;
  final UserDetails? userDetails;

  LoginResponseModel({
    required this.detail,
    this.isVerified,
    this.isAvatar,
    this.accessToken,
    this.refreshToken,
    this.tokenType,
    this.userDetails,
  });

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(
      detail: json['detail'] ?? '',
      isVerified: json['is_verified'],
      isAvatar: json['is_avatar'],
      accessToken: json['access'],
      refreshToken: json['refresh'],
      tokenType: json['token_type'],
      userDetails: json['user_details'] != null
          ? UserDetails.fromJson(json['user_details'])
          : null,
    );
  }
}

class UserDetails extends BaseModel {
  @override
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String? phoneNumber;
  final String professionalRole;
  final String experienceLevel;
  final String userType;
  final String userTypeUrl;
  final String authType;
  final bool isActive;
  final bool isActiveSubscription;

  UserDetails({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    this.phoneNumber,
    required this.professionalRole,
    required this.experienceLevel,
    required this.userType,
    required this.userTypeUrl,
    required this.authType,
    required this.isActive,
    required this.isActiveSubscription,
  });

  factory UserDetails.fromJson(Map<String, dynamic> json) => UserDetails(
    id: json['id'],
    firstName: json['first_name'],
    lastName: json['last_name'],
    email: json['email'],
    phoneNumber: json['phone_number'],
    professionalRole: json['professional_role'] ?? '',
    experienceLevel: json['experience_level'] ?? '',
    userType: json['user_type'] ?? '',
    userTypeUrl: json['user_type_url'] ?? '',
    authType: json['auth_type'] ?? '',
    isActive: json['is_active'] ?? false,
    isActiveSubscription: json['is_active_subscription'] ?? false,
  );

  @override
  Map<String, dynamic> toMap() => {
    'id': id,
    'first_name': firstName,
    'last_name': lastName,
    'email': email,
    'phone_number': phoneNumber,
    'professional_role': professionalRole,
    'experience_level': experienceLevel,
    'user_type': userType,
    'user_type_url': userTypeUrl,
    'auth_type': authType,
    'is_active': isActive ? 1 : 0,
    'is_active_subscription': isActiveSubscription ? 1 : 0,
  };

  factory UserDetails.fromMap(Map<String, dynamic> map) =>
      UserDetails.fromJson(map);

  @override
  String get table => 'user_details';
}
