import 'package:flutter/material.dart';

import 'package:physioghar/common_widgets/app_button.dart';
import 'package:physioghar/common_widgets/app_text_field.dart';
import 'package:physioghar/core/constants/app_colors.dart';
import 'package:physioghar/core/constants/app_sizes.dart';
import 'package:physioghar/core/extensions/context_extensions.dart';
import 'package:physioghar/models/session.dart';

void showCompleteSessionBottomSheet(
  BuildContext context, {
  required Session session,
  required Future<void> Function(String notes) onComplete,
}) {
  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) {
      return _CompleteSessionBottomSheet(
        session: session,
        onComplete: onComplete,
      );
    },
  );
}

class _CompleteSessionBottomSheet extends StatefulWidget {
  const _CompleteSessionBottomSheet({
    required this.session,
    required this.onComplete,
  });

  final Session session;
  final Future<void> Function(String notes) onComplete;

  @override
  State<_CompleteSessionBottomSheet> createState() =>
      _CompleteSessionBottomSheetState();
}

class _CompleteSessionBottomSheetState
    extends State<_CompleteSessionBottomSheet> {
  late final TextEditingController _notesController;

  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();

    _notesController = TextEditingController();
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  bool get _canSubmit {
    return _notesController.text.trim().isNotEmpty && !_isSubmitting;
  }

  Future<void> _submit() async {
    final notes = _notesController.text.trim();

    if (notes.isEmpty || _isSubmitting) {
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      await widget.onComplete(notes);

      if (!mounted) {
        return;
      }

      Navigator.of(context).pop();
    } catch (_) {
      // The caller handles the actual error message.
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;

    return Container(
      padding: EdgeInsets.fromLTRB(
        AppSizes.spacingLg,
        AppSizes.spacingLg,
        AppSizes.spacingLg,
        AppSizes.spacingLg + bottomInset,
      ),
      decoration: const BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSizes.cardRadius),
        ),
      ),
      child: SafeArea(
        top: false,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHandle(),

              const SizedBox(height: AppSizes.spacingLg),

              Text('Complete Session', style: context.textTheme.headlineLarge),

              const SizedBox(height: AppSizes.spacingXs),

              Text(
                widget.session.patientName ?? 'Unknown Patient',
                style: context.textTheme.bodyMedium,
              ),

              const SizedBox(height: AppSizes.spacingLg),

              Text(
                'THERAPIST REMARKS',
                style: context.textTheme.labelSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.6,
                  color: AppColors.inkMid,
                ),
              ),

              const SizedBox(height: AppSizes.spacingSm),

              AppTextField(
                controller: _notesController,
                hintText: 'Write session remarks or notes...',
                prefixIcon: null,
                keyboardType: TextInputType.multiline,
                textInputAction: TextInputAction.newline,
                maxLines: 6,
                enabled: !_isSubmitting,
                onChanged: (_) {
                  setState(() {});
                },
              ),
              const SizedBox(height: AppSizes.spacingLg),

              Row(
                children: [
                  Expanded(
                    child: AppButton(
                      text: 'Cancel',
                      variant: AppButtonVariant.secondary,
                      onPressed: _isSubmitting
                          ? null
                          : () {
                              Navigator.of(context).pop();
                            },
                    ),
                  ),

                  const SizedBox(width: AppSizes.spacingMd),

                  Expanded(
                    child: AppButton(
                      text: _isSubmitting ? 'Submitting...' : 'Submit',
                      onPressed: _canSubmit ? _submit : null,
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

  Widget _buildHandle() {
    return Center(
      child: Container(
        width: 40,
        height: 4,
        decoration: BoxDecoration(
          color: AppColors.mist,
          borderRadius: BorderRadius.circular(AppSizes.buttonRadius),
        ),
      ),
    );
  }
}
