class AppValidator {
  AppValidator._();

  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }

    final emailRegExp = RegExp(r'^[\w\-.]+@([\w-]+\.)+[\w-]{2,4}$');

    if (!emailRegExp.hasMatch(value)) {
      return 'Invalid email address';
    }
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }

    if (value.length < 6) {
      return 'Password must be at least 6 characters long';
    }

    if (!value.contains(RegExp(r'[A-Z]'))) {
      return 'Password must contain at least one uppercase letter';
    }

    if (!value.contains(RegExp(r'[0-9]'))) {
      return 'Password must contain at least one number';
    }

    if (!value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      return 'Password must contain at least one special character';
    }
    return null;
  }

  static String? validatePhoneNumber(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Phone number is required';
    }

    // Lenient regex for international phone numbers (optional plus, 7-15 digits)
    final phoneRegExp = RegExp(r'^\+?[0-9]{7,15}$');

    if (!phoneRegExp.hasMatch(value.trim())) {
      return 'Invalid phone number format';
    }

    return null;
  }

  static String? validateConfirmPassword(
    String? value,
    String? originalPassword,
  ) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    if (value != originalPassword) {
      return 'Passwords do not match';
    }
    return null;
  }

  static String? validateZipCode(String? value) {
    if (value == null || value.isEmpty) {
      return 'ZIP Code is required';
    }
    final zipRegExp = RegExp(r'^\d{4,6}$');
    if (!zipRegExp.hasMatch(value)) {
      return 'Invalid ZIP Code format';
    }
    return null;
  }

  static String? validateAddress(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Address is required';
    }
    if (value.length < 10) {
      return 'Address must be at least 10 characters';
    }
    return null;
  }

  static String? validateNotEmpty(
    String? value, [
    String fieldName = 'This field',
  ]) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }

    // Allow a-z A-Z 0-9 and space only
    final regex = RegExp(r'^[a-zA-Z0-9 ]+$');

    if (!regex.hasMatch(value)) {
      return '$fieldName can only contain letters, numbers and spaces (no emoji or special characters)';
    }

    return null;
  }

  static String? validateUsername(
    String? value, [
    String fieldName = 'Username',
  ]) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }

    final trimmed = value.trim();

    // minimum 2 characters
    if (trimmed.length < 2) {
      return '$fieldName must be at least 2 characters';
    }

    // allow a-z A-Z 0-9 and space only
    final regex = RegExp(r'^[a-zA-Z0-9 ]+$');

    if (!regex.hasMatch(trimmed)) {
      return '$fieldName can only contain letters, numbers and spaces';
    }

    return null;
  }

  static String? validateNotEmptyWithAll(
    String? value, [
    String fieldName = 'This field',
  ]) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  static String? validateNumberOnly(
    String? value, [
    String fieldName = 'This field',
  ]) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }

    if (!RegExp(r'^\d+$').hasMatch(value)) {
      return '$fieldName must contain only numbers';
    }

    return null;
  }
}
