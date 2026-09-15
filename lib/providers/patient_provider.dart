// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:physioghar/data/mock_data.dart';
// import 'package:physioghar/models/patient.dart';

// class PatientNotifier extends Notifier<List<Patient>> {
//   @override
//   List<Patient> build() {
//     return MockData.patients;
//   }

//   Patient? getPatientById(String patientId) {
//     for (final patient in state) {
//       if (patient.id == patientId) {
//         return patient;
//       }
//     }

//     return null;
//   }

//   void addNote({
//     required String patientId,
//     required String content,
//   }) {
//     final newNote = PatientNote(
//       id: 'note_${DateTime.now().microsecondsSinceEpoch}',
//       content: content,
//       createdAt: DateTime.now(),
//     );

//     state = [
//       for (final patient in state)
//         if (patient.id == patientId)
//           patient.copyWith(
//             notes: [
//               newNote,
//               ...patient.notes,
//             ],
//           )
//         else
//           patient,
//     ];
//   }

//   void updateNote({
//     required String patientId,
//     required String noteId,
//     required String content,
//   }) {
//     state = [
//       for (final patient in state)
//         if (patient.id == patientId)
//           patient.copyWith(
//             notes: [
//               for (final note in patient.notes)
//                 if (note.id == noteId)
//                   note.copyWith(
//                     content: content,
//                     updatedAt: DateTime.now(),
//                   )
//                 else
//                   note,
//             ],
//           )
//         else
//           patient,
//     ];
//   }

//   void deleteNote({
//     required String patientId,
//     required String noteId,
//   }) {
//     state = [
//       for (final patient in state)
//         if (patient.id == patientId)
//           patient.copyWith(
//             notes: patient.notes
//                 .where((note) => note.id != noteId)
//                 .toList(),
//           )
//         else
//           patient,
//     ];
//   }
// }

// final patientProvider =
//     NotifierProvider<PatientNotifier, List<Patient>>(
//   PatientNotifier.new,
// );