
import 'package:flutter/material.dart';
import 'package:physioghar/common_widgets/app_button.dart';

import 'package:physioghar/common_widgets/app_snackbar.dart';
import 'package:physioghar/core/constants/app_sizes.dart';
import 'package:physioghar/core/utils/date_time_utils.dart';
import 'package:physioghar/screens/schedule/schedule_controller.dart';

class AddSlotBottomSheet extends StatefulWidget {
  const AddSlotBottomSheet({
    super.key,
    required this.selectedDate,
    required this.controller,
  });

  final DateTime selectedDate;
  final ScheduleController controller;

  @override
  State<AddSlotBottomSheet> createState() =>
      _AddSlotBottomSheetState();
}

class _AddSlotBottomSheetState
    extends State<AddSlotBottomSheet> {
  TimeOfDay? _time;
  bool _isSaving = false;

  Future<void> _pickTime() async {
    final pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime == null || !mounted) {
      return;
    }

    setState(() {
      _time = pickedTime;
    });
  }

  String _formatTime(TimeOfDay time) {
    final hour =
        time.hour.toString().padLeft(2, '0');

    final minute =
        time.minute.toString().padLeft(2, '0');

    return '$hour:$minute:00';
  }

  Future<void> _addSlot() async {
    if (_time == null || _isSaving) {
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      final added =
          await widget.controller.addSlot(
        date: widget.selectedDate,
        time: _formatTime(_time!),
      );

      if (!mounted) {
        return;
      }

      if (added) {
        Navigator.of(context).pop();

        AppSnackBar.showSuccess(
          'Schedule slot added successfully.',
        );

        return;
      }

      AppSnackBar.showError(
        widget.controller.errorMessage ??
            'Unable to add schedule slot.',
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final canAdd =
        _time != null && !_isSaving;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(
          AppSizes.spacingXl,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            Text(
              'Add Available Slot',
              style: Theme.of(context)
                  .textTheme
                  .headlineLarge,
            ),

            const SizedBox(
              height: AppSizes.spacingXs,
            ),

            Text(
              DateTimeUtils.formatFullDate(
                widget.selectedDate,
              ),
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium,
            ),

            const SizedBox(
              height: AppSizes.spacingXl,
            ),

            _TimeSelector(
              value: _time,
              placeholder: 'Choose time',
              enabled: !_isSaving,
              onTap: _pickTime,
            ),

            const SizedBox(
              height: AppSizes.spacingLg,
            ),

            AppButton(
  width: double.infinity,
  text: _isSaving ? 'Adding...' : 'Add Slot',
  onPressed: canAdd ? _addSlot : null,
),
          
          ],
        ),
      ),
    );
  }
}

class _TimeSelector extends StatelessWidget {
  const _TimeSelector({
    required this.value,
    required this.placeholder,
    required this.enabled,
    required this.onTap,
  });

  final TimeOfDay? value;
  final String placeholder;
  final bool enabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: enabled ? onTap : null,
      borderRadius: BorderRadius.circular(
        AppSizes.cardRadius,
      ),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(
          AppSizes.spacingLg,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(
            AppSizes.cardRadius,
          ),
          border: Border.all(
            color: Theme.of(context)
                .colorScheme
                .outline,
          ),
        ),
        child: Row(
          children: [
            const Icon(
              Icons.access_time_outlined,
            ),

            const SizedBox(
              width: AppSizes.spacingMd,
            ),

            Expanded(
              child: Text(
                value == null
                    ? placeholder
                    : value!.format(context),
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge,
              ),
            ),

            const Icon(
              Icons.chevron_right,
            ),
          ],
        ),
      ),
    );
  }
}