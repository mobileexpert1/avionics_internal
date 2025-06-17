class ManageAccountModel {
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
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
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.countryCode,
    required this.profileImage,
    required this.gender,
    required this.dob,
    required this.address,
    required this.city,
    required this.state,
    required this.zipCode,
    required this.country,
  });

  factory ManageAccountModel.fromJson(Map<String, dynamic> json) {
    return ManageAccountModel(
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
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
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'phone': phone,
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
