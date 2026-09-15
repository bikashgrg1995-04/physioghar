import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:physioghar/common_widgets/app_snackbar.dart';
import 'package:physioghar/core/constants/app_sizes.dart';
import 'package:physioghar/data/repositories/therapist_repository.dart';
import 'package:physioghar/models/new/therapist.dart';
import 'package:physioghar/screens/new/auth/auth_controller.dart';
import 'package:physioghar/screens/new/profile/language_controller.dart';
import 'package:physioghar/screens/new/profile/widgets/edit_profile_dialog.dart';
import 'package:physioghar/screens/new/profile/widgets/profile_settings_sheet.dart';
import 'package:physioghar/screens/new/profile/widgets/report_issue_sheet.dart';

class TherapistController {
  TherapistController({
    TherapistRepository? therapistRepository,
    AuthController? authController,
  }) : _therapistRepository = therapistRepository ?? TherapistRepository(),
       _authController = authController ?? AuthController();
  final TherapistRepository _therapistRepository;
  final AuthController _authController;

  final isLoading = ValueNotifier<bool>(false);
  final isUpdating = ValueNotifier<bool>(false);

  final therapist = ValueNotifier<Therapist?>(null);

  final avatarImage = ValueNotifier<File?>(null);
  final isAvatarUpdating = ValueNotifier<bool>(false);

  Future<void> loadProfile() async {
    if (isLoading.value) {
      return;
    }

    isLoading.value = true;

    try {
      final result = await _therapistRepository.getProfile();

      therapist.value = result;

      // Profile API currently does not include avatar,
      //// so load it from the dedicated avatar endpoint.
      try {
        final avatar = await _therapistRepository.getAvatar();
        therapist.value = result.copyWith(avatar: avatar);
      } catch (error) {
        debugPrint('Failed to load therapist avatar: $error');
      }
    } catch (error) {
      debugPrint('Failed to load therapist profile: $error');

      AppSnackBar.showError('Unable to load profile.');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateProfile({
    required String phone,
    required String specialization,
    required String experience,
    required String address,
    required String bio,
  }) async {
    final currentTherapist = therapist.value;

    if (currentTherapist == null || isUpdating.value) {
      return;
    }

    isUpdating.value = true;

    try {
      final result = await _therapistRepository.updateProfile(
        phone: phone,
        specialization: specialization,
        experience: experience,
        address: address,
        bio: bio,
        isAvailable: currentTherapist.isAvailable ?? true,
      );

      therapist.value = result;

      AppSnackBar.showSuccess('Profile updated successfully.');
    } catch (error) {
      debugPrint('Failed to update profile: $error');

      AppSnackBar.showError('Unable to update profile.');
    } finally {
      isUpdating.value = false;
    }
  }

  Future<void> loadAvatar() async {
    try {
      final avatar = await _therapistRepository.getAvatar();

      final currentTherapist = therapist.value;

      if (currentTherapist == null) {
        return;
      }

      therapist.value = currentTherapist.copyWith(avatar: avatar);
    } catch (error) {
      debugPrint('Failed to load therapist avatar: $error');
    }
  }

  Future<void> changeAvatar(BuildContext context) async {
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library_outlined),
                title: const Text('Choose from gallery'),
                onTap: () {
                  Navigator.pop(context, ImageSource.gallery);
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt_outlined),
                title: const Text('Take a photo'),
                onTap: () {
                  Navigator.pop(context, ImageSource.camera);
                },
              ),
            ],
          ),
        );
      },
    );

    if (source == null) {
      return;
    }

    try {
      final picker = ImagePicker();

      final image = await picker.pickImage(source: source, imageQuality: 85);

      if (image == null) {
        return;
      }
      isAvatarUpdating.value = true;

      final file = File(image.path);

      final avatar = await _therapistRepository.updateAvatar(file);

      final currentTherapist = therapist.value;

      if (currentTherapist == null) {
        return;
      }

      therapist.value = currentTherapist.copyWith(avatar: avatar);

      AppSnackBar.showSuccess('Profile photo updated successfully.');
    } catch (error) {
      debugPrint('Failed to update avatar: $error');

      AppSnackBar.showError('Unable to update profile photo.');
    } finally {
      isAvatarUpdating.value = false;
    }
  }

  Future<void> updateAvailability(bool isAvailable) async {
    final currentTherapist = therapist.value;

    if (currentTherapist == null) {
      return;
    }

    final previousValue = currentTherapist.isAvailable ?? true;

    therapist.value = currentTherapist.copyWith(isAvailable: isAvailable);

    try {
      final savedValue = await _therapistRepository.updateAvailability(
        isAvailable,
      );

      final updatedTherapist = therapist.value;

      if (updatedTherapist != null) {
        therapist.value = updatedTherapist.copyWith(isAvailable: savedValue);
      }
    } catch (error) {
      final updatedTherapist = therapist.value;

      if (updatedTherapist != null) {
        therapist.value = updatedTherapist.copyWith(isAvailable: previousValue);
      }

      debugPrint('Failed to update availability: $error');

      AppSnackBar.showError('Unable to update availability.');
    }
  }

  Future<void> openEditProfile(BuildContext context) async {
    final currentTherapist = therapist.value;

    if (currentTherapist == null) {
      return;
    }

    await showDialog<void>(
      context: context,
      builder: (_) {
        return EditProfileDialog(
          therapist: currentTherapist,
          onSave:
              ({
                required String phone,
                required String experience,
                required String specialization,
                required String address,
                required String bio,
              }) async {
                await updateProfile(
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

  Future<void> openSettings(
    BuildContext context,
    LanguageController languageController,
  ) async {
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
        return ProfileSettingsSheet(
          therapistController: this,
          languageController: languageController,
        );
      },
    );
  }

  Future<void> openReportIssue(BuildContext context) async {
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
        return const ReportIssueSheet();
      },
    );
  }

  Future<void> logout(BuildContext context) async {
    await _authController.logout(context);
  }

  void dispose() {
    isLoading.dispose();
    isUpdating.dispose();
    therapist.dispose();

    isAvatarUpdating.dispose();

    _authController.dispose();
  }
}
