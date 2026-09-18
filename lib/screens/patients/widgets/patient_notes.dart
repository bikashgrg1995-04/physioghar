import 'package:flutter/material.dart';

import 'package:physioghar/common_widgets/app_card.dart';
import 'package:physioghar/common_widgets/app_snackbar.dart';
import 'package:physioghar/core/constants/app_colors.dart';
import 'package:physioghar/core/constants/app_sizes.dart';
import 'package:physioghar/core/extensions/context_extensions.dart';
import 'package:physioghar/core/utils/date_time_utils.dart';
import 'package:physioghar/models/patient_note.dart';
import 'package:physioghar/screens/patients/patient_controller.dart';

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
        Expanded(
          child: Text(
            'Patient Notes',
            style: context.textTheme.headlineLarge?.copyWith(
              fontSize: AppSizes.fontSizeLg,
            ),
          ),
        ),
        const SizedBox(
          width: AppSizes.spacingSm,
        ),
        Text(
          '$noteCount ${noteCount == 1 ? 'note' : 'notes'}',
          style: context.textTheme.bodyMedium?.copyWith(
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
          label: const Text('Add Note'),
        ),
      ],
    );
  }

  Widget _buildEmptyState(
    BuildContext context,
  ) {
    return AppCard(
      padding: const EdgeInsets.all(
        AppSizes.spacingXl,
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
          Text(
            'No notes yet',
            style: context.textTheme.labelLarge?.copyWith(
              color: AppColors.ink,
            ),
          ),
          const SizedBox(
            height: AppSizes.spacingXs,
          ),
          Text(
            'Add a note to keep track of this patient.',
            textAlign: TextAlign.center,
            style: context.textTheme.bodyMedium?.copyWith(
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
            label: const Text('Add Note'),
          ),
        ],
      ),
    );
  }

  Widget _buildNotesList(
    BuildContext context,
    List<PatientNote> notes,
  ) {
    return AppCard(
      padding: EdgeInsets.zero,
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
                indent: AppSizes.spacingLg,
                endIndent: AppSizes.spacingLg,
                color: AppColors.mist,
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
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return _NoteDetailsBottomSheet(
          note: note,
          onEdit: () {
            Navigator.of(context).pop();

            _showEditNoteSheet(
              context,
              note,
            );
          },
          onDelete: () {
            Navigator.of(context).pop();

            _confirmDeleteNote(
              context,
              note,
            );
          },
        );
      },
    );
  }

  void _showAddNoteSheet(
    BuildContext context,
  ) {
    showModalBottomSheet<void>(
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
              Navigator.of(context).pop();
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
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return _EditNoteBottomSheet(
          note: note,
          onSave: (content) async {
            if (note.id == null) {
              return;
            }

            final success = await controller.editNote(
              patientId: patientId,
              noteId: note.id!,
              content: content,
            );

            if (success && context.mounted) {
              Navigator.of(context).pop();
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
    if (note.id == null) {
      return;
    }

    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Delete Note?'),
          content: const Text(
            'Are you sure you want to delete this note? '
            'This action cannot be undone.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              child: const Text('Cancel'),
            ),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.danger,
              ),
              onPressed: () async {
                Navigator.of(dialogContext).pop();

                await controller.deleteNote(
                  patientId: patientId,
                  noteId: note.id!,
                );
              },
              child: const Text('Delete'),
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
            top: Radius.circular(
              AppSizes.cardRadius,
            ),
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
              const _BottomSheetHandle(),

              const SizedBox(
                height: AppSizes.spacingXl,
              ),

              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Patient Note',
                      style: context.textTheme.headlineLarge,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    tooltip: 'Close',
                    icon: const Icon(
                      Icons.close_rounded,
                    ),
                  ),
                ],
              ),

              const SizedBox(
                height: AppSizes.spacingMd,
              ),

              AppCard(
                child: Text(
                  note.content?.trim() ?? '',
                  style: context.textTheme.bodyMedium?.copyWith(
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
                      'Added ${DateTimeUtils.formatDate(
                        note.createdAt!,
                      )}',
                      style: context.textTheme.bodyMedium?.copyWith(
                        fontSize: AppSizes.fontSizeSm,
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
                      label: const Text('Edit'),
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
                      label: const Text('Delete'),
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

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(
            AppSizes.spacingLg,
          ),
          child: Row(
            children: [
              Container(
                width: AppSizes.minTapTarget,
                height: AppSizes.minTapTarget,
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
                      style: context.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.ink,
                        height: 1.35,
                      ),
                    ),

                    if (note.createdAt != null) ...[
                      const SizedBox(
                        height: AppSizes.spacingXs,
                      ),
                      Text(
                        DateTimeUtils.formatDate(
                          note.createdAt!,
                        ),
                        style: context.textTheme.bodyMedium?.copyWith(
                          fontSize:
                              AppSizes.fontSizeXs,
                          color: AppColors.inkMute,
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
      ),
    );
  }
}

// ============================================================
// ADD NOTE BOTTOM SHEET
// ============================================================

class _AddNoteBottomSheet extends StatefulWidget {
  const _AddNoteBottomSheet({
    required this.onSave,
  });

  final Future<void> Function(
    String content,
  ) onSave;

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

    _textController =
        TextEditingController();
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
      AppSnackBar.showError(
        'Please enter a note.',
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
            top: Radius.circular(
              AppSizes.cardRadius,
            ),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            const _BottomSheetHandle(),

            const SizedBox(
              height: AppSizes.spacingXl,
            ),

            Row(
              children: [
                Expanded(
                  child: Text(
                    'Add Patient Note',
                    style: context.textTheme.headlineLarge,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  tooltip: 'Close',
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
                      BorderRadius.circular(
                    AppSizes.cardRadius,
                  ),
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
              height: AppSizes.minTapTarget,
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
  final Future<void> Function(
    String content,
  ) onSave;

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
      AppSnackBar.showError(
        'Please enter a note.',
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
            top: Radius.circular(
              AppSizes.cardRadius,
            ),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            const _BottomSheetHandle(),

            const SizedBox(
              height: AppSizes.spacingXl,
            ),

            Row(
              children: [
                Expanded(
                  child: Text(
                    'Edit Patient Note',
                    style: context.textTheme.headlineLarge,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  tooltip: 'Close',
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
                      BorderRadius.circular(
                    AppSizes.cardRadius,
                  ),
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
              height: AppSizes.minTapTarget,
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

// ============================================================
// BOTTOM SHEET HANDLE
// ============================================================

class _BottomSheetHandle extends StatelessWidget {
  const _BottomSheetHandle();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 40,
        height: 4,
        decoration: BoxDecoration(
          color: AppColors.inkMute,
          borderRadius:
              BorderRadius.circular(10),
        ),
      ),
    );
  }
}