import 'package:flutter/material.dart';

import 'package:physioghar/core/constants/app_colors.dart';
import 'package:physioghar/core/constants/app_sizes.dart';
import 'package:physioghar/models/patient_note.dart';
import 'package:physioghar/screens/new/patients/patient_controller.dart';

class PatientNotes extends StatelessWidget {
  const PatientNotes({
    super.key,
    required this.patientId,
    required this.controller,
  });

  final int patientId;
  final PatientController controller;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<PatientNote>>(
      valueListenable: controller.notes,
      builder: (context, notes, _) {
        final visibleNotes = notes
            .where((note) => note.hasContent)
            .toList();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(
              context,
              visibleNotes.length,
            ),

            const SizedBox(
              height: AppSizes.spacingSm,
            ),

            if (visibleNotes.isEmpty)
              _buildEmptyState(context)
            else
              _buildNotesList(
                context,
                visibleNotes,
              ),
          ],
        );
      },
    );
  }

  Widget _buildHeader(
    BuildContext context,
    int noteCount,
  ) {
    return Row(
      children: [
        const Text(
          'Patient Notes',
          style: TextStyle(
            fontSize: AppSizes.fontSizeLg,
            fontWeight: FontWeight.w700,
            color: AppColors.ink,
          ),
        ),

        const Spacer(),

        Text(
          '$noteCount ${noteCount == 1 ? 'note' : 'notes'}',
          style: const TextStyle(
            fontSize: AppSizes.fontSizeSm,
            color: AppColors.inkMute,
          ),
        ),

        const SizedBox(
          width: AppSizes.spacingSm,
        ),

        TextButton.icon(
          onPressed: () {
            _showAddNoteSheet(context);
          },
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSizes.spacingSm,
            ),
            minimumSize: const Size(
              0,
              AppSizes.minTapTarget,
            ),
            tapTargetSize:
                MaterialTapTargetSize.shrinkWrap,
          ),
          icon: const Icon(
            Icons.add_rounded,
            size: 19,
          ),
          label: const Text(
            'Add Note',
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(
        AppSizes.spacingXl,
      ),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(
          AppSizes.cardRadius,
        ),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.notes_outlined,
            size: 32,
            color: AppColors.inkMute,
          ),

          const SizedBox(
            height: AppSizes.spacingSm,
          ),

          const Text(
            'No notes yet',
            style: TextStyle(
              fontSize: AppSizes.fontSizeMd,
              fontWeight: FontWeight.w600,
              color: AppColors.ink,
            ),
          ),

          const SizedBox(
            height: AppSizes.spacingXs,
          ),

          const Text(
            'Add a note to keep track of this patient.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: AppSizes.fontSizeSm,
              color: AppColors.inkMute,
            ),
          ),

          const SizedBox(
            height: AppSizes.spacingMd,
          ),

          OutlinedButton.icon(
            onPressed: () {
              _showAddNoteSheet(context);
            },
            icon: const Icon(
              Icons.add_rounded,
              size: 18,
            ),
            label: const Text(
              'Add Note',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotesList(
    BuildContext context,
    List<PatientNote> notes,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(
          AppSizes.cardRadius,
        ),
      ),
      child: Column(
        children: [
          for (int index = 0; index < notes.length; index++) ...[
            _NoteListItem(
              note: notes[index],
              onTap: () {
                _showNoteDetails(
                  context,
                  notes[index],
                );
              },
            ),

            if (index != notes.length - 1)
              const Divider(
                height: 1,
                indent: 16,
                endIndent: 16,
              ),
          ],
        ],
      ),
    );
  }

  void _showNoteDetails(
    BuildContext context,
    PatientNote note,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return _NoteDetailsBottomSheet(
          note: note,
          onEdit: () {
            Navigator.pop(context);

            _showEditNoteSheet(
              context,
              note,
            );
          },
          onDelete: () {
            Navigator.pop(context);

            _confirmDeleteNote(
              context,
              note,
            );
          },
        );
      },
    );
  }

  void _showAddNoteSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return _AddNoteBottomSheet(
          onSave: (content) async {
            final success = await controller.addNote(
              patientId: patientId,
              content: content,
            );

            if (success && context.mounted) {
              Navigator.pop(context);
            }
          },
        );
      },
    );
  }

  void _showEditNoteSheet(
    BuildContext context,
    PatientNote note,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return _EditNoteBottomSheet(
          note: note,
          onSave: (content) async {
            if (note.id == null) return;

            final success = await controller.editNote(
              patientId: patientId,
              noteId: note.id!,
              content: content,
            );

            if (success && context.mounted) {
              Navigator.pop(context);
            }
          },
        );
      },
    );
  }

  void _confirmDeleteNote(
    BuildContext context,
    PatientNote note,
  ) {
    if (note.id == null) return;

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text(
            'Delete Note?',
          ),
          content: const Text(
            'Are you sure you want to delete this note? '
            'This action cannot be undone.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text(
                'Cancel',
              ),
            ),

            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.danger,
              ),
              onPressed: () async {
                Navigator.pop(dialogContext);

                await controller.deleteNote(
                  patientId: patientId,
                  noteId: note.id!,
                );
              },
              child: const Text(
                'Delete',
              ),
            ),
          ],
        );
      },
    );
  }
}


