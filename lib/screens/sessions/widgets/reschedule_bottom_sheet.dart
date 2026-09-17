import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:physioghar/common_widgets/app_button.dart';
import 'package:physioghar/common_widgets/app_confirmation_dialog.dart';
import 'package:physioghar/common_widgets/app_date_selector.dart';
import 'package:physioghar/common_widgets/app_snackbar.dart';
import 'package:physioghar/core/constants/app_colors.dart';
import 'package:physioghar/core/constants/app_sizes.dart';
import 'package:physioghar/core/utils/date_time_utils.dart';
import 'package:physioghar/models/schedule_slot.dart';
import 'package:physioghar/models/session.dart';
import 'package:physioghar/screens/schedule/schedule_controller.dart';
import 'package:physioghar/screens/sessions/session_controller.dart';

Future<bool> showRescheduleBottomSheet(
  BuildContext context, {
  required Session session,
  required SessionController sessionController,
  required ScheduleController scheduleController,
}) async {
  final result = await showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) {
      return _RescheduleBottomSheet(
        session: session,
        sessionController: sessionController,
        scheduleController: scheduleController,
      );
    },
  );

  return result ?? false;
}

class _RescheduleBottomSheet extends StatefulWidget {
  const _RescheduleBottomSheet({
    required this.session,
    required this.sessionController,
    required this.scheduleController,
  });

  final Session session;
  final SessionController sessionController;
  final ScheduleController scheduleController;

  @override
  State<_RescheduleBottomSheet> createState() => _RescheduleBottomSheetState();
}

class _RescheduleBottomSheetState extends State<_RescheduleBottomSheet> {
  late DateTime _selectedDate;

  ScheduleSlot? _selectedSlot;

