// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:physioghar/core/constants/app_colors.dart';
// import 'package:physioghar/core/constants/app_sizes.dart';
// import 'package:physioghar/models/patient.dart';

// class PatientNoteCard extends StatelessWidget {
//   const PatientNoteCard({
//     super.key,
//     required this.note,
//     required this.onEdit,
//     required this.onDelete,
//   });
//   final PatientNote note;
//   final VoidCallback onEdit;
//   final VoidCallback onDelete;
//   @override
//   Widget build(BuildContext context) {
//     final isUpdated = note.updatedAt != null;
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
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Expanded(
//                 child: Text(
//                   'SESSION NOTE',
//                   style: GoogleFonts.ibmPlexMono(
//                     fontSize: AppSizes.fontSizeXs,
//                     fontWeight: FontWeight.w600,
//                     color: AppColors.pine,
//                     letterSpacing: 0.8,
//                   ),
//                 ),
//               ),
//               _NoteActionButton(
//                 icon: Icons.edit_outlined,
//                 tooltip: 'Edit note',
//                 onPressed: onEdit,
//               ),
//               const SizedBox(width: AppSizes.spacingXs),
//               _NoteActionButton(
//                 icon: Icons.delete_outline,
//                 tooltip: 'Delete note',
//                 onPressed: onDelete,
//                 isDestructive: true,
//               ),
//             ],
//           ),
//           const SizedBox(height: AppSizes.spacingMd),
//           Text(
//             note.content,
//             style: GoogleFonts.inter(
//               fontSize: AppSizes.fontSizeMd,
//               color: AppColors.ink,
//               height: 1.5,
//             ),
//           ),
//           const SizedBox(height: AppSizes.spacingMd),
//           Text(
//             _buildTimestamp(isUpdated),
//             style: GoogleFonts.ibmPlexMono(
//               fontSize: AppSizes.fontSizeXs,
//               color: AppColors.inkMute,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   String _buildTimestamp(bool isUpdated) {
//     final date = isUpdated ? note.updatedAt! : note.createdAt;
//     final dateText =
//         '${date.day.toString().padLeft(2, '0')}/'
//         '${date.month.toString().padLeft(2, '0')}/'
//         '${date.year}';
//     final timeText =
//         '${date.hour.toString().padLeft(2, '0')}:'
//         '${date.minute.toString().padLeft(2, '0')}';
//     return isUpdated
//         ? 'UPDATED $dateText • $timeText'
//         : 'ADDED $dateText • $timeText';
//   }
// }

// class _NoteActionButton extends StatelessWidget {
//   const _NoteActionButton({
//     required this.icon,
//     required this.tooltip,
//     required this.onPressed,
//     this.isDestructive = false,
//   });
//   final IconData icon;
//   final String tooltip;
//   final VoidCallback onPressed;
//   final bool isDestructive;
//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       width: AppSizes.minTapTarget,
//       height: AppSizes.minTapTarget,
//       child: IconButton(
//         onPressed: onPressed,
//         tooltip: tooltip,
//         icon: Icon(
//           icon,
//           size: 19,
//           color: isDestructive ? AppColors.danger : AppColors.pine,
//         ),
//         padding: EdgeInsets.zero,
//       ),
//     );
//   }
// }
