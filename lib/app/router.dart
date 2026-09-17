import 'package:flutter/material.dart';
import 'package:physioghar/screens/navigation/main_navigation_screen.dart';
import 'package:physioghar/screens/auth/auth_gate.dart';
import 'package:physioghar/screens/auth/login_screen.dart';
import 'package:physioghar/screens/patients/patient_detail_screen.dart';
import 'package:physioghar/screens/profile/widgets/my_reports_screen.dart';
import 'package:physioghar/screens/sessions/session_detail_screen.dart';

class AppRouter {
  AppRouter._();

  static const authGate = '/';
  static const String login = '/login';

  static const String navigation = '/navigation';

  static const String schedule = '/schedule';
  static const String sessions = '/sessions';
  static const String patients = '/patients';
  static const String profile = '/profile';
  static const String complaints = '/complaints';

  static const String sessionDetail = '/session-detail';
  static const String patientDetail = '/patient-detail';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case authGate:
        return MaterialPageRoute(builder: (_) => const AuthGate());

      case login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());

      case navigation:
        return MaterialPageRoute(builder: (_) => const MainNavigationScreen());

      case sessionDetail:
        final sessionId = settings.arguments as int;

        return MaterialPageRoute(
          builder: (_) => SessionDetailScreen(
            sessionId: sessionId,
          ),
        );

      case patientDetail:
        final patientId = settings.arguments as int;

        return MaterialPageRoute(
          builder: (_) => PatientDetailScreen(patientId: patientId),
        );

      case complaints:
        return MaterialPageRoute(builder: (_)=>  const MyReportsScreen());

      default:
        return MaterialPageRoute(builder: (_) => const AuthGate());
    }
  }
}