// ============================================================
// NOTE DETAILS
// ============================================================

class _NoteDetailsBottomSheet extends StatelessWidget {
  const _NoteDetailsBottomSheet({
    required this.note,
    required this.onEdit,
    required this.onDelete,
  });

  final PatientNote note;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        constraints: BoxConstraints(
          maxHeight:
              MediaQuery.sizeOf(context).height * 0.75,
        ),
        decoration: const BoxDecoration(
          color: AppColors.cream,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(24),
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            AppSizes.spacingXl,
            AppSizes.spacingSm,
            AppSizes.spacingXl,
            AppSizes.spacingXl,
          ),
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.inkMute,
                    borderRadius:
                        BorderRadius.circular(10),
                  ),
                ),
              ),

              const SizedBox(
                height: AppSizes.spacingXl,
              ),

              Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Patient Note',
                      style: TextStyle(
                        fontSize:
                            AppSizes.fontSizeXl,
                        fontWeight: FontWeight.w700,
                        color: AppColors.ink,
                      ),
                    ),
                  ),

                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      Icons.close_rounded,
                    ),
                  ),
                ],
              ),

              const SizedBox(
                height: AppSizes.spacingMd,
              ),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(
                  AppSizes.spacingLg,
                ),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius:
                      BorderRadius.circular(
                    AppSizes.cardRadius,
                  ),
                ),
                child: Text(
                  note.content?.trim() ?? '',
                  style: const TextStyle(
                    fontSize: AppSizes.fontSizeMd,
                    height: 1.6,
                    color: AppColors.ink,
                  ),
                ),
              ),

              if (note.createdAt != null) ...[
                const SizedBox(
                  height: AppSizes.spacingMd,
                ),

                Row(
                  children: [
                    const Icon(
                      Icons.calendar_today_outlined,
                      size: 17,
                      color: AppColors.pine,
                    ),

                    const SizedBox(
                      width: AppSizes.spacingSm,
                    ),

                    Text(
                      'Added ${_formatDate(note.createdAt!)}',
                      style: const TextStyle(
                        fontSize:
                            AppSizes.fontSizeSm,
                        color: AppColors.inkMute,
                      ),
                    ),
                  ],
                ),
              ],

              const SizedBox(
                height: AppSizes.spacingXl,
              ),

              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: onEdit,
                      icon: const Icon(
                        Icons.edit_outlined,
                        size: 18,
                      ),
                      label: const Text(
                        'Edit',
                      ),
                    ),
                  ),

                  const SizedBox(
                    width: AppSizes.spacingMd,
                  ),

                  Expanded(
                    child: FilledButton.icon(
                      style: FilledButton.styleFrom(
                        backgroundColor:
                            AppColors.danger,
                      ),
                      onPressed: onDelete,
                      icon: const Icon(
                        Icons.delete_outline_rounded,
                        size: 18,
                      ),
                      label: const Text(
                        'Delete',
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  static String _formatDate(DateTime date) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];

    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }
}


// ============================================================
// NOTE LIST ITEM
// ============================================================

class _NoteListItem extends StatelessWidget {
  const _NoteListItem({
    required this.note,
    required this.onTap,
  });

  final PatientNote note;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final content =
        note.content?.trim() ?? '';

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(
        AppSizes.cardRadius,
      ),
      child: Padding(
        padding: const EdgeInsets.all(
          AppSizes.spacingLg,
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppColors.amberPale,
                borderRadius:
                    BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.notes_outlined,
                color: AppColors.amber,
                size: 22,
              ),
            ),

            const SizedBox(
              width: AppSizes.spacingMd,
            ),

            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text(
                    content,
                    maxLines: 2,
                    overflow:
                        TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize:
                          AppSizes.fontSizeMd,
                      fontWeight:
                          FontWeight.w600,
                      color: AppColors.ink,
                      height: 1.35,
                    ),
                  ),

                  if (note.createdAt != null) ...[
                    const SizedBox(
                      height: AppSizes.spacingXs,
                    ),

                    Text(
                      _formatDate(
                        note.createdAt!,
                      ),
                      style: const TextStyle(
                        fontSize:
                            AppSizes.fontSizeXs,
                        color:
                            AppColors.inkMute,
                      ),
                    ),
                  ],
                ],
              ),
            ),

            const SizedBox(
              width: AppSizes.spacingSm,
            ),

            const Icon(
              Icons.chevron_right_rounded,
              color: AppColors.inkMute,
            ),
          ],
        ),
      ),
    );
  }

  static String _formatDate(DateTime date) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];

    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }
}


// ============================================================
// ADD NOTE BOTTOM SHEET
// ============================================================

