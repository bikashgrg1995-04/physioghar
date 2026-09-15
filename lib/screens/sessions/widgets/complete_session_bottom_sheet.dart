// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:physioghar/common_widgets/app_button.dart';
// import 'package:physioghar/common_widgets/app_snackbar.dart';
// import 'package:physioghar/core/constants/app_colors.dart';
// import 'package:physioghar/core/constants/app_sizes.dart';
// import 'package:physioghar/models/session.dart';
// import 'package:physioghar/providers/session_provider.dart';

// void showCompleteSessionBottomSheet(
//   BuildContext context, {
//   required Session session,
// }) {
//   showModalBottomSheet<void>(
//     context: context,
//     isScrollControlled: true,
//     backgroundColor: Colors.transparent,
//     builder: (_) {
//       return _CompleteSessionBottomSheet(
//         session: session,
//       );
//     },
//   );
// }

// class _CompleteSessionBottomSheet extends ConsumerStatefulWidget {
//   const _CompleteSessionBottomSheet({
//     required this.session,
//   });

//   final Session session;

//   @override
//   ConsumerState<_CompleteSessionBottomSheet> createState() =>
//       _CompleteSessionBottomSheetState();
// }

// class _CompleteSessionBottomSheetState
//     extends ConsumerState<_CompleteSessionBottomSheet> {
//   late final TextEditingController _notesController;

//   @override
//   void initState() {
//     super.initState();
//     _notesController = TextEditingController();
//   }

//   @override
//   void dispose() {
//     _notesController.dispose();
//     super.dispose();
//   }

//   void _submit() {
//     final notes = _notesController.text.trim();

//     ref.read(sessionProvider.notifier).completeSession(
//           widget.session.id,
//           notes: notes,
//         );

//     if (!mounted) {
//       return;
//     }

//     Navigator.of(context).pop();

//     AppSnackBar.showSuccess(
//       context,
//       'Session completed successfully.',
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final bottomInset = MediaQuery.viewInsetsOf(context).bottom;

//     return Container(
//       padding: EdgeInsets.fromLTRB(
//         AppSizes.spacingLg,
//         AppSizes.spacingLg,
//         AppSizes.spacingLg,
//         AppSizes.spacingLg + bottomInset,
//       ),
//       decoration: const BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.vertical(
//           top: Radius.circular(AppSizes.cardRadius),
//         ),
//       ),
//       child: SafeArea(
//         top: false,
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Center(
//               child: Container(
//                 width: 40,
//                 height: 4,
//                 decoration: BoxDecoration(
//                   color: AppColors.mist,
//                   borderRadius: BorderRadius.circular(50),
//                 ),
//               ),
//             ),
//             const SizedBox(height: AppSizes.spacingLg),
//             Text(
//               'Complete Session',
//               style: GoogleFonts.fraunces(
//                 fontSize: AppSizes.fontSizeXl,
//                 fontWeight: FontWeight.w600,
//                 color: AppColors.ink,
//               ),
//             ),
//             const SizedBox(height: AppSizes.spacingXs),
//             Text(
//               'Add therapist remarks before completing this session.',
//               style: GoogleFonts.inter(
//                 fontSize: AppSizes.fontSizeMd,
//                 color: AppColors.inkMid,
//               ),
//             ),
//             const SizedBox(height: AppSizes.spacingLg),
//             Text(
//               'THERAPIST REMARKS',
//               style: GoogleFonts.ibmPlexMono(
//                 fontSize: AppSizes.fontSizeXs,
//                 fontWeight: FontWeight.w600,
//                 letterSpacing: 0.6,
//                 color: AppColors.inkMid,
//               ),
//             ),
//             const SizedBox(height: AppSizes.spacingSm),
//             TextField(
//               controller: _notesController,
//               minLines: 4,
//               maxLines: 6,
//               textInputAction: TextInputAction.newline,
//               decoration: InputDecoration(
//                 hintText: 'Write session remarks or notes...',
//                 hintStyle: GoogleFonts.inter(
//                   fontSize: AppSizes.fontSizeMd,
//                   color: AppColors.inkMute,
//                 ),
//                 filled: true,
//                 fillColor: AppColors.cream,
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(
//                     AppSizes.cardRadius,
//                   ),
//                   borderSide: const BorderSide(
//                     color: AppColors.mist,
//                   ),
//                 ),
//                 enabledBorder: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(
//                     AppSizes.cardRadius,
//                   ),
//                   borderSide: const BorderSide(
//                     color: AppColors.mist,
//                   ),
//                 ),
//                 focusedBorder: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(
//                     AppSizes.cardRadius,
//                   ),
//                   borderSide: const BorderSide(
//                     color: AppColors.pine,
//                   ),
//                 ),
//               ),
//             ),
//             const SizedBox(height: AppSizes.spacingLg),
//             Row(
//               children: [
//                 Expanded(
//                   child: AppButton(
//                     text: 'Cancel',
//                     variant: AppButtonVariant.secondary,
//                     onPressed: () {
//                       Navigator.of(context).pop();
//                     },
//                   ),
//                 ),
//                 const SizedBox(width: AppSizes.spacingMd),
//                 Expanded(
//                   child: AppButton(
//                     text: 'Submit',
//                     onPressed: _submit,
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }