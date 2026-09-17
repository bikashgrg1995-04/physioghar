
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:physioghar/common_widgets/app_button.dart';
// import 'package:physioghar/core/constants/app_colors.dart';
// import 'package:physioghar/core/constants/app_sizes.dart';
// import 'package:physioghar/models/patient.dart';

// class NoteEditorDialog extends StatefulWidget {
//   const NoteEditorDialog({
//     super.key,
//     this.note,
//   });

//   final PatientNote? note;

//   @override
//   State<NoteEditorDialog> createState() => _NoteEditorDialogState();
// }

// class _NoteEditorDialogState extends State<NoteEditorDialog> {
//   late final TextEditingController _controller;

//   bool get _isEditing => widget.note != null;

//   @override
//   void initState() {
//     super.initState();

//     _controller = TextEditingController(
//       text: widget.note?.content ?? '',
//     );
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   void _save() {
//     final content = _controller.text.trim();

//     if (content.isEmpty) {
//       return;
//     }

//     Navigator.of(context).pop(content);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return AlertDialog(
//       backgroundColor: AppColors.cream,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(
//           AppSizes.cardRadius,
//         ),
//       ),
//       title: Text(
//         _isEditing ? 'Edit Note' : 'Add Note',
//         style: GoogleFonts.fraunces(
//           fontSize: AppSizes.fontSizeXl,
//           fontWeight: FontWeight.w600,
//           color: AppColors.ink,
//         ),
//       ),
//       content: TextField(
//         controller: _controller,
//         autofocus: true,
//         minLines: 5,
//         maxLines: 8,
//         textCapitalization: TextCapitalization.sentences,
//         decoration: InputDecoration(
//           hintText: 'Enter session note...',
//           filled: true,
//           fillColor: Colors.white,
//           contentPadding: const EdgeInsets.all(
//             AppSizes.spacingMd,
//           ),
//           border: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(
//               AppSizes.cardRadius,
//             ),
//             borderSide: BorderSide.none,
//           ),
//         ),
//       ),
//       actions: [
//         TextButton(
//           onPressed: () {
//             Navigator.of(context).pop();
//           },
//           child: Text(
//             'Cancel',
//             style: GoogleFonts.inter(
//               fontSize: AppSizes.fontSizeMd,
//               fontWeight: FontWeight.w600,
//               color: AppColors.inkMid,
//             ),
//           ),
//         ),
//         SizedBox(
//           width: 100,
//           child: AppButton(
//             text: _isEditing ? 'Update' : 'Save',
//             onPressed: _save,
//           ),
//         ),
//       ],
//     );
//   }
// }
