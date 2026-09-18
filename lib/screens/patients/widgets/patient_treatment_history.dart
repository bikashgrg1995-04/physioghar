
import 'package:flutter/material.dart';

import 'package:physioghar/common_widgets/app_card.dart';
import 'package:physioghar/common_widgets/app_loading.dart';
import 'package:physioghar/core/constants/app_colors.dart';
import 'package:physioghar/core/constants/app_sizes.dart';
import 'package:physioghar/core/extensions/context_extensions.dart';
import 'package:physioghar/models/session.dart';
import 'package:physioghar/screens/sessions/session_controller.dart';

class PatientTreatmentHistory extends StatefulWidget {
  const PatientTreatmentHistory({
    super.key,
    required this.patientId,
  });

  final int patientId;

  @override
  State<PatientTreatmentHistory> createState() =>
      _PatientTreatmentHistoryState();
}

class _PatientTreatmentHistoryState
    extends State<PatientTreatmentHistory> {
  late final SessionController _controller;

  @override
  void initState() {
    super.initState();

    _controller = SessionController();

    _controller.loadSessions(
      status: SessionStatus.completed,
      patientId: widget.patientId,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: _controller.isLoading,
      builder: (
        context,
        isLoading,
        _,
      ) {
        if (isLoading) {
          return const AppLoading();
        }

        return ValueListenableBuilder<List<Session>>(
          valueListenable: _controller.sessions,
          builder: (
            context,
            sessions,
            _,
          ) {
            if (sessions.isEmpty) {
              return _TreatmentHistoryEmptyState();
            }

            final completedSessions = sessions
                .where(
                  (session) =>
                      session.status ==
                      SessionStatus.completed,
                )
                .toList();

            completedSessions.sort(
              (a, b) {
                final aDate = a.scheduleDate;
                final bDate = b.scheduleDate;

                if (aDate == null) return 1;
                if (bDate == null) return -1;

                return bDate.compareTo(aDate);
              },
            );

            if (completedSessions.isEmpty) {
              return _TreatmentHistoryEmptyState();
            }

            return Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Treatment History',
                        style: context.textTheme.headlineLarge
                            ?.copyWith(
                          fontSize:
                              AppSizes.fontSizeLg,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: AppSizes.spacingSm,
                    ),
                    Text(
                      '${completedSessions.length} sessions',
                      style: context.textTheme.bodyMedium
                          ?.copyWith(
                        fontSize:
                            AppSizes.fontSizeSm,
                        color: AppColors.inkMute,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: AppSizes.spacingSm,
                ),
                AppCard(
                  padding: EdgeInsets.zero,
                  child: Column(
                    children: [
                      for (
                        int i = 0;
                        i < completedSessions.length;
                        i++
                      ) ...[
                        _TreatmentHistoryListItem(
                          session:
                              completedSessions[i],
                          onTap: () {
                            _showSessionDetails(
                              context,
                              completedSessions[i],
                            );
                          },
                        ),
                        if (
                          i !=
                              completedSessions.length -
                                  1
                        )
                          const Divider(
                            height: 1,
                            indent:
                                AppSizes.spacingLg,
                            endIndent:
                                AppSizes.spacingLg,
                            color: AppColors.mist,
                          ),
                      ],
                    ],
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showSessionDetails(
    BuildContext context,
    Session session,
  ) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return _SessionDetailsBottomSheet(
          session: session,
        );
      },
    );
  }
}

class _TreatmentHistoryEmptyState
    extends StatelessWidget {
  const _TreatmentHistoryEmptyState();

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(
        AppSizes.spacingXl,
      ),
      child: Column(
        children: [
          const Icon(
            Icons.history_rounded,
            size: 32,
            color: AppColors.inkMute,
          ),
          const SizedBox(
            height: AppSizes.spacingSm,
          ),
          Text(
            'No treatment history yet',
            style: context.textTheme.labelLarge
                ?.copyWith(
              color: AppColors.ink,
            ),
          ),
        ],
      ),
    );
  }
}

class _SessionDetailsBottomSheet
    extends StatelessWidget {
  const _SessionDetailsBottomSheet({
    required this.session,
  });

  final Session session;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        constraints: BoxConstraints(
          maxHeight:
              MediaQuery.sizeOf(context).height * 0.8,
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
                  Expanded(
                    child: Text(
                      'Treatment Details',
                      style: context.textTheme
                          .headlineLarge,
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
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      session.treatment
                                  ?.trim()
                                  .isNotEmpty ==
                              true
                          ? session.treatment!
                          : 'Treatment Session',
                      style: context.textTheme
                          .labelLarge
                          ?.copyWith(
                        fontSize:
                            AppSizes.fontSizeLg,
                        color: AppColors.ink,
                      ),
                    ),
                    const SizedBox(
                      height: AppSizes.spacingSm,
                    ),
                    Container(
                      padding:
                          const EdgeInsets.symmetric(
                        horizontal: AppSizes.spacingMd,
                        vertical: AppSizes.spacingXs,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.pinePale,
                        borderRadius:
                            BorderRadius.circular(
                          AppSizes.buttonRadius,
                        ),
                      ),
                      child: Row(
                        mainAxisSize:
                            MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons
                                .check_circle_outline,
                            size: 14,
                            color:
                                AppColors.pine,
                          ),
                          const SizedBox(
                            width: AppSizes.spacingXs,
                          ),
                          Text(
                            'COMPLETED',
                            style: context.textTheme
                                .labelSmall
                                ?.copyWith(
                              color:
                                  AppColors.pine,
                              fontWeight:
                                  FontWeight.w700,
                              letterSpacing: 0.8,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: AppSizes.spacingMd,
              ),
              _DetailRow(
                icon:
                    Icons.calendar_today_outlined,
                label: 'Date',
                value: _formatDate(
                  session.scheduleDate,
                ),
              ),
              _DetailRow(
                icon:
                    Icons.access_time_outlined,
                label: 'Time',
                value:
                    session.scheduleTime ??
                        'Not available',
              ),
              _DetailRow(
                icon:
                    Icons.location_on_outlined,
                label: 'Location',
                value:
                    session.location
                                ?.trim()
                                .isNotEmpty ==
                            true
                        ? session.location!
                        : 'Not available',
              ),
              if (
                session.notes
                        ?.trim()
                        .isNotEmpty ==
                    true
              ) ...[
                const SizedBox(
                  height: AppSizes.spacingLg,
                ),
                Text(
                  'Session Notes',
                  style: context.textTheme
                      .labelLarge
                      ?.copyWith(
                    color: AppColors.ink,
                  ),
                ),
                const SizedBox(
                  height: AppSizes.spacingSm,
                ),
                AppCard(
                  child: Text(
                    session.notes!,
                    style: context.textTheme
                        .bodyMedium
                        ?.copyWith(
                      height: 1.5,
                      color:
                          AppColors.inkMid,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  static String _formatDate(
    DateTime? date,
  ) {
    if (date == null) {
      return 'Not available';
    }

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

    return '${date.day} '
        '${months[date.month - 1]} '
        '${date.year}';
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: AppSizes.spacingMd,
      ),
      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 20,
            color: AppColors.pine,
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
                  label,
                  style: context.textTheme.labelSmall
                      ?.copyWith(
                    color: AppColors.inkMute,
                  ),
                ),
                const SizedBox(
                  height: AppSizes.spacingTiny,
                ),
                Text(
                  value,
                  style: context.textTheme.bodyMedium
                      ?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.ink,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TreatmentHistoryListItem
    extends StatelessWidget {
  const _TreatmentHistoryListItem({
    required this.session,
    required this.onTap,
  });

  final Session session;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(
        AppSizes.spacingLg,
      ),
      onTap: onTap,
      borderRadius: BorderRadius.circular(
        AppSizes.cardRadius,
      ),
      child: Row(
        children: [
          Container(
            width: AppSizes.minTapTarget,
            height: AppSizes.minTapTarget,
            decoration: BoxDecoration(
              color: AppColors.pinePale,
              borderRadius:
                  BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.medical_services_outlined,
              color: AppColors.pine,
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
                  session.treatment
                              ?.trim()
                              .isNotEmpty ==
                          true
                      ? session.treatment!
                      : 'Treatment Session',
                  maxLines: 1,
                  overflow:
                      TextOverflow.ellipsis,
                  style: context.textTheme.labelLarge
                      ?.copyWith(
                    color: AppColors.ink,
                  ),
                ),
                const SizedBox(
                  height: AppSizes.spacingXs,
                ),
                Text(
                  _formatDate(
                    session.scheduleDate,
                  ),
                  style: context.textTheme.bodyMedium
                      ?.copyWith(
                    fontSize:
                        AppSizes.fontSizeSm,
                    color: AppColors.inkMid,
                  ),
                ),
                if (session.scheduleTime !=
                    null) ...[
                  const SizedBox(
                    height:
                        AppSizes.spacingTiny,
                  ),
                  Text(
                    session.scheduleTime!,
                    style: context.textTheme.bodyMedium
                        ?.copyWith(
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
    );
  }

  static String _formatDate(
    DateTime? date,
  ) {
    if (date == null) {
      return 'Date unavailable';
    }

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

    return '${date.day} '
        '${months[date.month - 1]} '
        '${date.year}';
  }
}