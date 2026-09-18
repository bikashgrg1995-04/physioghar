import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import 'package:physioghar/app/router.dart';
import 'package:physioghar/common_widgets/app_loading.dart';
import 'package:physioghar/common_widgets/app_snackbar.dart';
import 'package:physioghar/core/constants/app_sizes.dart';
import 'package:physioghar/core/extensions/context_extensions.dart';
import 'package:physioghar/data/providers/auth_provider.dart';
import 'package:physioghar/data/providers/therapist_provider.dart';
import 'package:physioghar/models/therapist.dart';
import 'package:physioghar/screens/profile/widgets/edit_profile_dialog.dart';
import 'package:physioghar/screens/profile/widgets/profile_actions.dart';
import 'package:physioghar/screens/profile/widgets/profile_header.dart';
import 'package:physioghar/screens/profile/widgets/profile_settings_sheet.dart';
import 'package:physioghar/screens/profile/widgets/therapist_details_card.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      if (!mounted) {
        return;
      }

      ref.read(therapistProvider.notifier).loadProfile();
    });
  }

  @override
  Widget build(BuildContext context) {
    final therapistState = ref.watch(therapistProvider);

    final therapist = therapistState.therapist;

    if (therapist == null || therapistState.isLoading) {
      return const SafeArea(child: AppLoading());
    }

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: AppSizes.spacingXl),
        child: Column(
          children: [
            ProfileHeader(
              therapist: therapist,
              isAvatarUpdating: therapistState.isAvatarUpdating,
              onAvatarTap: () {
                _showAvatarOptions(context);
              },
            ),
            TherapistDetailsCard(
              therapist: therapist,
              onEdit: () {
                _openEditProfile(context, therapist);
              },
            ),
            const SizedBox(height: AppSizes.spacingMd),
            ProfileActions(
              onSettings: () {
                _openSettings(context);
              },
              onReportIssue: () {
                Navigator.of(context).pushNamed(AppRouter.complaints);
              },
              onLogout: () async {
                final confirmed = await context.showConfirmationDialog(
                  title: 'Logout',
                  message: 'Are you sure you want to logout?',
                  confirmText: 'Logout',
                  cancelText: 'Cancel',
                );

                if (confirmed != true) {
                  return;
                }

                await ref.read(authProvider.notifier).logout();

                if (!context.mounted) {
                  return;
                }

                

                AppSnackBar.showSuccess('Logged out successfully.');

                Navigator.of(context)
                    .pushNamedAndRemoveUntil(AppRouter.login, (route) => false);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showAvatarOptions(BuildContext context) async {
    showModalBottomSheet<void>(
      context: context,
      builder: (sheetContext) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt_outlined),
                title: const Text('Take a photo'),
                onTap: () async {
                  Navigator.of(sheetContext).pop();

                  await _pickAndUpdateAvatar(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library_outlined),
                title: const Text('Choose from gallery'),
                onTap: () async {
                  Navigator.of(sheetContext).pop();

                  await _pickAndUpdateAvatar(ImageSource.gallery);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _pickAndUpdateAvatar(ImageSource source) async {
    try {
      final picker = ImagePicker();

      final image = await picker.pickImage(source: source, imageQuality: 85);

      if (image == null) {
        return;
      }

      if (!mounted) {
        return;
      }

      await ref.read(therapistProvider.notifier).updateAvatar(File(image.path));
    } catch (error) {
      debugPrint('Failed to pick avatar: $error');
    }
  }

  Future<void> _openSettings(BuildContext context) async {
    await showModalBottomSheet<void>(
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
  }

  Future<void> _openEditProfile(
    BuildContext context,
    Therapist therapist,
  ) async {
    await showDialog<void>(
      context: context,
      builder: (_) {
        return EditProfileDialog(
          therapist: therapist,
          onSave:
              ({
                required String phone,
                required String experience,
                required String specialization,
                required String address,
                required String bio,
              }) async {
                await ref
                    .read(therapistProvider.notifier)
                    .updateProfile(
                      phone: phone,
                      experience: experience,
                      specialization: specialization,
                      address: address,
                      bio: bio,
                    );
              },
        );
      },
    );
  }
}
