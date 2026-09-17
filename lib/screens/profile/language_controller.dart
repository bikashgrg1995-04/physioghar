
import 'package:flutter/material.dart';

enum AppLanguage {
  english,
  nepali,
}

class LanguageController {
  final selectedLanguage = ValueNotifier<AppLanguage>(
    AppLanguage.english,
  );

  void setLanguage(AppLanguage language) {
    selectedLanguage.value = language;
  }

  void dispose() {
    selectedLanguage.dispose();
  }
}