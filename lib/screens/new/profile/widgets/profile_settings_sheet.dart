
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:physioghar/core/constants/app_colors.dart';
import 'package:physioghar/core/constants/app_sizes.dart';
import 'package:physioghar/screens/new/profile/language_controller.dart';
import 'package:physioghar/screens/new/profile/therapist_controller.dart';

class ProfileSettingsSheet extends StatelessWidget {
  const ProfileSettingsSheet({
    super.key,
    required this.therapistController,
    required this.languageController,
  });

  final TherapistController therapistController;
  final LanguageController languageController;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: therapistController.therapist,
      builder: (context, therapist, _) {
        final isAvailable =
            therapist?.isAvailable ?? false;

        return ValueListenableBuilder<AppLanguage>(
          valueListenable:
              languageController.selectedLanguage,
          builder: (context, language, _) {
            final isEnglish =
                language == AppLanguage.english;

            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSizes.spacingLg,
                  AppSizes.spacingSm,
                  AppSizes.spacingLg,
                  AppSizes.spacingLg,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 42,
                        height: 4,
                        decoration: BoxDecoration(
                          color: AppColors.inkMute.withValues(
                            alpha: 0.35,
                          ),
                          borderRadius:
                              BorderRadius.circular(10),
                        ),
                      ),
                    ),

                    const SizedBox(
                      height: AppSizes.spacingLg,
                    ),

                    Text(
                      isEnglish
                          ? 'Settings'
                          : 'सेटिङ्स',
                      style: GoogleFonts.fraunces(
                        fontSize: AppSizes.fontSizeXl,
                        fontWeight: FontWeight.w600,
                        color: AppColors.ink,
                      ),
                    ),

                    const SizedBox(
                      height: AppSizes.spacingLg,
                    ),

                    _SettingsTile(
                      icon: Icons.circle_outlined,
                      title: isEnglish
                          ? 'Availability'
                          : 'उपलब्धता',
                      subtitle: isAvailable
                          ? isEnglish
                              ? 'You are currently available'
                              : 'तपाईं अहिले उपलब्ध हुनुहुन्छ'
                          : isEnglish
                              ? 'You are currently unavailable'
                              : 'तपाईं अहिले उपलब्ध हुनुहुन्न',
                      iconColor: isAvailable
                          ? AppColors.pine
                          : AppColors.inkMute,
                      iconBackgroundColor: isAvailable
                          ? AppColors.pinePale
                          : AppColors.mist,
                      trailing: Switch(
                        value: isAvailable,
                        activeThumbColor: AppColors.pine,
                        onChanged: (value) {
                          therapistController
                              .updateAvailability(value);
                        },
                      ),
                    ),

                    const SizedBox(
                      height: AppSizes.spacingSm,
                    ),

                    _SettingsTile(
                      icon: Icons.language_outlined,
                      iconColor: AppColors.pine,
                      iconBackgroundColor:
                          AppColors.pinePale,
                      title: isEnglish
                          ? 'Language'
                          : 'भाषा',
                      subtitle: isEnglish
                          ? 'English'
                          : 'नेपाली',
                      trailing: _LanguageToggle(
                        selectedLanguage: language,
                        onChanged: languageController
                            .setLanguage,
                      ),
                    ),

                    const SizedBox(
                      height: AppSizes.spacingLg,
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class _SettingsTile extends StatelessWidget {
  const _SettingsTile({
    required this.icon,
    required this.title,
    required this.iconColor,
    required this.iconBackgroundColor,
    required this.subtitle,
    required this.trailing,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final Widget trailing;
  final Color iconColor;
  final Color iconBackgroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(
        minHeight: AppSizes.minTapTarget,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.spacingMd,
        vertical: AppSizes.spacingSm,
      ),
      decoration: BoxDecoration(
        color: AppColors.mist,
        borderRadius: BorderRadius.circular(
          AppSizes.cardRadius,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: AppSizes.minTapTarget,
            height: AppSizes.minTapTarget,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: iconBackgroundColor,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: 20,
              color: iconColor,
            ),
          ),

          const SizedBox(
            width: AppSizes.spacingMd,
          ),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.inter(
                    fontSize: AppSizes.fontSizeMd,
                    fontWeight: FontWeight.w600,
                    color: AppColors.ink,
                  ),
                ),
                const SizedBox(
                  height: AppSizes.spacingXs,
                ),
                Text(
                  subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.inter(
                    fontSize: AppSizes.fontSizeSm,
                    color: AppColors.inkMid,
                  ),
                ),
              ],
            ),
          ),

          trailing,
        ],
      ),
    );
  }
}

class _LanguageToggle extends StatelessWidget {
  const _LanguageToggle({
    required this.selectedLanguage,
    required this.onChanged,
  });

  final AppLanguage selectedLanguage;
  final ValueChanged<AppLanguage> onChanged;

  @override
  Widget build(BuildContext context) {
    final isEnglish =
        selectedLanguage == AppLanguage.english;

    return Container(
      height: 40,
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: AppColors.mist,
        borderRadius: BorderRadius.circular(
          AppSizes.buttonRadius,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _LanguageOption(
            label: 'ENG',
            isSelected: isEnglish,
            onTap: () {
              onChanged(AppLanguage.english);
            },
          ),
          _LanguageOption(
            label: 'NP',
            isSelected: !isEnglish,
            onTap: () {
              onChanged(AppLanguage.nepali);
            },
          ),
        ],
      ),
    );
  }
}

class _LanguageOption extends StatelessWidget {
  const _LanguageOption({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: isSelected
          ? Colors.white
          : Colors.transparent,
      borderRadius: BorderRadius.circular(
        AppSizes.buttonRadius,
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(
          AppSizes.buttonRadius,
        ),
        child: Container(
          constraints: const BoxConstraints(
            minWidth: 48,
            minHeight: AppSizes.minTapTarget,
          ),
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSizes.spacingSm,
          ),
          child: Text(
            label,
            style: GoogleFonts.inter(
              fontSize: AppSizes.fontSizeXs,
              fontWeight: FontWeight.w700,
              color: isSelected
                  ? AppColors.pine
                  : AppColors.inkMute,
            ),
          ),
        ),
      ),
    );
  }
}