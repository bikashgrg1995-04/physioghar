// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:physioghar/core/constants/app_colors.dart';
// import 'package:physioghar/core/constants/app_sizes.dart';

// class SessionsHeader extends StatelessWidget {
//   const SessionsHeader({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.fromLTRB(
//         AppSizes.spacingXl,
//         AppSizes.spacingLg,
//         AppSizes.spacingXl,
//         AppSizes.spacingMd,
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             'Sessions',
//             key: const Key('sessions-screen-title'),
//             style: GoogleFonts.fraunces(
//               fontSize: AppSizes.fontSizeXxl,
//               fontWeight: FontWeight.w600,
//               color: AppColors.ink,
//             ),
//           ),
//           const SizedBox(height: AppSizes.spacingXs),
//           Text(
//             'Manage your bookings & appointments',
//             style: GoogleFonts.inter(
//               fontSize: AppSizes.fontSizeMd,
//               color: AppColors.inkMid,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }