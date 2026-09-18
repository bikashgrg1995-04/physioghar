
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:physioghar/common_widgets/app_button.dart';
import 'package:physioghar/common_widgets/app_date_selector.dart';
import 'package:physioghar/common_widgets/app_error_state.dart';
import 'package:physioghar/common_widgets/app_snackbar.dart';
import 'package:physioghar/core/constants/app_colors.dart';
import 'package:physioghar/core/constants/app_sizes.dart';
import 'package:physioghar/core/extensions/context_extensions.dart';
import 'package:physioghar/core/utils/date_time_utils.dart';
import 'package:physioghar/data/providers/patient_provider.dart';
import 'package:physioghar/data/providers/schedule_provider.dart';
import 'package:physioghar/data/providers/session_provider.dart';
import 'package:physioghar/models/patient.dart';
import 'package:physioghar/models/schedule_slot.dart';
import 'package:physioghar/models/session.dart';
import 'package:physioghar/screens/sessions/widgets/session_list.dart';
import 'package:physioghar/screens/sessions/widgets/session_tabs.dart';
import 'package:physioghar/screens/sessions/widgets/sessions_header.dart';

class SessionsScreen extends ConsumerStatefulWidget {
  const SessionsScreen({super.key});

  @override
  ConsumerState<SessionsScreen> createState() =>
      _SessionsScreenState();
}

class _SessionsScreenState extends ConsumerState<SessionsScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

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

    _tabController = TabController(
      length: _statuses.length,
      vsync: this,
    );

    _tabController.addListener(_onTabChanged);

    Future.microtask(() {
      if (!mounted) {
        return;
      }

      ref
          .read(sessionProvider.notifier)
          .loadSessions(
            status: SessionStatus.requested,
          );
    });
  }

  void _onTabChanged() {
    if (_tabController.indexIsChanging) {
      return;
    }

    final status =
        _statuses[_tabController.index];

    ref
        .read(sessionProvider.notifier)
        .selectStatus(status);
  }

  @override
  void dispose() {
    _tabController.removeListener(
      _onTabChanged,
    );
    _tabController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final sessionState =
        ref.watch(sessionProvider);

    final sessions =
        sessionState.sessions;

    final isLoading =
        sessionState.isLoading;

    final errorMessage =
        sessionState.errorMessage;

    final selectedStatus =
        sessionState.selectedStatus;

    return Scaffold(
      backgroundColor:
          Theme.of(context)
              .scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            SessionsHeader(
              onAdd: _openAddTestSession,
            ),

            const SizedBox(
              height: AppSizes.spacingSm,
            ),

            SessionTabs(
              controller: _tabController,
            ),

            const SizedBox(
              height: AppSizes.spacingSm,
            ),

            Expanded(
              child: Builder(
                builder: (context) {
                  if (isLoading &&
                      sessions.isEmpty) {
                    return const _SessionsLoadingState();
                  }

                  if (errorMessage != null &&
                      sessions.isEmpty) {
                    return AppErrorState(
                      title:
                          'Unable to load sessions',
                      message: errorMessage,
                      onRetry: () {
                        ref
                            .read(
                              sessionProvider
                                  .notifier,
                            )
                            .loadSessions(
                              status:
                                  selectedStatus,
                            );
                      },
                    );
                  }

                  if (sessions.isEmpty) {
                    return _EmptySessionsState(
                      status: selectedStatus,
                    );
                  }

                  return SessionList(
                    sessions: sessions,
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

class _SessionsLoadingState
    extends StatelessWidget {
  const _SessionsLoadingState();

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(
        AppSizes.spacingXl,
        AppSizes.spacingMd,
        AppSizes.spacingXl,
        AppSizes.spacingXl,
      ),
      itemCount: 4,
      separatorBuilder: (_, _) =>
          const SizedBox(
        height: AppSizes.spacingSm,
      ),
      itemBuilder: (_, _) {
        return const _SessionLoadingCard();
      },
    );
  }
}

class _SessionLoadingCard
    extends StatelessWidget {
  const _SessionLoadingCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 180,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius:
            BorderRadius.circular(
          AppSizes.cardRadius,
        ),
        border: Border.all(
          color: AppColors.mist,
        ),
      ),
      padding: const EdgeInsets.all(
        AppSizes.spacingLg,
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Container(
            width: 150,
            height: 20,
            decoration: BoxDecoration(
              color: AppColors.mist,
              borderRadius:
                  BorderRadius.circular(6),
            ),
          ),
          const SizedBox(
            height: AppSizes.spacingLg,
          ),
          Container(
            width: double.infinity,
            height: 14,
            decoration: BoxDecoration(
              color: AppColors.mist,
              borderRadius:
                  BorderRadius.circular(6),
            ),
          ),
          const SizedBox(
            height: AppSizes.spacingSm,
          ),
          Container(
            width: 220,
            height: 14,
            decoration: BoxDecoration(
              color: AppColors.mist,
              borderRadius:
                  BorderRadius.circular(6),
            ),
          ),
          const SizedBox(
            height: AppSizes.spacingSm,
          ),
          Container(
            width: 180,
            height: 14,
            decoration: BoxDecoration(
              color: AppColors.mist,
              borderRadius:
                  BorderRadius.circular(6),
            ),
          ),
        ],
      ),
    );
  }
}

