import 'package:flutter/material.dart';

import 'package:physioghar/common_widgets/app_button.dart';
import 'package:physioghar/common_widgets/app_text_field.dart';
import 'package:physioghar/core/constants/app_colors.dart';
import 'package:physioghar/core/constants/app_sizes.dart';
import 'package:physioghar/core/constants/app_strings.dart';
import 'package:physioghar/core/utils/responsive_utils.dart';
import 'package:physioghar/screens/new/auth/auth_controller.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({super.key, required this.controller});

  final AuthController controller;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Listenable.merge([
        controller.isLoading,
        controller.obscurePassword,
      ]),
      builder: (context, _) {
        final isLoading = controller.isLoading.value;
        final obscurePassword = controller.obscurePassword.value;

        return Form(
          key: controller.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppTextField(
                controller: controller.emailController,
                label: AppStrings.email,
                hintText: AppStrings.emailHint,
                prefixIcon: Icons.mail_outline_rounded,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                enabled: !isLoading,
                validator: controller.validateEmail,
              ),

              SizedBox(height: ResponsiveUtils.height(context) * 0.012),

              AppTextField(
                controller: controller.passwordController,
                label: AppStrings.password,
                hintText: AppStrings.passwordHint,
                prefixIcon: Icons.lock_outline_rounded,
                obscureText: obscurePassword,
                textInputAction: TextInputAction.done,
                enabled: !isLoading,
                onSubmitted: (_) {
                  controller.login(context);
                },
                suffixIcon: IconButton(
                  tooltip: obscurePassword ? 'Show password' : 'Hide password',
                  onPressed: isLoading
                      ? null
                      : controller.togglePasswordVisibility,
                  icon: Icon(
                    obscurePassword
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                    color: AppColors.inkMute,
                  ),
                ),
                validator: controller.validatePassword,
              ),

              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: isLoading
                      ? null
                      : () {
                          controller.forgotPassword(context);
                        },
                  style: TextButton.styleFrom(
                    minimumSize: const Size(
                      AppSizes.minTapTarget,
                      AppSizes.minTapTarget,
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: ResponsiveUtils.width(context) * 0.01,
                    ),
                  ),
                  child: Text(
                    AppStrings.forgotPassword,
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: AppColors.pine,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),

              AppButton(
                width: double.infinity,
                text: AppStrings.login,
                icon: isLoading
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppColors.white,
                        ),
                      )
                    : const Icon(Icons.arrow_forward_rounded, size: 19),
                onPressed: isLoading
                    ? null
                    : () {
                        controller.login(context);
                      },
              ),

              SizedBox(height: ResponsiveUtils.height(context) * 0.012),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.verified_user_outlined,
                    size: 15,
                    color: AppColors.pineLight,
                  ),
                  SizedBox(width: ResponsiveUtils.width(context) * 0.01),
                  Flexible(
                    child: Text(
                      AppStrings.accountProtected,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodySmall
                          ?.copyWith(color: AppColors.inkMute),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