  @override
  void initState() {
    super.initState();

    final sessionDate = widget.session.scheduleDate;

    final today = DateTime.now();

    final startDate = DateTime(today.year, today.month, today.day);

    _selectedDate = sessionDate == null
        ? startDate
        : DateTime(sessionDate.year, sessionDate.month, sessionDate.day);

    if (_selectedDate.isBefore(startDate)) {
      _selectedDate = startDate;
    }

    widget.scheduleController.loadSchedules(date: _selectedDate);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        width: double.infinity,
        constraints: BoxConstraints(
          maxHeight: MediaQuery.sizeOf(context).height * 0.85,
        ),
        padding: const EdgeInsets.fromLTRB(
          AppSizes.spacingLg,
          AppSizes.spacingMd,
          AppSizes.spacingLg,
          AppSizes.spacingLg,
        ),
        decoration: const BoxDecoration(
          color: AppColors.cream,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppSizes.cardRadius),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHandle(),

            const SizedBox(height: AppSizes.spacingLg),

            _buildHeader(),

            const SizedBox(height: AppSizes.spacingXs),

            _buildCurrentSchedule(),

            const SizedBox(height: AppSizes.spacingXl),

            _buildDateSectionLabel(),

            const SizedBox(height: AppSizes.spacingMd),

            AppDateSelector(
              dates: _buildDates(),
              selectedDate: _selectedDate,
              onDateSelected: _onDateSelected,
            ),

            const SizedBox(height: AppSizes.spacingXl),

            _buildSlotSectionLabel(),

            const SizedBox(height: AppSizes.spacingMd),

            Expanded(
              child: ValueListenableBuilder<List<ScheduleSlot>>(
                valueListenable: widget.scheduleController.slots,
                builder: (context, slots, _) {
                  final openSlots = _getOpenSlots(slots);

                  if (openSlots.isEmpty) {
                    return _buildEmptyState();
                  }

                  return _buildSlotList(openSlots);
                },
              ),
            ),

            const SizedBox(height: AppSizes.spacingLg),

            _buildConfirmButton(),
          ],
        ),
      ),
    );
  }

  List<DateTime> _buildDates() {
    final today = DateTime.now();

    final startDate = DateTime(today.year, today.month, today.day);

    return List.generate(7, (index) => startDate.add(Duration(days: index)));
  }

  List<ScheduleSlot> _getOpenSlots(List<ScheduleSlot> slots) {
    final now = DateTime.now();

    final result = slots.where((slot) {
      if (slot.status != ScheduleSlotStatus.open) {
        return false;
      }

      final slotDate = slot.date;

      if (slotDate == null ||
          !DateTimeUtils.isSameDay(slotDate, _selectedDate)) {
        return false;
      }

      final slotDateTime = _combineDateAndTime(slotDate, slot.time);

      if (slotDateTime == null) {
        return false;
      }

      // Do not show past times.
      if (!slotDateTime.isAfter(now)) {
        return false;
      }

      // Do not show the current session's
      // existing slot as a new option.
      if (slot.id == widget.session.scheduleSlotId) {
        return false;
      }

      return true;
    }).toList();

    result.sort(
      (a, b) => _timeToMinutes(a.time).compareTo(_timeToMinutes(b.time)),
    );

    return result;
  }

  DateTime? _combineDateAndTime(DateTime date, String? value) {
    if (value == null || value.trim().isEmpty) {
      return null;
    }

    final parts = value.split(':');

    if (parts.length < 2) {
      return null;
    }

    final hour = int.tryParse(parts[0]);

    final minute = int.tryParse(parts[1]);

    if (hour == null ||
        minute == null ||
        hour < 0 ||
        hour > 23 ||
        minute < 0 ||
        minute > 59) {
      return null;
    }

    return DateTime(date.year, date.month, date.day, hour, minute);
  }

  int _timeToMinutes(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 999999;
    }

    final parts = value.split(':');

    if (parts.length < 2) {
      return 999999;
    }

    final hour = int.tryParse(parts[0]);

    final minute = int.tryParse(parts[1]);

    if (hour == null ||
        minute == null ||
        hour < 0 ||
        hour > 23 ||
        minute < 0 ||
        minute > 59) {
      return 999999;
    }

    return hour * 60 + minute;
  }

  void _onDateSelected(DateTime date) {
    setState(() {
      _selectedDate = date;
      _selectedSlot = null;
    });

    widget.scheduleController.loadSchedules(date: date);
  }

  Widget _buildHandle() {
    return Center(
      child: Container(
        width: 40,
        height: 4,
        decoration: BoxDecoration(
          color: AppColors.inkMute,
          borderRadius: BorderRadius.circular(AppSizes.buttonRadius),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Text(
      'Reschedule Session',
      style: GoogleFonts.fraunces(
        fontSize: AppSizes.fontSizeXl,
        fontWeight: FontWeight.w600,
        color: AppColors.ink,
      ),
    );
  }

  Widget _buildCurrentSchedule() {
    return Text(
      '${widget.session.patientName ?? 'Unknown Patient'} • '
      '${_currentDateText()} • '
      '${_formatTime(widget.session.scheduleTime)}',
      style: GoogleFonts.inter(
        fontSize: AppSizes.fontSizeSm,
        color: AppColors.inkMid,
      ),
    );
  }

  String _currentDateText() {
    final date = widget.session.scheduleDate;

    if (date == null) {
      return 'Date not provided';
    }

    return DateTimeUtils.formatFullDate(date);
  }

  Widget _buildDateSectionLabel() {
    return Text(
      'SELECT DATE',
      style: GoogleFonts.ibmPlexMono(
        fontSize: AppSizes.fontSizeXs,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.7,
        color: AppColors.inkMid,
      ),
    );
  }

  Widget _buildSlotSectionLabel() {
    return Text(
      'AVAILABLE SLOTS',
      style: GoogleFonts.ibmPlexMono(
        fontSize: AppSizes.fontSizeXs,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.7,
        color: AppColors.inkMid,
      ),
    );
  }

  Widget _buildSlotList(List<ScheduleSlot> openSlots) {
    return ListView.separated(
      itemCount: openSlots.length,
      separatorBuilder: (_, _) => const SizedBox(height: AppSizes.spacingSm),
      itemBuilder: (context, index) {
        final slot = openSlots[index];

        return _SlotOption(
          slot: slot,
          selected: _selectedSlot?.id == slot.id,
          onTap: () {
            setState(() {
              _selectedSlot = slot;
            });
          },
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.spacingXl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.event_busy_outlined,
              size: 40,
              color: AppColors.inkMute,
            ),
            const SizedBox(height: AppSizes.spacingMd),
            Text(
              'No available slots',
              style: GoogleFonts.fraunces(
                fontSize: AppSizes.fontSizeLg,
                fontWeight: FontWeight.w600,
                color: AppColors.ink,
              ),
            ),
            const SizedBox(height: AppSizes.spacingXs),
            Text(
              'There are no open slots available '
              'for this date. Please select another date.',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: AppSizes.fontSizeMd,
                color: AppColors.inkMid,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConfirmButton() {
    return ValueListenableBuilder<bool>(
      valueListenable: widget.sessionController.isUpdating,
      builder: (context, isUpdating, _) {
        return AppButton(
          width: double.infinity,
          text: isUpdating ? 'Rescheduling...' : 'Confirm Reschedule',
          onPressed: _selectedSlot == null || isUpdating
              ? null
              : _confirmReschedule,
        );
      },
    );
  }

  Future<void> _confirmReschedule() async {
    final newSlot = _selectedSlot;

    if (newSlot == null || newSlot.id == null) {
      return;
    }

    final confirmed = await showConfirmationDialog(
      context,
      title: 'Reschedule Session?',
      message: 'Are you sure you want to reschedule this session to the selected time?',
      confirmText: 'Reschedule',
      icon: Icons.event_repeat_outlined,
    );

    if (confirmed != true || !mounted) {
      return;
    }

    final success = await widget.sessionController.rescheduleSession(
      sessionId: widget.session.id!,
      scheduleSlotId: newSlot.id!,
    );

    if (!mounted) {
      return;
    }

    if (success) {
      Navigator.of(context).pop(true);

      AppSnackBar.showSuccess('Session rescheduled successfully.');
    } else {
      AppSnackBar.showError(
        widget.sessionController.errorMessage ??
            'Unable to reschedule session.',
      );
    }
  }

  String _formatTime(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Time not provided';
    }

    final parts = value.split(':');

    if (parts.length < 2) {
      return value;
    }

    final hour = int.tryParse(parts[0]);

    final minute = int.tryParse(parts[1]);

    if (hour == null ||
        minute == null ||
        hour < 0 ||
        hour > 23 ||
        minute < 0 ||
        minute > 59) {
      return value;
    }

    final time = TimeOfDay(hour: hour, minute: minute);

    final hourText = time.hourOfPeriod.toString().padLeft(2, '0');

    final minuteText = minute.toString().padLeft(2, '0');

    final period = time.period == DayPeriod.am ? 'AM' : 'PM';

    return '$hourText:$minuteText $period';
  }
}

class _SlotOption extends StatelessWidget {
  const _SlotOption({
    required this.slot,
    required this.selected,
    required this.onTap,
  });

  final ScheduleSlot slot;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(AppSizes.cardRadius),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSizes.cardRadius),
        child: Container(
          constraints: const BoxConstraints(minHeight: AppSizes.minTapTarget),
          padding: const EdgeInsets.all(AppSizes.spacingMd),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppSizes.cardRadius),
            border: Border.all(
              color: selected ? AppColors.pine : AppColors.mist,
              width: selected ? 2 : 1,
            ),
          ),
          child: Row(
            children: [
              _SelectionIndicator(selected: selected),

              const SizedBox(width: AppSizes.spacingMd),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      slot.date == null
                          ? 'Date not provided'
                          : DateTimeUtils.formatFullDate(slot.date!),
                      style: GoogleFonts.inter(
                        fontSize: AppSizes.fontSizeMd,
                        fontWeight: FontWeight.w600,
                        color: AppColors.ink,
                      ),
                    ),
                    const SizedBox(height: AppSizes.spacingXs),
                    Text(
                      _formatSlotTime(slot.time),
                      style: GoogleFonts.ibmPlexMono(
                        fontSize: AppSizes.fontSizeSm,
                        fontWeight: FontWeight.w600,
                        color: AppColors.pine,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatSlotTime(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Time not provided';
    }

    final parts = value.split(':');

    if (parts.length < 2) {
      return value;
    }

    final hour = int.tryParse(parts[0]);

    final minute = int.tryParse(parts[1]);

    if (hour == null || minute == null) {
      return value;
    }

    final time = TimeOfDay(hour: hour, minute: minute);

    final hourText = time.hourOfPeriod.toString().padLeft(2, '0');

    final minuteText = minute.toString().padLeft(2, '0');

    final period = time.period == DayPeriod.am ? 'AM' : 'PM';

    return '$hourText:$minuteText $period';
  }
}

class _SelectionIndicator extends StatelessWidget {
  const _SelectionIndicator({required this.selected});

  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 22,
      height: 22,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: selected ? AppColors.pine : AppColors.inkMute,
          width: 2,
        ),
      ),
      child: selected
          ? Center(
              child: Container(
                width: 10,
                height: 10,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.pine,
                ),
              ),
            )
          : null,
    );
  }
}
