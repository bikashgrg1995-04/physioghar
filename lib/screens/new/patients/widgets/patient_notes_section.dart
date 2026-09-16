// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:physioghar/common_widgets/app_button.dart';
// import 'package:physioghar/core/constants/app_colors.dart';
// import 'package:physioghar/core/constants/app_sizes.dart';
// import 'package:physioghar/models/patient.dart';
// import 'package:physioghar/screens/patients/widgets/patient_note_card.dart';

// class PatientNotesSection extends StatelessWidget {
//   const PatientNotesSection({
//     super.key,
//     required this.patient,
//     required this.onAddNote,
//     required this.onEditNote,
//     required this.onDeleteNote,
//   });

//   final Patient patient;
//   final VoidCallback onAddNote;
//   final ValueChanged<PatientNote> onEditNote;
//   final ValueChanged<PatientNote> onDeleteNote;

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.all(AppSizes.spacingLg),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(AppSizes.cardRadius),
//         border: Border.all(color: AppColors.mist),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               Expanded(
//                 child: Text(
//                   'PATIENT NOTES',
//                   style: GoogleFonts.ibmPlexMono(
//                     fontSize: AppSizes.fontSizeXs,
//                     fontWeight: FontWeight.w600,
//                     color: AppColors.inkMute,
//                     letterSpacing: 0.8,
//                   ),
//                 ),
//               ),
//               AppButton(
//                 key: const Key('add-patient-note-button'),
//                 text: 'Add Note',
//                 width: 100,
//                 onPressed: onAddNote,
//                 variant: AppButtonVariant.secondary,
//               ),
//             ],
//           ),
//           const SizedBox(height: AppSizes.spacingMd),
//           if (patient.notes.isEmpty)
//             _EmptyNotes()
//           else
//             ...patient.notes.map(
//               (note) => Padding(
//                 padding: const EdgeInsets.only(bottom: AppSizes.spacingMd),
//                 child: PatientNoteCard(
//                   note: note,
//                   onEdit: () => onEditNote(note),
//                   onDelete: () => onDeleteNote(note),
//                 ),
//               ),
//             ),
//         ],
//       ),
//     );
//   }
// }

// class _EmptyNotes extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.all(AppSizes.spacingLg),
//       decoration: BoxDecoration(
//         color: AppColors.mist,
//         borderRadius: BorderRadius.circular(AppSizes.cardRadius),
//       ),
//       child: Text(
//         'No notes have been added yet.',
//         style: GoogleFonts.inter(
//           fontSize: AppSizes.fontSizeMd,
//           color: AppColors.inkMid,
//         ),
//       ),
//     );
//   }
// }
