class ManageAccountModel {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String username;
  final String? phone;
  final String userType;
  final String authType;
  final bool isActive;
  final bool isActiveSubscription;
  final String professionalRole;
  final String experienceLevel;

  // Optional fields still from the original model (can be populated if extended later)
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
    required this.username,
    this.phone,
    required this.userType,
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
  });

  factory ManageAccountModel.fromJson(Map<String, dynamic> json) {
    return ManageAccountModel(
      id: json['id'] ?? '',
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      email: json['email'] ?? '',
      username: json['username'] ?? '',
      phone: json['phone_number'],
      userType: json['user_type'] ?? '',
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
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'username': username,
      'phone_number': phone,
      'user_type': userType,
      'auth_type': authType,
      'is_active': isActive,
      'is_active_subscription': isActiveSubscription,
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
    };
  }
}
