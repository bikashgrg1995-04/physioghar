import 'package:flutter/material.dart';

class ResponsiveUtils {
  ResponsiveUtils._();

  static double width(BuildContext context) {
    return MediaQuery.sizeOf(context).width;
  }

  static double height(BuildContext context) {
    return MediaQuery.sizeOf(context).height;
  }

  static bool isMobile(BuildContext context) {
    return width(context) < 600;
  }

  static bool isTablet(BuildContext context) {
    final screenWidth = width(context);
    return screenWidth >= 600 && screenWidth < 1024;
  }

  static bool isDesktop(BuildContext context) {
    return width(context) >= 1024;
  }
}