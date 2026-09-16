
import 'package:flutter/material.dart';

import 'package:physioghar/core/constants/app_colors.dart';
import 'package:physioghar/core/constants/app_sizes.dart';

class PatientSearchField extends StatelessWidget {
  const PatientSearchField({
    super.key,
    required this.controller,
    required this.onChanged,
  });

  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<TextEditingValue>(
      valueListenable: controller,
      builder: (context, value, _) {
        final hasText = value.text.isNotEmpty;

        return TextField(
          controller: controller,
          onChanged: onChanged,
          textInputAction: TextInputAction.search,
          decoration: InputDecoration(
            hintText: 'Search patients...',
            prefixIcon: const Icon(
              Icons.search,
              color: AppColors.inkMid,
            ),
            suffixIcon: hasText
                ? IconButton(
                    tooltip: 'Clear search',
                    constraints: const BoxConstraints(
                      minWidth: AppSizes.minTapTarget,
                      minHeight: AppSizes.minTapTarget,
                    ),
                    onPressed: () {
                      controller.clear();
                      onChanged('');
                    },
                    icon: const Icon(
                      Icons.close,
                      size: 20,
                    ),
                  )
                : null,
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: AppSizes.spacingMd,
              vertical: AppSizes.spacingMd,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(
                AppSizes.cardRadius,
              ),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(
                AppSizes.cardRadius,
              ),
              borderSide: const BorderSide(
                color: AppColors.mist,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(
                AppSizes.cardRadius,
              ),
              borderSide: const BorderSide(
                color: AppColors.pine,
              ),
            ),
          ),
        );
      },
    );
  }
}
