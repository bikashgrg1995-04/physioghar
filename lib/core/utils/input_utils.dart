class InputUtils {
  InputUtils._();

  static String trim(String? value) {
    return value?.trim() ?? '';
  }

  static String normalizeWhitespace(String? value) {
    if (value == null) {
      return '';
    }

    return value.trim().replaceAll(RegExp(r'\s+'), ' ');
  }

  static String digitsOnly(String? value) {
    if (value == null) {
      return '';
    }

    return value.replaceAll(RegExp(r'\D'), '');
  }

  static String normalizeEmail(String? value) {
    return normalizeWhitespace(value).toLowerCase();
  }

  static String? nullableTrim(String? value) {
    final trimmed = value?.trim();

    if (trimmed == null || trimmed.isEmpty) {
      return null;
    }

    return trimmed;
  }

  static bool isEmpty(String? value) {
    return value == null || value.trim().isEmpty;
  }

  static bool isNotEmpty(String? value) {
    return !isEmpty(value);
  }
}