import 'package:flutter/material.dart';

import 'package:physioghar/screens/auth/auth_gate.dart';
import 'package:physioghar/screens/auth/login_screen.dart';
import 'package:physioghar/screens/navigation/main_navigation_screen.dart';
import 'package:physioghar/screens/patients/patient_detail_screen.dart';
import 'package:physioghar/screens/profile/widgets/my_reports_screen.dart';
import 'package:physioghar/screens/sessions/session_detail_screen.dart';

class AppRouter {
  AppRouter._();

  static const String authGate = '/';
  static const String login = '/login';
  static const String navigation = '/navigation';

  static const String schedule = '/schedule';
  static const String sessions = '/sessions';
  static const String patients = '/patients';
  static const String profile = '/profile';
  static const String complaints = '/complaints';

  static const String sessionDetail = '/session-detail';
  static const String patientDetail = '/patient-detail';

  static Route<dynamic> onGenerateRoute(
    RouteSettings settings,
  ) {
    switch (settings.name) {
      case authGate:
        return MaterialPageRoute(
          builder: (_) => const AuthGate(),
          settings: settings,
        );

      case login:
        return MaterialPageRoute(
          builder: (_) => const LoginScreen(),
          settings: settings,
        );

      case navigation:
        return MaterialPageRoute(
          builder: (_) => const MainNavigationScreen(),
          settings: settings,
        );

      case sessionDetail:
        final sessionId = settings.arguments as int;

        return MaterialPageRoute(
          builder: (_) => SessionDetailScreen(
            sessionId: sessionId,
          ),
          settings: settings,
        );

      case patientDetail:
        final patientId = settings.arguments as int;

        return MaterialPageRoute(
          builder: (_) => PatientDetailScreen(
            patientId: patientId,
          ),
          settings: settings,
        );

      case complaints:
        return MaterialPageRoute(
          builder: (_) => const MyReportsScreen(),
          settings: settings,
        );

      default:
        return MaterialPageRoute(
          builder: (_) => const AuthGate(),
          settings: settings,
        );
    }
  }
}