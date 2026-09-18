class Formatters {
  Formatters._();

  static String capitalize(String? value) {
    if (value == null || value.trim().isEmpty) {
      return '';
    }

    final text = value.trim();

    return text[0].toUpperCase() + text.substring(1);
  }

  static String capitalizeWords(String? value) {
    if (value == null || value.trim().isEmpty) {
      return '';
    }

    return value
        .trim()
        .split(RegExp(r'\s+'))
        .map(capitalize)
        .join(' ');
  }

  static String phone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return '-';
    }

    return value.trim();
  }
}