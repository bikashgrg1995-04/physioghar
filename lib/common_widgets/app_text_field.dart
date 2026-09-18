
import 'package:flutter/material.dart';

import 'package:physioghar/core/constants/app_colors.dart';
import 'package:physioghar/core/constants/app_sizes.dart';
import 'package:physioghar/core/extensions/context_extensions.dart';

class AppTextField extends StatelessWidget {
  const AppTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.prefixIcon,
    this.label,
    this.obscureText = false,
    this.keyboardType,
    this.textInputAction,
    this.onChanged,
    this.onSubmitted,
    this.validator,
    this.suffixIcon,
    this.enabled = true,
    this.maxLines = 1,
  });

  final TextEditingController controller;
  final String hintText;
  final IconData? prefixIcon;
  final String? label;
  final bool obscureText;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final FormFieldValidator<String>? validator;
  final Widget? suffixIcon;
  final bool enabled;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(
      AppSizes.cardRadius,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Text(
            label!,
            style: context.textTheme.bodyMedium?.copyWith(
              color: AppColors.ink,
            ),
          ),
          const SizedBox(
            height: AppSizes.spacingSm,
          ),
        ],
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          maxLines: maxLines,
          enabled: enabled,
          onChanged: onChanged,
          onFieldSubmitted: onSubmitted,
          validator: validator,
          style: context.textTheme.bodyMedium?.copyWith(
            color: AppColors.ink,
          ),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: context.textTheme.bodyMedium?.copyWith(
              color: AppColors.inkMute,
            ),
            prefixIcon: prefixIcon == null
                ? null
                : Icon(
                    prefixIcon,
                    color: AppColors.pineLight,
                    size: 20,
                  ),
            suffixIcon: suffixIcon,
            filled: true,
            fillColor: AppColors.mist,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: AppSizes.spacingLg,
              vertical: AppSizes.spacingLg,
            ),
            border: OutlineInputBorder(
              borderRadius: radius,
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: radius,
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: radius,
              borderSide: const BorderSide(
                color: AppColors.pineLight,
                width: 1.2,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: radius,
              borderSide: const BorderSide(
                color: AppColors.danger,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: radius,
              borderSide: const BorderSide(
                color: AppColors.danger,
                width: 1.2,
              ),
            ),
          ),
        ),
      ],
    );
  }
}