import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:physioghar/common_widgets/app_confirmation_dialog.dart';
import 'package:physioghar/common_widgets/app_snackbar.dart';
import 'package:physioghar/core/constants/app_colors.dart';
import 'package:physioghar/core/constants/app_sizes.dart';
import 'package:physioghar/providers/patient_provider.dart';
import 'package:physioghar/screens/patients/widgets/note_editor_dialog.dart';
import 'package:physioghar/screens/patients/widgets/patient_condition_card.dart';
import 'package:physioghar/screens/patients/widgets/patient_header.dart';
import 'package:physioghar/screens/patients/widgets/patient_info_card.dart';
import 'package:physioghar/screens/patients/widgets/patient_notes_section.dart';
import 'package:physioghar/screens/patients/widgets/previous_sessions_card.dart';
import 'package:physioghar/screens/patients/widgets/treatment_history_card.dart';

class PatientDetailScreen extends ConsumerWidget {
  const PatientDetailScreen({super.key, required this.patientId});

  final String patientId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final patient = ref.watch(
      patientProvider.select((patients) {
        for (final patient in patients) {
          if (patient.id == patientId) {
            return patient;
          }
        }

        return null;
      }),
    );

    if (patient == null) {
      return Scaffold(
        backgroundColor: AppColors.cream,
        appBar: AppBar(title: const Text('Patient Details')),
        body: const Center(child: Text('Patient not found')),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(title: const Text('Patient Details')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSizes.spacingXl),
          child: Column(
            children: [
              PatientHeader(patient: patient),
              const SizedBox(height: AppSizes.spacingMd),
              PatientInfoCard(patient: patient),
              const SizedBox(height: AppSizes.spacingMd),
              PatientConditionCard(patient: patient),
              const SizedBox(height: AppSizes.spacingMd),
              TreatmentHistoryCard(patient: patient),
              const SizedBox(height: AppSizes.spacingMd),
              PreviousSessionsCard(patient: patient),
              const SizedBox(height: AppSizes.spacingMd),

              PatientNotesSection(
                patient: patient,
                onAddNote: () async {
                  final content = await showDialog<String>(
                    context: context,
                    builder: (_) => const NoteEditorDialog(),
                  );

                  if (content == null || content.isEmpty) {
                    return;
                  }

                  ref
                      .read(patientProvider.notifier)
                      .addNote(patientId: patient.id, content: content);

                  if (context.mounted) {
                    AppSnackBar.showSuccess(context, 'Note added successfully');
                  }
                },
                onEditNote: (note) async {
                  final content = await showDialog<String>(
                    context: context,
                    builder: (_) => NoteEditorDialog(note: note),
                  );

                  if (content == null || content.isEmpty) {
                    return;
                  }

                  ref
                      .read(patientProvider.notifier)
                      .updateNote(
                        patientId: patient.id,
                        noteId: note.id,
                        content: content,
                      );

                  if (context.mounted) {
                    AppSnackBar.showSuccess(
                      context,
                      'Note updated successfully',
                    );
                  }
                },
                onDeleteNote: (note) async {
                  final confirmed = await showConfirmationDialog(
                    context,
                    title: 'Delete Note?',
                    message: 'Are you sure you want to delete this note?',
                    confirmText: 'Delete',
                    isDestructive: true,
                    icon: Icons.delete_outline,
                  );

                  if (confirmed == true) {
                    ref
                        .read(patientProvider.notifier)
                        .deleteNote(patientId: patient.id, noteId: note.id);

                    if (context.mounted) {
                      AppSnackBar.showSuccess(
                        context,
                        'Note deleted successfully',
                      );
                    }
                  }
                },
              ),
            
            ],
          ),
        ),
      ),
    );
  }
}
