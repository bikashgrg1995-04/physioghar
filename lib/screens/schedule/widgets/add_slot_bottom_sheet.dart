// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:physioghar/common_widgets/app_snackbar.dart';
// import 'package:physioghar/core/constants/app_sizes.dart';
// import 'package:physioghar/core/utils/date_time_utils.dart';
// import 'package:physioghar/providers/schedule_provider.dart';

// class AddSlotBottomSheet extends ConsumerStatefulWidget {
//   final DateTime selectedDate;
//   final VoidCallback? onSlotAdded;

//   const AddSlotBottomSheet({
//     super.key,
//     required this.selectedDate,
//     this.onSlotAdded,
//   });

//   @override
//   ConsumerState<AddSlotBottomSheet> createState() => _AddSlotBottomSheetState();
// }

// class _AddSlotBottomSheetState extends ConsumerState<AddSlotBottomSheet> {
//   TimeOfDay? _selectedTime;

//   Future<void> _pickTime() async {
//     final pickedTime = await showTimePicker(
//       context: context,
//       initialTime: TimeOfDay.now(),
//     );

//     if (pickedTime == null) {
//       return;
//     }

//     if (!mounted) {
//       return;
//     }

//     setState(() {
//       _selectedTime = pickedTime;
//     });
//   }

//   void _addSlot() {
//     if (_selectedTime == null) {
//       return;
//     }

//     final dateTime = DateTime(
//       widget.selectedDate.year,
//       widget.selectedDate.month,
//       widget.selectedDate.day,
//       _selectedTime!.hour,
//       _selectedTime!.minute,
//     );

//     final added = ref.read(scheduleProvider.notifier).addSlot(dateTime);

//     if (!mounted) {
//       return;
//     }
// Navigator.of(context).pop();
//     if (!added) {
//       AppSnackBar.showError(
//         context,
//         'A slot already exists at this date and time.',
//       );
//       return;
//     }

    
//     widget.onSlotAdded?.call();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Padding(
//         padding: const EdgeInsets.all(AppSizes.spacingXl),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               'Add Available Slot',
//               style: Theme.of(context).textTheme.headlineLarge,
//             ),
//             const SizedBox(height: AppSizes.spacingXs),
//             Text(
//               DateTimeUtils.formatFullDate(widget.selectedDate),
//               style: Theme.of(context).textTheme.bodyMedium,
//             ),
//             const SizedBox(height: AppSizes.spacingXl),
//             Text('Select time', style: Theme.of(context).textTheme.labelLarge),
//             const SizedBox(height: AppSizes.spacingSm),
//             InkWell(
//               onTap: _pickTime,
//               borderRadius: BorderRadius.circular(AppSizes.cardRadius),
//               child: Container(
//                 width: double.infinity,
//                 padding: const EdgeInsets.all(AppSizes.spacingLg),
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(AppSizes.cardRadius),
//                   border: Border.all(
//                     color: Theme.of(context).colorScheme.outline,
//                   ),
//                 ),
//                 child: Row(
//                   children: [
//                     const Icon(Icons.access_time_outlined),
//                     const SizedBox(width: AppSizes.spacingMd),
//                     Expanded(
//                       child: Text(
//                         _selectedTime == null
//                             ? 'Choose a time'
//                             : _selectedTime!.format(context),
//                         style: Theme.of(context).textTheme.bodyLarge,
//                       ),
//                     ),
//                     const Icon(Icons.chevron_right),
//                   ],
//                 ),
//               ),
//             ),
//             const SizedBox(height: AppSizes.spacingXl),
//             SizedBox(
//               width: double.infinity,
//               child: FilledButton(
//                 onPressed: _selectedTime == null ? null : _addSlot,
//                 child: const Text('Add Slot'),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
