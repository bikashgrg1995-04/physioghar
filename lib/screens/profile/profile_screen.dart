import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:physioghar/common_widgets/app_confirmation_dialog.dart';
import 'package:physioghar/common_widgets/app_snackbar.dart';
import 'package:physioghar/core/constants/app_sizes.dart';
import 'package:physioghar/providers/therapist_provider.dart';
import 'package:physioghar/screens/profile/widgets/edit_profile_dialog.dart';
import 'package:physioghar/screens/profile/widgets/profile_actions.dart';
import 'package:physioghar/screens/profile/widgets/profile_header.dart';
import 'package:physioghar/screens/profile/widgets/profile_settings_sheet.dart';
import 'package:physioghar/screens/profile/widgets/report_issue_sheet.dart';
import 'package:physioghar/screens/profile/widgets/therapist_details_card.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final therapist = ref.watch(therapistProvider);

    return SafeArea(
      child: SingleChildScrollView(
        // padding: const EdgeInsets.all(AppSizes.spacingXl),
        child: Column(
          children: [
            ProfileHeader(therapist: therapist),
            TherapistDetailsCard(
              therapist: therapist,
              onEdit: () async {
                final updated = await showDialog<bool>(
                  context: context,
                  builder: (_) {
                    return EditProfileDialog(therapist: therapist);
                  },
                );

                if (updated == true && context.mounted) {
                  AppSnackBar.showSuccess(
                    context,
                    'Profile updated successfully',
                  );
                }
              },
            ),
            const SizedBox(height: AppSizes.spacingSm),
            ProfileActions(
              onSettings: () {
                showModalBottomSheet(
                  context: context,
                  backgroundColor: Colors.white,
                  isScrollControlled: true,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(AppSizes.cardRadius),
                    ),
                  ),
                  builder: (_) {
                    return const ProfileSettingsSheet();
                  },
                );
              },
              onReportIssue: () async {
                final submitted = await showModalBottomSheet<bool>(
                  context: context,
                  backgroundColor: Colors.white,
                  isScrollControlled: true,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(AppSizes.cardRadius),
                    ),
                  ),
                  builder: (_) {
                    return const ReportIssueSheet();
                  },
                );

                if (submitted == true && context.mounted) {
                  AppSnackBar.showSuccess(
                    context,
                    'Complaint submitted successfully',
                  );
                }
              },
              onLogout: () async {
                final confirmed = await showConfirmationDialog(
                  context,
                  title: 'Logout',
                  message: 'Are you sure you want to logout?',
                  cancelText: 'Cancel',
                  confirmText: 'Logout',
                  icon: Icons.logout_outlined,
                  isDestructive: true,
                );

                if (confirmed != true || !context.mounted) {
                  return;
                }

                AppSnackBar.showSuccess(context, 'Logged out successfully');
              },
            ),
          ],
        ),
      ),
    );
  }
}
