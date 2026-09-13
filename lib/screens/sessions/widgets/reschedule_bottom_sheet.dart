import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:physioghar/common_widgets/app_button.dart';
import 'package:physioghar/common_widgets/app_confirmation_dialog.dart';
import 'package:physioghar/common_widgets/app_date_selector.dart';
import 'package:physioghar/core/constants/app_colors.dart';
import 'package:physioghar/core/constants/app_sizes.dart';
import 'package:physioghar/core/utils/date_time_utils.dart';
import 'package:physioghar/models/schedule_slot.dart';
import 'package:physioghar/models/session.dart';
import 'package:physioghar/providers/schedule_provider.dart';
import 'package:physioghar/providers/session_provider.dart';

void showRescheduleBottomSheet(
  BuildContext context, {
  required Session session,
  VoidCallback? onReschedule,
}) {
  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) {
      return _RescheduleBottomSheet(
        session: session,
        onReschedule: onReschedule,
      );
    },
  );
}

class _RescheduleBottomSheet extends ConsumerStatefulWidget {
  const _RescheduleBottomSheet({required this.session, this.onReschedule});

  final Session session;
  final VoidCallback? onReschedule;

  @override
  ConsumerState<_RescheduleBottomSheet> createState() =>
      _RescheduleBottomSheetState();
}

class _RescheduleBottomSheetState
    extends ConsumerState<_RescheduleBottomSheet> {
  late DateTime _selectedDate;
  DateTime? _selectedDateTime;

  @override
  void initState() {
    super.initState();

    final sessionDate = widget.session.dateTime;

    _selectedDate = DateTime(
      sessionDate.year,
      sessionDate.month,
      sessionDate.day,
    );
  }

  @override
  Widget build(BuildContext context) {
    final slots = ref.watch(scheduleProvider);

    final dates = _buildDates();

    final openSlots = slots.where((slot) {
      return slot.status == ScheduleSlotStatus.open &&
          DateTimeUtils.isSameDay(slot.dateTime, _selectedDate) &&
          !slot.dateTime.isBefore(DateTime.now());
    }).toList()..sort((a, b) => a.dateTime.compareTo(b.dateTime));

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
              dates: dates,
              selectedDate: _selectedDate,
              onDateSelected: _onDateSelected,
            ),

            const SizedBox(height: AppSizes.spacingXl),

            _buildSlotSectionLabel(),

            const SizedBox(height: AppSizes.spacingMd),

            Expanded(
              child: openSlots.isEmpty
                  ? _buildEmptyState()
                  : _buildSlotList(openSlots),
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

  void _onDateSelected(DateTime date) {
    setState(() {
      _selectedDate = date;
      _selectedDateTime = null;
    });
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
      '${widget.session.patientName} • '
      '${DateTimeUtils.formatFullDate(widget.session.dateTime)} • '
      '${DateTimeUtils.formatTime(widget.session.dateTime)}',
      style: GoogleFonts.inter(
        fontSize: AppSizes.fontSizeSm,
        color: AppColors.inkMid,
      ),
    );
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
          selected: _selectedDateTime == slot.dateTime,
          onTap: () {
            setState(() {
              _selectedDateTime = slot.dateTime;
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
    return AppButton(
      text: 'Confirm Reschedule',
      onPressed: _selectedDateTime == null ? null : _confirmReschedule,
    );
  }

  Future<void> _confirmReschedule() async {
    final newDateTime = _selectedDateTime;

    if (newDateTime == null) {
      return;
    }

    final confirmed = await showConfirmationDialog(
      context,
      title: 'Reschedule Session?',
      message: 'Are you sure you want to reschedule this session?',
      confirmText: 'Reschedule',
      icon: Icons.event_repeat_outlined,
    );

    if (confirmed != true) {
      return;
    }

    ref
        .read(sessionProvider.notifier)
        .rescheduleSession(widget.session.id, newDateTime);

    if (!mounted) {
      return;
    }

    // Close the reschedule bottom sheet.
    Navigator.of(context).pop();

    widget.onReschedule?.call();
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
              _buildSelectionIndicator(),

              const SizedBox(width: AppSizes.spacingMd),

              Expanded(child: _buildSlotInfo()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSelectionIndicator() {
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

  Widget _buildSlotInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          DateTimeUtils.formatFullDate(slot.dateTime),
          style: GoogleFonts.inter(
            fontSize: AppSizes.fontSizeMd,
            fontWeight: FontWeight.w600,
            color: AppColors.ink,
          ),
        ),
        const SizedBox(height: AppSizes.spacingXs),
        Text(
          DateTimeUtils.formatTime(slot.dateTime),
          style: GoogleFonts.ibmPlexMono(
            fontSize: AppSizes.fontSizeSm,
            fontWeight: FontWeight.w600,
            color: AppColors.pine,
          ),
        ),
      ],
    );
  }
}
