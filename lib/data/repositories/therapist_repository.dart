import 'dart:io';

import 'package:physioghar/data/services/therapist_service.dart';
import 'package:physioghar/models/new/therapist.dart';

class TherapistRepository {
  TherapistRepository({TherapistService? therapistService})
    : _therapistService = therapistService ?? TherapistService();

  final TherapistService _therapistService;

  Future<Therapist> getProfile() async {
    final data = await _therapistService.getProfile();

    return Therapist.fromJson(data);
  }

  Future<Therapist> updateProfile({
    required String phone,
    required String specialization,
    required String experience,
    required String address,
    required String bio,
    required bool isAvailable,
  }) async {
    final data = await _therapistService.updateProfile(
      phone: phone,
      specialization: specialization,
      experience: experience,
      address: address,
      bio: bio,
      isAvailable: isAvailable,
    );

    return Therapist.fromJson(data);
  }

  Future<bool> updateAvailability(bool isAvailable) async {
    return _therapistService.updateAvailability(isAvailable);
  }

  Future<String?> getAvatar() async {
    return _therapistService.getAvatar();
  }

  Future<String?> updateAvatar(File image) async {
    return _therapistService.updateAvatar(image);
  }
}
