// import 'package:flutter/material.dart';
// import 'package:physioghar/core/constants/app_colors.dart';
// import 'package:physioghar/core/constants/app_sizes.dart';
// import 'package:physioghar/models/session.dart';

// class ScheduleItemCard extends StatelessWidget {
//   final Session session;
//   final VoidCallback? onTap;
//   final Key? cardKey;

//   const ScheduleItemCard({super.key, required this.session, this.onTap, this.cardKey});

//   String _formatTime(DateTime dateTime) {
//     final hour = dateTime.hour;
//     final minute = dateTime.minute;

//     final period = hour >= 12 ? 'PM' : 'AM';
//     final displayHour = hour % 12 == 0 ? 12 : hour % 12;
//     final displayMinute = minute.toString().padLeft(2, '0');

//     return '$displayHour:$displayMinute $period';
//   }

//   @override
//   Widget build(BuildContext context) {
//     final textTheme = Theme.of(context).textTheme;

//     return Material(
//       key: cardKey,
//       color: Colors.white,
//       borderRadius: BorderRadius.circular(AppSizes.cardRadius),
//       child: InkWell(
//         onTap: onTap,
//         borderRadius: BorderRadius.circular(AppSizes.cardRadius),
//         child: Padding(
//           padding: const EdgeInsets.all(AppSizes.spacingMd),
//           child: Row(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Time
//               SizedBox(
//                 width: 64,
//                 child: Text(
//                   _formatTime(session.dateTime),
//                   style: textTheme.labelLarge?.copyWith(
//                     color: AppColors.pine,
//                     fontSize: AppSizes.fontSizeSm,
//                   ),
//                 ),
//               ),

//               const SizedBox(width: AppSizes.spacingMd),

//               // Session details
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       session.patientName,
//                       style: textTheme.bodyLarge?.copyWith(
//                         fontWeight: FontWeight.w600,
//                       ),
//                       maxLines: 1,
//                       overflow: TextOverflow.ellipsis,
//                     ),

//                     const SizedBox(height: AppSizes.spacingXs),

//                     Text(
//                       session.treatment,
//                       style: textTheme.bodyMedium?.copyWith(
//                         color: AppColors.inkMid,
//                       ),
//                       maxLines: 1,
//                       overflow: TextOverflow.ellipsis,
//                     ),

//                     const SizedBox(height: AppSizes.spacingXs),

//                     Row(
//                       children: [
//                         const Icon(
//                           Icons.location_on_outlined,
//                           size: 16,
//                           color: AppColors.inkMute,
//                         ),
//                         const SizedBox(width: AppSizes.spacingXs),
//                         Expanded(
//                           child: Text(
//                             session.location,
//                             style: textTheme.bodyMedium?.copyWith(
//                               color: AppColors.inkMute,
//                               fontSize: AppSizes.fontSizeSm,
//                             ),
//                             maxLines: 1,
//                             overflow: TextOverflow.ellipsis,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),

//               const SizedBox(width: AppSizes.spacingSm),

//               const Icon(
//                 Icons.chevron_right,
//                 size: 20,
//                 color: AppColors.inkMute,
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
