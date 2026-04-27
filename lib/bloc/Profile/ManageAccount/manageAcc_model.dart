import '../../../Database/db_helper.dart';

class ManageAccountModel extends BaseModel {
  @override
  final String id;
  @override
  String? userId;

  final String firstName;
  final String lastName;
  final String email;
  final String? phone;
  final String userType;
  final String userTypeUrl;
  final String authType;
  final bool isActive;
  final bool isActiveSubscription;
  final String professionalRole;
  final String experienceLevel;

  final String countryCode;
  final String profileImage;
  final String gender;
  final String dob;
  final String address;
  final String city;
  final String state;
  final String zipCode;
  final String country;

  ManageAccountModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    this.phone,
    required this.userType,
    required this.userTypeUrl,
    required this.authType,
    required this.isActive,
    required this.isActiveSubscription,
    required this.professionalRole,
    required this.experienceLevel,
    this.countryCode = '',
    this.profileImage = '',
    this.gender = '',
    this.dob = '',
    this.address = '',
    this.city = '',
    this.state = '',
    this.zipCode = '',
    this.country = '',
    this.userId,
  });

  factory ManageAccountModel.fromJson(Map<String, dynamic> json) =>
      ManageAccountModel(
        id: json['id'] ?? '',
        firstName: json['first_name'] ?? '',
        lastName: json['last_name'] ?? '',
        email: json['email'] ?? '',
        phone: json['phone_number'],
        userType: json['user_type'] ?? '',
        userTypeUrl: json['user_type_url'] ?? '',
        authType: json['auth_type'] ?? '',
        isActive: json['is_active'] ?? false,
        isActiveSubscription: json['is_active_subscription'] ?? false,
        professionalRole: json['professional_role'] ?? '',
        experienceLevel: json['experience_level'] ?? '',
        countryCode: json['country_code'] ?? '',
        profileImage: json['profile_image'] ?? '',
        gender: json['gender'] ?? '',
        dob: json['dob'] ?? '',
        address: json['address'] ?? '',
        city: json['city'] ?? '',
        state: json['state'] ?? '',
        zipCode: json['zip_code'] ?? '',
        country: json['country'] ?? '',
        userId: json['user_id'],
      );

  factory ManageAccountModel.fromMap(Map<String, dynamic> m) =>
      ManageAccountModel(
        id: m['id'],
        firstName: m['first_name'],
        lastName: m['last_name'],
        email: m['email'],
        phone: m['phone_number'],
        userType: m['user_type'],
        userTypeUrl: m['user_type_url'],
        authType: m['auth_type'],
        isActive: (m['is_active'] as int) == 1,
        isActiveSubscription: (m['is_active_subscription'] as int) == 1,
        professionalRole: m['professional_role'],
        experienceLevel: m['experience_level'],
        countryCode: m['country_code'],
        profileImage: m['profile_image'],
        gender: m['gender'],
        dob: m['dob'],
        address: m['address'],
        city: m['city'],
        state: m['state'],
        zipCode: m['zip_code'],
        country: m['country'],
        userId: m['user_id'],
      );

  @override
  Map<String, dynamic> toMap() => {
    'id': id,
    'first_name': firstName,
    'last_name': lastName,
    'email': email,
    'phone_number': phone,
    'user_type': userType,
    'user_type_url': userTypeUrl,
    'auth_type': authType,
    'is_active': isActive ? 1 : 0,
    'is_active_subscription': isActiveSubscription ? 1 : 0,
    'professional_role': professionalRole,
    'experience_level': experienceLevel,
    'country_code': countryCode,
    'profile_image': profileImage,
    'gender': gender,
    'dob': dob,
    'address': address,
    'city': city,
    'state': state,
    'zip_code': zipCode,
    'country': country,
    'user_id': userId,
  };

  Map<String, dynamic> toJson() => {
    ...toMap()
      ..update('is_active', (_) => isActive)
      ..update('is_active_subscription', (_) => isActiveSubscription),
  };

  @override
  String get table => 'user_profile';
}
