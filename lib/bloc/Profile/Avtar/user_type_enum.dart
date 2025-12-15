enum UserType {
  student,
  professional,
  enthusiast,
  atco,
}

extension UserTypeExtension on UserType {
  static UserType fromIndex(int index) {
    return UserType.values[index];
  }

  static UserType fromString(String value) {
    return UserType.values.firstWhere(
          (e) => e.name == value,
      orElse: () => UserType.student,
    );
  }

  String get value => name; // string like "student"
}
