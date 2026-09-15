// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:physioghar/core/constants/app_colors.dart';
// import 'package:physioghar/core/constants/app_sizes.dart';
// import 'package:physioghar/models/patient.dart';

// class PatientConditionCard extends StatelessWidget {
//   const PatientConditionCard({super.key, required this.patient});
//   final Patient patient;
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.all(AppSizes.spacingLg),
//       decoration: BoxDecoration(
//         color: AppColors.pinePale,
//         borderRadius: BorderRadius.circular(AppSizes.cardRadius),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             'CURRENT CONDITION',
//             style: GoogleFonts.ibmPlexMono(
//               fontSize: AppSizes.fontSizeXs,
//               fontWeight: FontWeight.w600,
//               color: AppColors.pine,
//               letterSpacing: 0.8,
//             ),
//           ),
//           const SizedBox(height: AppSizes.spacingSm),
//           Text(
//             patient.condition,
//             style: GoogleFonts.fraunces(
//               fontSize: AppSizes.fontSizeXl,
//               fontWeight: FontWeight.w600,
//               color: AppColors.ink,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
