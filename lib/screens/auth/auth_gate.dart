
import 'package:flutter/material.dart';

import 'package:physioghar/app/router.dart';
import 'package:physioghar/common_widgets/app_snackbar.dart';
import 'package:physioghar/core/constants/app_colors.dart';
import 'package:physioghar/models/auth_result.dart';
import 'package:physioghar/screens/auth/auth_controller.dart';

class AuthGate extends StatefulWidget {
  const AuthGate({
    super.key,
  });

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  late final AuthController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AuthController();

    _checkAuthentication();
  }

  Future<void> _checkAuthentication() async {
    debugPrint(
      '========== STARTUP AUTH CHECK ==========',
    );

    debugPrint(
      'Checking stored authentication...',
    );

    final result = await _controller.checkAuthStatus();

    if (!mounted) {
      return;
    }

    debugPrint(
      'Startup authentication result: ${result.status}',
    );

    switch (result.status) {
      case AuthStatus.authenticated:
        debugPrint(
          'Valid session found. Navigating to main navigation.',
        );

        Navigator.of(context).pushNamedAndRemoveUntil(
          AppRouter.navigation,
          (route) => false,
        );
        break;

      case AuthStatus.unauthenticated:
        debugPrint(
          'No stored session. Navigating to login.',
        );

        Navigator.of(context).pushNamedAndRemoveUntil(
          AppRouter.login,
          (route) => false,
        );
        break;

      case AuthStatus.sessionExpired:
        debugPrint(
          'Session expired. Navigating to login.',
        );

        Navigator.of(context).pushNamedAndRemoveUntil(
          AppRouter.login,
          (route) => false,
        );

        WidgetsBinding.instance.addPostFrameCallback((_) {
          AppSnackBar.showInfo(
            'Session expired. Please login to continue.',
          );
        });
        break;
    }

    debugPrint(
      '========================================',
    );
  }

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.cream,
      body: Center(
        child: CircularProgressIndicator(
          color: AppColors.pine,
        ),
      ),
    );
  }
}