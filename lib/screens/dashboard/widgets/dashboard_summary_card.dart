// import 'package:flutter/material.dart';
// import 'package:physioghar/core/constants/app_colors.dart';
// import 'package:physioghar/core/constants/app_sizes.dart';

// class DashboardSummaryCard extends StatelessWidget {
//   final String title;
//   final String value;
//   final IconData icon;
//   final Color iconBackgroundColor;
//   final Color iconColor;

//   const DashboardSummaryCard({
//     super.key,
//     required this.title,
//     required this.value,
//     required this.icon,
//     this.iconBackgroundColor = AppColors.pinePale,
//     this.iconColor = AppColors.pine,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final textTheme = Theme.of(context).textTheme;

//     return Container(
//       key: Key('summary-card-$title'),
//       width: double.infinity,
//       padding: const EdgeInsets.all(AppSizes.spacingMd),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(AppSizes.cardRadius),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Icon + Number
//           Row(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               Container(
//                 width: 36,
//                 height: 36,
//                 decoration: BoxDecoration(
//                   color: iconBackgroundColor,
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//                 child: Icon(
//                   icon,
//                   color: iconColor,
//                   size: 18,
//                 ),
//               ),

//               const SizedBox(width: AppSizes.spacingMd),

//               Text(
//                 value,
//                 style: textTheme.headlineLarge,
//                 maxLines: 1,
//                 overflow: TextOverflow.ellipsis,
//               ),
//             ],
//           ),

//           const SizedBox(height: AppSizes.spacingSm),

//           // Title
//           Text(
//             title,
//             style: textTheme.bodyMedium?.copyWith(
//               color: AppColors.inkMute,
//               fontSize: AppSizes.fontSizeSm,
//             ),
//             maxLines: 2,
//             overflow: TextOverflow.ellipsis,
//           ),
//         ],
//       ),
//     );
//   }
// }