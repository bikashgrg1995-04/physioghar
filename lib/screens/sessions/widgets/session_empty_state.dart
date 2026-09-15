// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:physioghar/core/constants/app_colors.dart';
// import 'package:physioghar/core/constants/app_sizes.dart';

// class SessionEmptyState extends StatelessWidget {
//   const SessionEmptyState({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Padding(
//         padding: const EdgeInsets.all(AppSizes.spacingXxl),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Container(
//               width: 64,
//               height: 64,
//               decoration: BoxDecoration(
//                 color: AppColors.mist,
//                 borderRadius: BorderRadius.circular(
//                   AppSizes.cardRadius,
//                 ),
//               ),
//               child: const Icon(
//                 Icons.event_note_outlined,
//                 size: 30,
//                 color: AppColors.inkMute,
//               ),
//             ),
//             const SizedBox(height: AppSizes.spacingLg),
//             Text(
//               'No sessions yet',
//               textAlign: TextAlign.center,
//               style: GoogleFonts.fraunces(
//                 fontSize: AppSizes.fontSizeXl,
//                 fontWeight: FontWeight.w600,
//                 color: AppColors.ink,
//               ),
//             ),
//             const SizedBox(height: AppSizes.spacingXs),
//             Text(
//               'Your sessions will appear here once you have bookings.',
//               textAlign: TextAlign.center,
//               style: GoogleFonts.inter(
//                 fontSize: AppSizes.fontSizeMd,
//                 color: AppColors.inkMid,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }