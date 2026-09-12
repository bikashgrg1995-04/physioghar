import 'package:flutter/material.dart';
import 'package:physioghar/screens/navigation/main_navigation_screen.dart';

class AppRouter {
  AppRouter._();

  static const String home = '/';
  static const String schedule = '/schedule';
  static const String sessions = '/sessions';
  static const String patients = '/patients';
  static const String profile = '/profile';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case home:
        return MaterialPageRoute(
          builder: (_) => const MainNavigationScreen(),
        );

      default:
        return MaterialPageRoute(
          builder: (_) => const MainNavigationScreen(),
        );
    }
  }
}