class _AddTestSessionSheet
    extends ConsumerStatefulWidget {
  const _AddTestSessionSheet();

  @override
  ConsumerState<_AddTestSessionSheet>
      createState() =>
          _AddTestSessionSheetState();
}

class _AddTestSessionSheetState
    extends ConsumerState<_AddTestSessionSheet> {
  late DateTime _selectedDate;

  ScheduleSlot? _selectedSlot;

  final List<DateTime> _dates =
      List.generate(
    7,
    (index) => DateTime.now().add(
      Duration(days: index),
    ),
  );

  bool _isCreating = false;

  @override
  void initState() {
    super.initState();

    _selectedDate = _dates.first;

    _loadData();
  }

  Future<void> _loadData() async {
    await Future.wait([
      ref
          .read(patientProvider.notifier)
          .loadPatients(),
      ref
          .read(scheduleProvider.notifier)
          .selectDate(_selectedDate),
    ]);
  }

  void _onDateSelected(
    DateTime date,
  ) {
    setState(() {
      _selectedDate = date;
      _selectedSlot = null;
    });

    ref
        .read(scheduleProvider.notifier)
        .selectDate(date);
  }

  List<ScheduleSlot> _getOpenSlots(
    List<ScheduleSlot> slots,
  ) {
    return slots
        .where(
          (slot) =>
              slot.status ==
              ScheduleSlotStatus.open,
        )
        .toList();
  }

  Future<void> _createTestSession() async {
    if (_isCreating) {
      return;
    }

    final slot = _selectedSlot;

    if (slot == null || slot.id == null) {
      AppSnackBar.showError(
        'Please select an available time slot.',
      );
      return;
    }

    final patients =
        ref.read(patientProvider).patients;

    if (patients.isEmpty) {
      AppSnackBar.showError(
        'No patient is available for testing.',
      );
      return;
    }

    final patient = patients.firstWhere(
      (patient) => patient.id != null,
      orElse: () => Patient(),
    );

    if (patient.id == null) {
      AppSnackBar.showError(
        'No valid patient is available for testing.',
      );
      return;
    }

    setState(() {
      _isCreating = true;
    });

    try {
      final success = await ref
          .read(sessionProvider.notifier)
          .createSession(
            patientId: patient.id!,
            scheduleSlotId: slot.id!,
            treatment: 'Test Session',
            location: 'Test',
          );

      if (!mounted) {
        return;
      }

      if (!success) {
        final errorMessage = ref
            .read(sessionProvider)
            .errorMessage;

        AppSnackBar.showError(
          errorMessage ??
              'Unable to create test session.',
        );

        return;
      }

      Navigator.of(context).pop();

      AppSnackBar.showSuccess(
        'Test session created for '
        '${DateTimeUtils.formatDate(_selectedDate)} '
        'at ${DateTimeUtils.formatTimeString(slot.time)}',
      );
    } finally {
      if (mounted) {
        setState(() {
          _isCreating = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheduleState =
        ref.watch(scheduleProvider);

    final scheduleSlots =
        scheduleState.slots;

    final isScheduleLoading =
        scheduleState.isLoading;

    final scheduleError =
        scheduleState.errorMessage;

    final openSlots =
        _getOpenSlots(scheduleSlots);

    return SafeArea(
      child: Container(
        padding: EdgeInsets.only(
          left: AppSizes.spacingXl,
          right: AppSizes.spacingXl,
          top: AppSizes.spacingXl,
          bottom:
              MediaQuery.of(context)
                      .viewInsets
                      .bottom +
                  AppSizes.spacingXl,
        ),
        decoration:
            const BoxDecoration(
          color: AppColors.cream,
          borderRadius:
              BorderRadius.vertical(
            top: Radius.circular(
              AppSizes.cardRadius,
            ),
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            mainAxisSize:
                MainAxisSize.min,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Add Test Session',
                      style: context
                          .textTheme
                          .headlineLarge,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.of(
                        context,
                      ).pop();
                    },
                    icon: const Icon(
                      Icons.close,
                    ),
                  ),
                ],
              ),

              const SizedBox(
                height: AppSizes.spacingXs,
              ),

              Text(
                'Testing purpose only',
                style: context
                    .textTheme
                    .bodyMedium
                    ?.copyWith(
                      color:
                          AppColors.amber,
                    ),
              ),

              const SizedBox(
                height: AppSizes.spacingXl,
              ),

              Text(
                'Select Date',
                style: context
                    .textTheme
                    .bodyMedium
                    ?.copyWith(
                      fontWeight:
                          FontWeight.w600,
                    ),
              ),

              const SizedBox(
                height: AppSizes.spacingSm,
              ),

              AppDateSelector(
                dates: _dates,
                selectedDate:
                    _selectedDate,
                onDateSelected:
                    _onDateSelected,
              ),

              const SizedBox(
                height: AppSizes.spacingXl,
              ),

              Text(
                'Available Time',
                style: context
                    .textTheme
                    .bodyMedium
                    ?.copyWith(
                      fontWeight:
                          FontWeight.w600,
                    ),
              ),

              const SizedBox(
                height: AppSizes.spacingSm,
              ),

              if (isScheduleLoading)
                const Padding(
                  padding:
                      EdgeInsets.symmetric(
                    vertical:
                        AppSizes.spacingXl,
                  ),
                  child: Center(
                    child:
                        CircularProgressIndicator(),
                  ),
                )
              else if (scheduleError !=
                  null)
                Container(
                  width:
                      double.infinity,
                  padding:
                      const EdgeInsets.all(
                    AppSizes.spacingLg,
                  ),
                  decoration:
                      BoxDecoration(
                    color:
                        AppColors.dangerPale,
                    borderRadius:
                        BorderRadius.circular(
                      AppSizes.cardRadius,
                    ),
                  ),
                  child: Column(
                    children: [
                      const Icon(
                        Icons.error_outline,
                        color:
                            AppColors.danger,
                      ),
                      const SizedBox(
                        height:
                            AppSizes.spacingSm,
                      ),
                      Text(
                        scheduleError,
                        textAlign:
                            TextAlign.center,
                        style: context
                            .textTheme
                            .bodyMedium,
                      ),
                      const SizedBox(
                        height:
                            AppSizes.spacingSm,
                      ),
                      TextButton(
                        onPressed: () {
                          ref
                              .read(
                                scheduleProvider
                                    .notifier,
                              )
                              .selectDate(
                                _selectedDate,
                              );
                        },
                        child:
                            const Text(
                          'Retry',
                        ),
                      ),
                    ],
                  ),
                )
              else if (openSlots.isEmpty)
                Container(
                  width:
                      double.infinity,
                  padding:
                      const EdgeInsets.all(
                    AppSizes.spacingLg,
                  ),
                  decoration:
                      BoxDecoration(
                    color:
                        AppColors.mist,
                    borderRadius:
                        BorderRadius.circular(
                      AppSizes.cardRadius,
                    ),
                  ),
                  child: Text(
                    'No open schedule slots available '
                    'for this date.',
                    textAlign:
                        TextAlign.center,
                    style: context
                        .textTheme
                        .bodyMedium,
                  ),
                )
              else
                Wrap(
                  spacing:
                      AppSizes.spacingSm,
                  runSpacing:
                      AppSizes.spacingSm,
                  children:
                      openSlots.map(
                    (slot) {
                      final isSelected =
                          _selectedSlot
                                  ?.id ==
                              slot.id;

                      return ChoiceChip(
                        label: Text(
                          DateTimeUtils
                              .formatTimeString(
                            slot.time,
                          ),
                          style: context
                              .textTheme
                              .bodyMedium
                              ?.copyWith(
                            color: isSelected
                                ? AppColors
                                    .mist
                                : AppColors
                                    .pine,
                          ),
                        ),
                        selected:
                            isSelected,
                        onSelected:
                            (_) {
                          setState(() {
                            _selectedSlot =
                                slot;
                          });
                        },
                        selectedColor:
                            AppColors.pine,
                        backgroundColor:
                            AppColors.white,
                        side:
                            BorderSide(
                          color: isSelected
                              ? AppColors
                                  .pine
                              : AppColors
                                  .mist,
                        ),
                        labelStyle:
                            context
                                .textTheme
                                .bodyMedium,
                      );
                    },
                  ).toList(),
                ),

              const SizedBox(
                height: AppSizes.spacingXl,
              ),

              AppButton(
                width:
                    double.infinity,
                text: _isCreating
                    ? 'Creating...'
                    : 'Create Test Session',
                icon: _isCreating
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child:
                            CircularProgressIndicator(
                          strokeWidth: 2,
                          color:
                              AppColors.white,
                        ),
                      )
                    : const Icon(
                        Icons.add,
                      ),
                onPressed:
                    _isCreating ||
                            _selectedSlot ==
                                null
                        ? null
                        : _createTestSession,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmptySessionsState
    extends StatelessWidget {
  const _EmptySessionsState({
    required this.status,
  });

  final SessionStatus status;

  @override
  Widget build(BuildContext context) {
    final message = switch (status) {
      SessionStatus.requested =>
        'No session requests yet.',
      SessionStatus.upcoming =>
        'No upcoming sessions.',
      SessionStatus.completed =>
        'No completed sessions.',
      SessionStatus.cancelled =>
        'No cancelled sessions.',
    };

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(
          AppSizes.spacingXl,
        ),
        child: Text(
          message,
          textAlign: TextAlign.center,
          style: Theme.of(context)
              .textTheme
              .bodyMedium,
        ),
      ),
    );
  }
}