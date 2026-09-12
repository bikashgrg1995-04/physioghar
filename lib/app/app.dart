import 'package:flutter/material.dart';
import 'package:physioghar/app/router.dart';
import 'package:physioghar/app/theme.dart';

class PhysioGharApp extends StatelessWidget {
  const PhysioGharApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PhysioGhar',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialRoute: AppRouter.home,
      onGenerateRoute: AppRouter.onGenerateRoute,
    );
  }
}