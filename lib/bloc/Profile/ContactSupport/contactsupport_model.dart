class ContactSupportModel {
  final String email;
  final String description;

  ContactSupportModel({
    required this.email,
    required this.description,
  });

  Map<String, dynamic> toJson() {
    return {
      "email": email,
      "description": description,
    };
  }
}
