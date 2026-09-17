import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:physioghar/common_widgets/app_date_selector.dart';
import 'package:physioghar/core/constants/app_colors.dart';

import 'package:physioghar/core/constants/app_sizes.dart';
import 'package:physioghar/core/utils/date_time_utils.dart';
import 'package:physioghar/models/patient.dart';
import 'package:physioghar/models/schedule_slot.dart';
import 'package:physioghar/models/session.dart';
import 'package:physioghar/screens/patients/patient_controller.dart';
import 'package:physioghar/screens/schedule/schedule_controller.dart';
import 'package:physioghar/screens/sessions/session_controller.dart';
import 'package:physioghar/screens/sessions/widgets/session_list.dart';
import 'package:physioghar/screens/sessions/widgets/session_tabs.dart';
import 'package:physioghar/screens/sessions/widgets/sessions_header.dart';

class SessionsScreen extends StatefulWidget {
  const SessionsScreen({super.key});

  @override
  State<SessionsScreen> createState() => _SessionsScreenState();
}

class _SessionsScreenState extends State<SessionsScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  late final ScheduleController _scheduleController;
  final _controller = sessionController;

  final List<SessionStatus> _statuses = [
    SessionStatus.requested,
    SessionStatus.upcoming,
    SessionStatus.completed,
    SessionStatus.cancelled,
  ];

  void _openAddTestSession() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return const _AddTestSessionSheet();
      },
    );
  }

  @override
  void initState() {
    super.initState();

    _scheduleController = ScheduleController();

    _tabController = TabController(length: _statuses.length, vsync: this);

    _tabController.addListener(_onTabChanged);

    _controller.loadSessions(status: SessionStatus.requested);
  }

  void _onTabChanged() {
    if (_tabController.indexIsChanging) {
      return;
    }

    final status = _statuses[_tabController.index];

    _controller.selectStatus(status);
  }

  @override
  void dispose() {
    _tabController.removeListener(_onTabChanged);
    _tabController.dispose();

    _scheduleController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SessionsHeader(onAdd: _openAddTestSession),

            const SizedBox(height: AppSizes.spacingSm),

            SessionTabs(controller: _tabController),

            const SizedBox(height: AppSizes.spacingSm),

            Expanded(
              child: ValueListenableBuilder<bool>(
                valueListenable: _controller.isLoading,
                builder: (context, isLoading, _) {
                  return ValueListenableBuilder<List<Session>>(
                    valueListenable: _controller.sessions,
                    builder: (context, sessions, _) {
                      if (isLoading && sessions.isEmpty) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (sessions.isEmpty) {
                        return _EmptySessionsState(
                          status: _controller.selectedStatus.value,
                        );
                      }

                      return SessionList(
                        sessions: sessions,
                        controller: _controller,
                        scheduleController: _scheduleController,
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AddTestSessionSheet extends StatefulWidget {
  const _AddTestSessionSheet();

  @override
  State<_AddTestSessionSheet> createState() => _AddTestSessionSheetState();
}

class _AddTestSessionSheetState extends State<_AddTestSessionSheet> {
  late final ScheduleController _scheduleController;
  final _patientController = patientController;
  late DateTime _selectedDate;

  ScheduleSlot? _selectedSlot;

  final List<DateTime> _dates = List.generate(
    7,
    (index) => DateTime.now().add(Duration(days: index)),
  );

  @override
  void initState() {
    super.initState();

    _scheduleController = ScheduleController();
    _selectedDate = _dates.first;

    _loadData();
  }

  Future<void> _loadData() async {
    await Future.wait([
      _patientController.loadPatients(),
      _scheduleController.selectDate(_selectedDate),
    ]);

    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _scheduleController.dispose();
    super.dispose();
  }

  void _onDateSelected(DateTime date) {
    setState(() {
      _selectedDate = date;
      _selectedSlot = null;
    });

    _scheduleController.selectDate(date);
  }

  List<ScheduleSlot> _getOpenSlots(List<ScheduleSlot> slots) {
    return slots.where((slot) {
      return slot.status == ScheduleSlotStatus.open && slot.sessionId == null;
    }).toList();
  }

  Future<void> _createTestSession() async {
    final slot = _selectedSlot;

    if (slot == null || slot.id == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select an available time slot.')),
      );
      return;
    }

    final patients = _patientController.patients.value;

    if (patients.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No patient is available for testing.')),
      );
      return;
    }

    final patient = patients.firstWhere(
      (patient) => patient.id != null,
      orElse: () => Patient(),
    );

    if (patient.id == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No valid patient is available for testing.'),
        ),
      );
      return;
    }

    final success = await sessionController.createSession(
      patientId: patient.id!,
      scheduleSlotId: slot.id!,
      treatment: 'Test Session',
      location: 'Test',
    );

    if (!mounted) return;

    if (!success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Unable to create test session.')),
      );
      return;
    }

    Navigator.of(context).pop();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Test session created for '
          '${DateTimeUtils.formatDate(_selectedDate)} '
          'at ${DateTimeUtils.formatTimeString(slot.time)}',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: EdgeInsets.only(
          left: AppSizes.spacingXl,
          right: AppSizes.spacingXl,
          top: AppSizes.spacingXl,
          bottom: MediaQuery.of(context).viewInsets.bottom + AppSizes.spacingXl,
        ),
        decoration: const BoxDecoration(
          color: AppColors.cream,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Add Test Session',
                      style: GoogleFonts.fraunces(
                        fontSize: AppSizes.fontSizeXl,
                        fontWeight: FontWeight.w600,
                        color: AppColors.ink,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),

              const SizedBox(height: AppSizes.spacingXs),

              Text(
                'Testing purpose only',
                style: GoogleFonts.inter(
                  fontSize: AppSizes.fontSizeSm,
                  fontWeight: FontWeight.w600,
                  color: AppColors.amber,
                ),
              ),

              const SizedBox(height: AppSizes.spacingXl),

              Text(
                'Select Date',
                style: GoogleFonts.inter(
                  fontSize: AppSizes.fontSizeMd,
                  fontWeight: FontWeight.w600,
                  color: AppColors.ink,
                ),
              ),

              const SizedBox(height: AppSizes.spacingSm),

              AppDateSelector(
                dates: _dates,
                selectedDate: _selectedDate,
                onDateSelected: _onDateSelected,
              ),

              const SizedBox(height: AppSizes.spacingXl),

              Text(
                'Available Time',
                style: GoogleFonts.inter(
                  fontSize: AppSizes.fontSizeMd,
                  fontWeight: FontWeight.w600,
                  color: AppColors.ink,
                ),
              ),

              const SizedBox(height: AppSizes.spacingSm),

              ValueListenableBuilder<bool>(
                valueListenable: _scheduleController.isLoading,
                builder: (context, isLoading, _) {
                  if (isLoading) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: AppSizes.spacingXl,
                      ),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }

                  return ValueListenableBuilder<List<ScheduleSlot>>(
                    valueListenable: _scheduleController.slots,
                    builder: (context, slots, _) {
                      final openSlots = _getOpenSlots(slots);

                      if (openSlots.isEmpty) {
                        return Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(AppSizes.spacingLg),
                          decoration: BoxDecoration(
                            color: AppColors.mist,
                            borderRadius: BorderRadius.circular(
                              AppSizes.cardRadius,
                            ),
                          ),
                          child: Text(
                            'No open schedule slots available '
                            'for this date.',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.inter(
                              fontSize: AppSizes.fontSizeSm,
                              color: AppColors.inkMid,
                            ),
                          ),
                        );
                      }

                      return Wrap(
                        spacing: AppSizes.spacingSm,
                        runSpacing: AppSizes.spacingSm,
                        children: openSlots.map((slot) {
                          final isSelected = _selectedSlot?.id == slot.id;

                          return ChoiceChip(
                            label: Text(
                              DateTimeUtils.formatTimeString(slot.time),
                            ),
                            selected: isSelected,
                            onSelected: (_) {
                              setState(() {
                                _selectedSlot = slot;
                              });
                            },
                            selectedColor: AppColors.pine,
                            backgroundColor: AppColors.white,
                            side: BorderSide(
                              color: isSelected
                                  ? AppColors.pine
                                  : AppColors.mist,
                            ),
                            labelStyle: GoogleFonts.inter(
                              fontSize: AppSizes.fontSizeSm,
                              fontWeight: FontWeight.w500,
                              color: isSelected
                                  ? AppColors.white
                                  : AppColors.ink,
                            ),
                          );
                        }).toList(),
                      );
                    },
                  );
                },
              ),

              const SizedBox(height: AppSizes.spacingXl),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _selectedSlot == null ? null : _createTestSession,
                  icon: const Icon(Icons.add),
                  label: const Text('Create Test Session'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmptySessionsState extends StatelessWidget {
  const _EmptySessionsState({required this.status});

  final SessionStatus status;

  @override
  Widget build(BuildContext context) {
    final message = switch (status) {
      SessionStatus.requested => 'No session requests yet.',
      SessionStatus.upcoming => 'No upcoming sessions.',
      SessionStatus.completed => 'No completed sessions.',
      SessionStatus.cancelled => 'No cancelled sessions.',
    };

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.spacingXl),
        child: Text(
          message,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ),
    );
  }
}
