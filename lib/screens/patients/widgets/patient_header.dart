
// import 'package:flutter/material.dart';
// import 'package:physioghar/core/constants/app_colors.dart';
// import 'package:physioghar/core/constants/app_sizes.dart';
// import 'package:physioghar/models/patient.dart';

// class PatientHeader extends StatelessWidget {
//   const PatientHeader({
//     super.key,
//     required this.patient,
//   });

//   final Patient patient;

//   @override
//   Widget build(BuildContext context) {
//     final initial = patient.name.trim().isEmpty
//         ? '?'
//         : patient.name.trim()[0].toUpperCase();

//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.all(
//         AppSizes.spacingLg,
//       ),
//       decoration: BoxDecoration(
//         color: AppColors.pine,
//         borderRadius: BorderRadius.circular(
//           AppSizes.cardRadius,
//         ),
//       ),
//       child: Row(
//         children: [
//           _Avatar(
//             initial: initial,
//           ),
//           const SizedBox(
//             width: AppSizes.spacingMd,
//           ),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   patient.name,
//                   maxLines: 2,
//                   overflow: TextOverflow.ellipsis,
//                   style: Theme.of(context).textTheme.headlineSmall?.copyWith(
//                         color: Colors.white,
//                       ),
//                 ),
//                 const SizedBox(
//                   height: AppSizes.spacingXs,
//                 ),
//                 Text(
//                   '${patient.age} years • ${patient.gender}',
//                   style: Theme.of(context).textTheme.bodyMedium?.copyWith(
//                         color: Colors.white.withValues(
//                           alpha: 0.82,
//                         ),
//                       ),
//                 ),
//                 const SizedBox(
//                   height: AppSizes.spacingXs,
//                 ),
//                 Text(
//                   patient.condition,
//                   maxLines: 2,
//                   overflow: TextOverflow.ellipsis,
//                   style: Theme.of(context).textTheme.bodySmall?.copyWith(
//                         color: Colors.white.withValues(
//                           alpha: 0.72,
//                         ),
//                       ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class _Avatar extends StatelessWidget {
//   const _Avatar({
//     required this.initial,
//   });

//   final String initial;

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: 64,
//       height: 64,
//       alignment: Alignment.center,
//       decoration: const BoxDecoration(
//         color: AppColors.pineLight,
//         shape: BoxShape.circle,
//       ),
//       child: Text(
//         initial,
//         style: Theme.of(context).textTheme.headlineSmall?.copyWith(
//               color: Colors.white,
//               fontWeight: FontWeight.w700,
//             ),
//       ),
//     );
//   }
// }
