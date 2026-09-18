import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:physioghar/common_widgets/app_snackbar.dart';
import 'package:physioghar/data/repositories/therapist_repository.dart';
import 'package:physioghar/models/therapist.dart';

final therapistProvider =
    NotifierProvider<TherapistNotifier, TherapistState>(
  TherapistNotifier.new,
);

class TherapistState {
  const TherapistState({
    this.therapist,
    this.isLoading = false,
    this.isUpdating = false,
    this.isAvatarUpdating = false,
    this.errorMessage,
  });

  final Therapist? therapist;
  final bool isLoading;
  final bool isUpdating;
  final bool isAvatarUpdating;
  final String? errorMessage;

  TherapistState copyWith({
    Therapist? therapist,
    bool clearTherapist = false,
    bool? isLoading,
    bool? isUpdating,
    bool? isAvatarUpdating,
    String? errorMessage,
    bool clearError = false,
  }) {
    return TherapistState(
      therapist: clearTherapist
          ? null
          : therapist ?? this.therapist,
      isLoading: isLoading ?? this.isLoading,
      isUpdating: isUpdating ?? this.isUpdating,
      isAvatarUpdating:
          isAvatarUpdating ?? this.isAvatarUpdating,
      errorMessage: clearError
          ? null
          : errorMessage ?? this.errorMessage,
    );
  }
}

class TherapistNotifier extends Notifier<TherapistState> {
  late final TherapistRepository _therapistRepository;

  @override
  TherapistState build() {
    _therapistRepository = TherapistRepository();

    return const TherapistState();
  }

  Therapist? get therapist => state.therapist;

  bool get isAvailable =>
      state.therapist?.isAvailable ?? false;

  // ---------------------------------------------------------------------------
  // Load Profile
  // ---------------------------------------------------------------------------

  Future<void> loadProfile() async {
    if (state.isLoading) {
      return;
    }

    state = state.copyWith(
      isLoading: true,
      clearError: true,
    );

    try {
      final result =
          await _therapistRepository.getProfile();

      state = state.copyWith(
        therapist: result,
        isLoading: true,
      );

      try {
        final avatar =
            await _therapistRepository.getAvatar();

        state = state.copyWith(
          therapist: result.copyWith(
            avatar: avatar,
          ),
          isLoading: false,
          clearError: true,
        );
      } catch (error) {
        debugPrint(
          'Failed to load therapist avatar: $error',
        );

        state = state.copyWith(
          isLoading: false,
          clearError: true,
        );
      }
    } catch (error) {
      debugPrint(
        'Failed to load therapist profile: $error',
      );

      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Unable to load profile.',
      );

      AppSnackBar.showError(
        'Unable to load profile.',
      );
    }
  }

  // ---------------------------------------------------------------------------
  // Update Profile
  // ---------------------------------------------------------------------------

  Future<void> updateProfile({
    required String phone,
    required String specialization,
    required String experience,
    required String address,
    required String bio,
  }) async {
    final currentTherapist = state.therapist;

    if (currentTherapist == null ||
        state.isUpdating) {
      return;
    }

    state = state.copyWith(
      isUpdating: true,
    );

    try {
      final result =
          await _therapistRepository.updateProfile(
        phone: phone,
        specialization: specialization,
        experience: experience,
        address: address,
        bio: bio,
        isAvailable:
            currentTherapist.isAvailable ?? true,
      );

      // Preserve the existing avatar if the profile
      // update response does not contain an avatar.
      final avatar = result.avatar?.trim();

      state = state.copyWith(
        therapist: result.copyWith(
          avatar: avatar != null && avatar.isNotEmpty
              ? avatar
              : currentTherapist.avatar,
        ),
        isUpdating: false,
      );

      AppSnackBar.showSuccess(
        'Profile updated successfully.',
      );
    } catch (error) {
      debugPrint(
        'Failed to update profile: $error',
      );

      state = state.copyWith(
        isUpdating: false,
        errorMessage: 'Unable to update profile.',
      );

      AppSnackBar.showError(
        'Unable to update profile.',
      );
    }
  }

  // ---------------------------------------------------------------------------
  // Update Avatar
  // ---------------------------------------------------------------------------

  Future<void> updateAvatar(File file) async {
    if (state.isAvatarUpdating) {
      return;
    }

    final currentTherapist = state.therapist;

    if (currentTherapist == null) {
      return;
    }

    state = state.copyWith(
      isAvatarUpdating: true,
    );

    try {
      final avatar =
          await _therapistRepository.updateAvatar(file);

      state = state.copyWith(
        therapist: currentTherapist.copyWith(
          avatar: avatar,
        ),
        isAvatarUpdating: false,
      );

      AppSnackBar.showSuccess(
        'Profile photo updated successfully.',
      );
    } catch (error) {
      debugPrint(
        'Failed to update avatar: $error',
      );

      state = state.copyWith(
        isAvatarUpdating: false,
        errorMessage:
            'Unable to update profile photo.',
      );

      AppSnackBar.showError(
        'Unable to update profile photo.',
      );
    }
  }

  // ---------------------------------------------------------------------------
  // Update Availability
  // ---------------------------------------------------------------------------

  Future<void> updateAvailability(
    bool isAvailable,
  ) async {
    final currentTherapist = state.therapist;

    if (currentTherapist == null ||
        state.isUpdating) {
      return;
    }

    final previousValue =
        currentTherapist.isAvailable ?? false;

    // Optimistic update.
    state = state.copyWith(
      therapist: currentTherapist.copyWith(
        isAvailable: isAvailable,
      ),
      isUpdating: true,
    );

    try {
      final savedValue =
          await _therapistRepository
              .updateAvailability(
        isAvailable,
      );

      final latestTherapist = state.therapist;

      if (latestTherapist == null) {
        state = state.copyWith(
          isUpdating: false,
        );
        return;
      }

      state = state.copyWith(
        therapist: latestTherapist.copyWith(
          isAvailable: savedValue,
        ),
        isUpdating: false,
      );

      debugPrint(
        'Availability updated: $savedValue',
      );
    } catch (error) {
      final latestTherapist = state.therapist;

      state = state.copyWith(
        therapist: latestTherapist?.copyWith(
          isAvailable: previousValue,
        ),
        isUpdating: false,
        errorMessage:
            'Unable to update availability.',
      );

      debugPrint(
        'Failed to update availability: $error',
      );

      AppSnackBar.showError(
        'Unable to update availability.',
      );
    }
  }

  // ---------------------------------------------------------------------------
  // Error
  // ---------------------------------------------------------------------------

  void clearError() {
    state = state.copyWith(
      clearError: true,
    );
  }
}