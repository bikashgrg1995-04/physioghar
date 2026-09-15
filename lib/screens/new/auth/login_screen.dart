
import 'package:flutter/material.dart';

import 'package:physioghar/common_widgets/decorative_wave.dart';
import 'package:physioghar/core/constants/app_colors.dart';
import 'package:physioghar/core/constants/app_sizes.dart';
import 'package:physioghar/core/constants/app_strings.dart';
import 'package:physioghar/core/utils/responsive_utils.dart';
import 'package:physioghar/screens/new/auth/auth_controller.dart';
import 'package:physioghar/screens/new/auth/widgets/login_brand.dart';
import 'package:physioghar/screens/new/auth/widgets/login_form.dart';
import 'package:physioghar/screens/new/auth/widgets/login_header.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({
    super.key,
  });

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late final AuthController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AuthController();
  }

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      body: SafeArea(
        child: Stack(
          children: [
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: DecorativeWave(
                variant: DecorativeWaveVariant.layered,
                height: ResponsiveUtils.height(context) * 0.21,
                opacity: 0.45,
              ),
            ),

            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: DecorativeWave(
                variant: DecorativeWaveVariant.bottom,
                height: ResponsiveUtils.height(context) * 0.18,
                opacity: 0.16,
                color: AppColors.pineLight,
              ),
            ),

            SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal:
                    ResponsiveUtils.width(context) * 0.06,
                vertical:
                    ResponsiveUtils.height(context) * 0.025,
              ),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth: 460,
                  ),
                  child: Column(
                    children: [
                      SizedBox(
                        height:
                            ResponsiveUtils.height(context) * 0.025,
                      ),

                      const LoginBrand(),

                      SizedBox(
                        height:
                            ResponsiveUtils.height(context) * 0.02,
                      ),

                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.fromLTRB(
                          ResponsiveUtils.width(context) * 0.06,
                          ResponsiveUtils.height(context) * 0.03,
                          ResponsiveUtils.width(context) * 0.06,
                          ResponsiveUtils.height(context) * 0.028,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(
                            AppSizes.cardRadius + 8,
                          ),
                          border: Border.all(
                            color: AppColors.pinePale,
                          ),
                          boxShadow: const [
                            BoxShadow(
                              color: Color.fromRGBO(
                                30,
                                42,
                                46,
                                0.05,
                              ),
                              blurRadius: 30,
                              offset: Offset(0, 14),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            const LoginHeader(),

                            SizedBox(
                              height:
                                  ResponsiveUtils.height(context) *
                                      0.015,
                            ),

                            LoginForm(
                              controller: _controller,
                            ),
                          ],
                        ),
                      ),

                      SizedBox(
                        height:
                            ResponsiveUtils.height(context) * 0.018,
                      ),

                      Text(
                        AppStrings.secureAccess,
                        textAlign: TextAlign.center,
                        style: Theme.of(context)
                            .textTheme
                            .labelSmall
                            ?.copyWith(
                              color: AppColors.inkMute,
                              letterSpacing: 1.2,
                              fontWeight: FontWeight.w600,
                            ),
                      ),

                      SizedBox(
                        height:
                            ResponsiveUtils.height(context) * 0.12,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}