import 'package:flutter/material.dart';
import 'package:physioghar/models/session.dart';
import 'package:physioghar/screens/navigation/main_navigation_screen.dart';
import 'package:physioghar/screens/sessions/session_detail_screen.dart';

class AppRouter {
  AppRouter._();

  static const String home = '/';
  static const String schedule = '/schedule';
  static const String sessions = '/sessions';
  static const String patients = '/patients';
  static const String profile = '/profile';

  static const String sessionDetail = '/session-detail';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case home:
        return MaterialPageRoute(builder: (_) => const MainNavigationScreen());

      case sessionDetail:
        final session = settings.arguments as Session;
        return MaterialPageRoute(
          builder: (_) => SessionDetailScreen(session: session),
        );

      default:
        return MaterialPageRoute(builder: (_) => const MainNavigationScreen());
    }
  }
}
