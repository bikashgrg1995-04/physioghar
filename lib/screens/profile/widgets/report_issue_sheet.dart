import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:physioghar/common_widgets/app_button.dart';
import 'package:physioghar/common_widgets/app_snackbar.dart';
import 'package:physioghar/common_widgets/app_text_field.dart';
import 'package:physioghar/core/constants/app_colors.dart';
import 'package:physioghar/core/constants/app_sizes.dart';
import 'package:physioghar/core/extensions/context_extensions.dart';
import 'package:physioghar/data/providers/complaint_provider.dart';
import 'package:physioghar/models/complaint.dart';

class ReportIssueSheet extends ConsumerStatefulWidget {
  const ReportIssueSheet({
    super.key,
    this.complaint,
  });

  final Complaint? complaint;

  bool get isEditing => complaint != null;

  @override
  ConsumerState<ReportIssueSheet> createState() =>
      _ReportIssueSheetState();
}

class _ReportIssueSheetState
    extends ConsumerState<ReportIssueSheet> {
  final _formKey = GlobalKey<FormState>();

  final _subjectController = TextEditingController();
  final _descriptionController = TextEditingController();

  String _selectedCategory = 'patient';

  static const Map<String, String> categories = {
    'patient': 'Patient Issue',
    'booking': 'Booking Issue',
    'payment': 'Payment Issue',
    'technical': 'Technical Issue',
    'other': 'Other',
  };

  @override
  void initState() {
    super.initState();

    final complaint = widget.complaint;

    if (complaint != null) {
      _selectedCategory =
          categories.containsKey(complaint.category)
              ? complaint.category!
              : 'other';

      _subjectController.text = complaint.subject ?? '';
      _descriptionController.text =
          complaint.description ?? '';
    }
  }

  @override
  void dispose() {
    _subjectController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _submitComplaint() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final subject = _subjectController.text.trim();
    final description = _descriptionController.text.trim();
    final complaint = widget.complaint;

    final notifier = ref.read(complaintProvider.notifier);

    final result = complaint == null
        ? await notifier.createComplaint(
            category: _selectedCategory,
            subject: subject,
            description: description,
          )
        : await notifier.updateComplaint(
            id: complaint.id!,
            category: _selectedCategory,
            subject: subject,
            description: description,
          );

    if (!mounted) {
      return;
    }

    if (result == null) {
      final errorMessage =
          ref.read(complaintProvider).errorMessage;

      AppSnackBar.showError(
        errorMessage ??
            (widget.isEditing
                ? 'Failed to update complaint.'
                : 'Failed to submit complaint.'),
      );

      return;
    }

    Navigator.of(context).pop();

    AppSnackBar.showSuccess(
      widget.isEditing
          ? 'Report updated successfully.'
          : 'Report submitted successfully.',
    );
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.isEditing;

    final isSubmitting =
        ref.watch(complaintProvider).isSubmitting;

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          AppSizes.spacingLg,
          AppSizes.spacingSm,
          AppSizes.spacingLg,
          MediaQuery.viewInsetsOf(context).bottom +
              AppSizes.spacingLg,
        ),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const _BottomSheetHandle(),

                const SizedBox(
                  height: AppSizes.spacingLg,
                ),

                Text(
                  isEditing
                      ? 'Edit Report'
                      : 'Report an Issue',
                  style: context.textTheme.headlineLarge,
                ),

                const SizedBox(
                  height: AppSizes.spacingXs,
                ),

                Text(
                  isEditing
                      ? 'Update the details of your report.'
                      : 'Tell us about a problem you are facing.',
                  style: context.textTheme.bodyMedium,
                ),

                const SizedBox(
                  height: AppSizes.spacingLg,
                ),

                const _FieldLabel(
                  label: 'CATEGORY',
                ),

                const SizedBox(
                  height: AppSizes.spacingXs,
                ),

                DropdownButtonFormField<String>(
                  initialValue: _selectedCategory,
                  decoration: _inputDecoration(),
                  items: categories.entries.map((entry) {
                    return DropdownMenuItem<String>(
                      value: entry.key,
                      child: Text(
                        entry.value,
                        style:
                            context.textTheme.bodyMedium?.copyWith(
                          color: AppColors.ink,
                        ),
                      ),
                    );
                  }).toList(),
                  onChanged: isSubmitting
                      ? null
                      : (value) {
                          if (value == null) {
                            return;
                          }

                          setState(() {
                            _selectedCategory = value;
                          });
                        },
                ),

                const SizedBox(
                  height: AppSizes.spacingMd,
                ),

                AppTextField(
                  controller: _subjectController,
                  label: 'SUBJECT',
                  hintText: 'Enter the subject',
                  prefixIcon: Icons.subject_outlined,
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    if ((value ?? '').trim().isEmpty) {
                      return 'Please enter a subject';
                    }

                    return null;
                  },
                ),

                const SizedBox(
                  height: AppSizes.spacingMd,
                ),

                AppTextField(
                  controller: _descriptionController,
                  label: 'DESCRIPTION',
                  hintText: 'Describe the issue',
                  prefixIcon: Icons.notes_outlined,
                  keyboardType: TextInputType.multiline,
                  textInputAction: TextInputAction.newline,
                  maxLines: 5,
                  validator: (value) {
                    if ((value ?? '').trim().isEmpty) {
                      return 'Please describe the issue';
                    }

                    return null;
                  },
                ),

                const SizedBox(
                  height: AppSizes.spacingLg,
                ),

                AppButton(
                  width: double.infinity,
                  text: isSubmitting
                      ? isEditing
                          ? 'Updating...'
                          : 'Submitting...'
                      : isEditing
                          ? 'Update Complaint'
                          : 'Submit Complaint',
                  icon: isSubmitting
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppColors.white,
                          ),
                        )
                      : Icon(
                          isEditing
                              ? Icons.save_outlined
                              : Icons.send_outlined,
                          size: 18,
                        ),
                  onPressed:
                      isSubmitting ? null : _submitComplaint,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration() {
    return InputDecoration(
      filled: true,
      fillColor: AppColors.mist,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppSizes.spacingMd,
        vertical: AppSizes.spacingMd,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(
          AppSizes.cardRadius,
        ),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(
          AppSizes.cardRadius,
        ),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(
          AppSizes.cardRadius,
        ),
        borderSide: const BorderSide(
          color: AppColors.pine,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(
          AppSizes.cardRadius,
        ),
        borderSide: const BorderSide(
          color: AppColors.danger,
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(
          AppSizes.cardRadius,
        ),
        borderSide: const BorderSide(
          color: AppColors.danger,
        ),
      ),
    );
  }
}

class _BottomSheetHandle extends StatelessWidget {
  const _BottomSheetHandle();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 42,
        height: 4,
        decoration: BoxDecoration(
          color: AppColors.inkMute.withValues(
            alpha: 0.35,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  const _FieldLabel({
    required this.label,
  });

  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: context.textTheme.labelSmall?.copyWith(
        fontWeight: FontWeight.w600,
        letterSpacing: 0.7,
      ),
    );
  }
}