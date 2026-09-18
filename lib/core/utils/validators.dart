class Validators {
  Validators._();

  static String? required(
    String? value, {
    String field = 'This field',
  }) {
    if (value == null || value.trim().isEmpty) {
      return '$field is required.';
    }

    return null;
  }

  static String? email(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null;
    }

    final pattern = RegExp(
      r'^[^@\s]+@[^@\s]+\.[^@\s]+$',
    );

    if (!pattern.hasMatch(value.trim())) {
      return 'Enter a valid email.';
    }

    return null;
  }

  static String? phone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null;
    }

    final digits = value.replaceAll(RegExp(r'\D'), '');

    if (digits.length < 7 || digits.length > 15) {
      return 'Enter a valid phone number.';
    }

    return null;
  }

  static String? minLength(
    String? value,
    int length, {
    String field = 'This field',
  }) {
    if (value == null || value.trim().isEmpty) {
      return '$field is required.';
    }

    if (value.trim().length < length) {
      return '$field must be at least $length characters.';
    }

    return null;
  }

  static String? maxLength(
    String? value,
    int length, {
    String field = 'This field',
  }) {
    if (value != null && value.trim().length > length) {
      return '$field cannot exceed $length characters.';
    }

    return null;
  }
}