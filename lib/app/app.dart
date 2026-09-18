import 'package:flutter/material.dart';
import 'package:physioghar/app/router.dart';
import 'package:physioghar/app/theme.dart';
import 'package:physioghar/common_widgets/app_snackbar.dart';
import 'package:physioghar/core/constants/app_constants.dart';

class PhysioGharApp extends StatelessWidget {
  const PhysioGharApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      scaffoldMessengerKey: AppSnackBar.scaffoldMessengerKey,
      initialRoute: AppRouter.authGate,
      onGenerateRoute: AppRouter.onGenerateRoute,
    );
  }
}
