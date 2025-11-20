class Validators {
  String? validateEmail(String value) {
    // only lowercase letters allowed
    final emailRegex = RegExp(r'^[a-z0-9._%+-]+@[a-z0-9.-]+\.[a-z]{2,4}$');
    if (value.isEmpty) return 'Email is required';
    if (!emailRegex.hasMatch(value)) return 'Enter a valid email (lowercase only)';
    return null;
  }

  String? validatePassword(String value) {
    if (value.isEmpty) return 'Password is required';
    if (value.length < 8) return 'Password must be at least 8 characters';

    final regex = RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*[\W_]).{8,}$');
    if (!regex.hasMatch(value)) {
      return 'Password must include uppercase, lowercase, a special character, and be at least 8 characters long.';
    }
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


  String? validateName(String value) {
    if (value.isEmpty) return 'This field is required';
    if (!RegExp(r'^[a-zA-Z0-9]+$').hasMatch(value)) return 'Only letters and numbers allowed';
    return null;
  }
}