class _AddNoteBottomSheet extends StatefulWidget {
  const _AddNoteBottomSheet({
    required this.onSave,
  });

  final Future<void> Function(String content) onSave;

  @override
  State<_AddNoteBottomSheet> createState() =>
      _AddNoteBottomSheetState();
}

class _AddNoteBottomSheetState
    extends State<_AddNoteBottomSheet> {
  late final TextEditingController _textController;

  @override
  void initState() {
    super.initState();

    _textController = TextEditingController();
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final content =
        _textController.text.trim();

    if (content.isEmpty) {
      _showValidationError();
      return;
    }

    await widget.onSave(content);
  }

  void _showValidationError() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Please enter a note.',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset =
        MediaQuery.viewInsetsOf(context).bottom;

    return SafeArea(
      child: Container(
        padding: EdgeInsets.fromLTRB(
          AppSizes.spacingXl,
          AppSizes.spacingSm,
          AppSizes.spacingXl,
          AppSizes.spacingXl + bottomInset,
        ),
        decoration: const BoxDecoration(
          color: AppColors.cream,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(24),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.inkMute,
                  borderRadius:
                      BorderRadius.circular(10),
                ),
              ),
            ),

            const SizedBox(
              height: AppSizes.spacingXl,
            ),

            Row(
              children: [
                const Expanded(
                  child: Text(
                    'Add Patient Note',
                    style: TextStyle(
                      fontSize:
                          AppSizes.fontSizeXl,
                      fontWeight:
                          FontWeight.w700,
                      color: AppColors.ink,
                    ),
                  ),
                ),

                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.close_rounded,
                  ),
                ),
              ],
            ),

            const SizedBox(
              height: AppSizes.spacingMd,
            ),

            TextField(
              controller: _textController,
              autofocus: true,
              minLines: 4,
              maxLines: 7,
              textInputAction:
                  TextInputAction.newline,
              decoration: InputDecoration(
                hintText:
                    'Write a note about this patient...',
                filled: true,
                fillColor: AppColors.white,
                border: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
                contentPadding:
                    const EdgeInsets.all(
                  AppSizes.spacingLg,
                ),
              ),
            ),

            const SizedBox(
              height: AppSizes.spacingLg,
            ),

            SizedBox(
              width: double.infinity,
              height: 52,
              child: FilledButton(
                onPressed: _save,
                child: const Text(
                  'Save Note',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


// ============================================================
// EDIT NOTE BOTTOM SHEET
// ============================================================

class _EditNoteBottomSheet extends StatefulWidget {
  const _EditNoteBottomSheet({
    required this.note,
    required this.onSave,
  });

  final PatientNote note;
  final Future<void> Function(String content) onSave;

  @override
  State<_EditNoteBottomSheet> createState() =>
      _EditNoteBottomSheetState();
}

class _EditNoteBottomSheetState
    extends State<_EditNoteBottomSheet> {
  late final TextEditingController _textController;

  @override
  void initState() {
    super.initState();

    _textController = TextEditingController(
      text: widget.note.content?.trim() ?? '',
    );
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final content =
        _textController.text.trim();

    if (content.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please enter a note.',
          ),
        ),
      );
      return;
    }

    await widget.onSave(content);
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset =
        MediaQuery.viewInsetsOf(context).bottom;

    return SafeArea(
      child: Container(
        padding: EdgeInsets.fromLTRB(
          AppSizes.spacingXl,
          AppSizes.spacingSm,
          AppSizes.spacingXl,
          AppSizes.spacingXl + bottomInset,
        ),
        decoration: const BoxDecoration(
          color: AppColors.cream,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(24),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.inkMute,
                  borderRadius:
                      BorderRadius.circular(10),
                ),
              ),
            ),

            const SizedBox(
              height: AppSizes.spacingXl,
            ),

            Row(
              children: [
                const Expanded(
                  child: Text(
                    'Edit Patient Note',
                    style: TextStyle(
                      fontSize:
                          AppSizes.fontSizeXl,
                      fontWeight:
                          FontWeight.w700,
                      color: AppColors.ink,
                    ),
                  ),
                ),

                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.close_rounded,
                  ),
                ),
              ],
            ),

            const SizedBox(
              height: AppSizes.spacingMd,
            ),

            TextField(
              controller: _textController,
              autofocus: true,
              minLines: 4,
              maxLines: 7,
              textInputAction:
                  TextInputAction.newline,
              decoration: InputDecoration(
                hintText:
                    'Update this patient note...',
                filled: true,
                fillColor: AppColors.white,
                border: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
                contentPadding:
                    const EdgeInsets.all(
                  AppSizes.spacingLg,
                ),
              ),
            ),

            const SizedBox(
              height: AppSizes.spacingLg,
            ),

            SizedBox(
              width: double.infinity,
              height: 52,
              child: FilledButton(
                onPressed: _save,
                child: const Text(
                  'Update Note',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}