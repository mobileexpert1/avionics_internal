class ManageAccountModel {
  final String firstName;
  final String lastName;
  final String email;

  ManageAccountModel({
    required this.firstName,
    required this.lastName,
    required this.email,
  });

  factory ManageAccountModel.fromJson(Map<String, dynamic> json) {
    return ManageAccountModel(
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      email: json['email'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
    };
  }
}
