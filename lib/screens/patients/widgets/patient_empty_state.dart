
// import 'package:flutter/material.dart';
// import 'package:physioghar/core/constants/app_colors.dart';
// import 'package:physioghar/core/constants/app_sizes.dart';

// class PatientEmptyState extends StatelessWidget {
//   const PatientEmptyState({
//     super.key,
//     this.hasSearch = false,
//   });

//   final bool hasSearch;

//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Padding(
//         padding: const EdgeInsets.all(
//           AppSizes.spacingXl,
//         ),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Container(
//               width: 64,
//               height: 64,
//               decoration: const BoxDecoration(
//                 color: AppColors.pinePale,
//                 shape: BoxShape.circle,
//               ),
//               child: const Icon(
//                 Icons.people_outline,
//                 color: AppColors.pine,
//                 size: 30,
//               ),
//             ),
//             const SizedBox(
//               height: AppSizes.spacingLg,
//             ),
//             Text(
//               hasSearch
//                   ? 'No patients found'
//                   : 'No patient records',
//               textAlign: TextAlign.center,
//               style: Theme.of(context).textTheme.titleMedium,
//             ),
//             const SizedBox(
//               height: AppSizes.spacingXs,
//             ),
//             Text(
//               hasSearch
//                   ? 'Try searching with another name or condition.'
//                   : 'Patient records will appear here.',
//               textAlign: TextAlign.center,
//               style: Theme.of(context).textTheme.bodyMedium?.copyWith(
//                     color: AppColors.inkMid,
//                   ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }