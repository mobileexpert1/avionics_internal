class Validators {
  String? validateEmail(String value) {
    final emailRegex = RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$");
    if (value.isEmpty) return 'Email is required';
    if (!emailRegex.hasMatch(value)) return 'Enter a valid email';
    return null;
  }

  String? validatePassword(String value) {
    if (value.isEmpty) return 'Password is required';
    if (value.length < 6) return 'Password must be at least 6 characters';
    return null;
  }

  String? validateConfirmPassword(String? password, String? confirmPassword) {
    if (confirmPassword == null || confirmPassword.isEmpty) {
      return 'Confirm password is required';
    } else if (confirmPassword != password) {
      return 'Passwords do not match';
    }
    return null;
  }
}
