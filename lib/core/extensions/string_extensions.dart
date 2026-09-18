extension StringExtensions on String {
  String get normalized {
    return trim().replaceAll(RegExp(r'\s+'), ' ');
  }

  String get capitalize {
    final value = trim();

    if (value.isEmpty) {
      return '';
    }

    return value[0].toUpperCase() + value.substring(1);
  }

  String get capitalizeWords {
    final value = trim();

    if (value.isEmpty) {
      return '';
    }

    return value
        .split(RegExp(r'\s+'))
        .map((word) => word.capitalize)
        .join(' ');
  }

  String get initials {
    final value = trim();

    if (value.isEmpty) {
      return '';
    }

    final words = value.split(RegExp(r'\s+'));

    if (words.length == 1) {
      return words.first[0].toUpperCase();
    }

    return '${words.first[0]}${words.last[0]}'.toUpperCase();
  }

  String get digitsOnly {
    return replaceAll(RegExp(r'\D'), '');
  }

  bool get isBlank => trim().isEmpty;

  bool get isNotBlank => trim().isNotEmpty;
}