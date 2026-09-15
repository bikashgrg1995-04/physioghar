// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:physioghar/data/mock_data.dart';
// import 'package:physioghar/models/therapist.dart';

// class TherapistNotifier extends Notifier<Therapist> {
//   @override
//   Therapist build() {
//     return MockData.initialTherapist;
//   }

//   void toggleAvailability() {
//     state = state.copyWith(
//       isAvailable: !state.isAvailable,
//     );
//   }

//   void updateProfile({
//     String? name,
//     String? email,
//     String? phone,
//     String? specialization,
//     String? experience,
//     String? address,
//     String? avatarUrl,
//   }) {
//     state = state.copyWith(
//       name: name,
//       email: email,
//       phone: phone,
//       specialization: specialization,
//       experience: experience,
//       address: address,
//       avatarUrl: avatarUrl,
//     );
//   }
// }

// final therapistProvider =
//     NotifierProvider<TherapistNotifier, Therapist>(
//   TherapistNotifier.new,
// );