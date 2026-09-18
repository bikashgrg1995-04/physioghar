
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shimmer/shimmer.dart';

import 'package:physioghar/core/constants/app_colors.dart';
import 'package:physioghar/core/constants/app_sizes.dart';
import 'package:physioghar/core/utils/responsive_utils.dart';
import 'package:physioghar/data/providers/dashboard_provider.dart';
import 'package:physioghar/data/providers/session_provider.dart';
import 'package:physioghar/data/providers/therapist_provider.dart';
import 'package:physioghar/models/session.dart';
import 'package:physioghar/screens/dashboard/widgets/dashboard_session_section.dart';
import 'package:physioghar/screens/dashboard/widgets/dashboard_summary_card.dart';
import 'package:physioghar/screens/dashboard/widgets/therapist_header.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() =>
      _DashboardScreenState();
}

class _DashboardScreenState
    extends ConsumerState<DashboardScreen> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      if (!mounted) {
        return;
      }

      ref
          .read(dashboardProvider.notifier)
          .loadDashboard();
    });
  }

  @override
  Widget build(BuildContext context) {
    final dashboardState =
        ref.watch(dashboardProvider);

    final sessionState =
        ref.watch(sessionProvider);

    // Watch therapist provider so the dashboard rebuilds
    // when therapist data or availability changes.
    ref.watch(therapistProvider);

    final todaySessions =
        _todaySessions(sessionState.allSessions);

    final upcomingSessions =
        _upcomingSessions(sessionState.allSessions);

    final upcomingRequests =
        _upcomingRequests(sessionState.allSessions);

    final completedSessions =
        _completedSessions(sessionState.allSessions);

    final listHeight =
        ResponsiveUtils.isMobile(context)
            ? ResponsiveUtils.height(context) * 0.28
            : ResponsiveUtils.height(context) * 0.25;

    if (dashboardState.isLoading) {
      return const SafeArea(
        child: Padding(
          padding: EdgeInsets.all(
            AppSizes.spacingXl,
          ),
          child: _DashboardSkeleton(),
        ),
      );
    }

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(
          AppSizes.spacingXl,
        ),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            const TherapistHeader(),

            const SizedBox(
              height: AppSizes.spacingSm,
            ),

            Row(
              children: [
                Expanded(
                  child: DashboardSummaryCard(
                    title: "Today's Sessions",
                    value:
                        todaySessions.length.toString(),
                    icon:
                        Icons.calendar_today_outlined,
                  ),
                ),

                const SizedBox(
                  width: AppSizes.spacingMd,
                ),

                Expanded(
                  child: DashboardSummaryCard(
                    title: 'Upcoming Requests',
                    value: upcomingRequests.length
                        .toString(),
                    icon:
                        Icons.pending_actions_outlined,
                  ),
                ),

                const SizedBox(
                  width: AppSizes.spacingMd,
                ),

                Expanded(
                  child: DashboardSummaryCard(
                    title: 'Completed Sessions',
                    value: completedSessions.length
                        .toString(),
                    icon:
                        Icons.check_circle_outline,
                  ),
                ),
              ],
            ),

            const SizedBox(
              height: AppSizes.spacingSection,
            ),

            Expanded(
              child: SingleChildScrollView(
                key: const Key(
                  'dashboard-content-scroll',
                ),
                child: Column(
                  children: [
                    DashboardSessionSection(
                      title: "Today's Schedule",
                      sessions: todaySessions,
                      listHeight: listHeight,
                      cardKeyPrefix: 'today',
                    ),

                    const SizedBox(
                      height: AppSizes.spacingSm,
                    ),

                    DashboardSessionSection(
                      title: 'Upcoming Sessions',
                      sessions: upcomingSessions,
                      listHeight: listHeight,
                      cardKeyPrefix: 'upcoming',
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Session> _todaySessions(
    List<Session> sessions,
  ) {
    final today = DateTime.now();

    final result = sessions
        .where(
          (session) =>
              session.status ==
                  SessionStatus.upcoming &&
              _isSameDay(
                session.scheduleDate,
                today,
              ),
        )
        .toList();

    result.sort(_compareSessions);

    return result;
  }

  List<Session> _upcomingSessions(
    List<Session> sessions,
  ) {
    final result = sessions
        .where(
          (session) =>
              session.status ==
              SessionStatus.upcoming,
        )
        .toList();

    result.sort(_compareSessions);

    return result;
  }

  List<Session> _upcomingRequests(
    List<Session> sessions,
  ) {
    final result = sessions
        .where(
          (session) =>
              session.status ==
              SessionStatus.requested,
        )
        .toList();

    result.sort(_compareSessions);

    return result;
  }

  List<Session> _completedSessions(
    List<Session> sessions,
  ) {
    final result = sessions
        .where(
          (session) =>
              session.status ==
              SessionStatus.completed,
        )
        .toList();

    result.sort(_compareSessions);

    return result;
  }

  bool _isSameDay(
    DateTime? first,
    DateTime second,
  ) {
    if (first == null) {
      return false;
    }

    return first.year == second.year &&
        first.month == second.month &&
        first.day == second.day;
  }

  int _compareSessions(
    Session a,
    Session b,
  ) {
    final aDate = a.scheduleDate;
    final bDate = b.scheduleDate;

    if (aDate == null && bDate == null) {
      return _compareTime(
        a.scheduleTime,
        b.scheduleTime,
      );
    }

    if (aDate == null) {
      return 1;
    }

    if (bDate == null) {
      return -1;
    }

    final aDay = DateTime(
      aDate.year,
      aDate.month,
      aDate.day,
    );

    final bDay = DateTime(
      bDate.year,
      bDate.month,
      bDate.day,
    );

    final dateComparison =
        aDay.compareTo(bDay);

    if (dateComparison != 0) {
      return dateComparison;
    }

    return _compareTime(
      a.scheduleTime,
      b.scheduleTime,
    );
  }

  int _compareTime(
    String? first,
    String? second,
  ) {
    final firstMinutes =
        _timeToMinutes(first);

    final secondMinutes =
        _timeToMinutes(second);

    return firstMinutes.compareTo(
      secondMinutes,
    );
  }

  int _timeToMinutes(String? value) {
    if (value == null ||
        value.trim().isEmpty) {
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
}

class _DashboardSkeleton
    extends StatelessWidget {
  const _DashboardSkeleton();

  @override
  Widget build(BuildContext context) {
    final listHeight =
        ResponsiveUtils.isMobile(context)
            ? ResponsiveUtils.height(context) * 0.28
            : ResponsiveUtils.height(context) * 0.25;

    return Shimmer.fromColors(
      baseColor: AppColors.mist,
      highlightColor: AppColors.white,
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          const _TherapistHeaderSkeleton(),

          const SizedBox(
            height: AppSizes.spacingSm,
          ),

          const Row(
            children: [
              Expanded(
                child: _SummaryCardSkeleton(),
              ),
              SizedBox(
                width: AppSizes.spacingMd,
              ),
              Expanded(
                child: _SummaryCardSkeleton(),
              ),
              SizedBox(
                width: AppSizes.spacingMd,
              ),
              Expanded(
                child: _SummaryCardSkeleton(),
              ),
            ],
          ),

          const SizedBox(
            height: AppSizes.spacingSection,
          ),

          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _SessionSectionSkeleton(
                    listHeight: listHeight,
                  ),
                  SizedBox(
                    height: AppSizes.spacingSm,
                  ),
                  _SessionSectionSkeleton(
                    listHeight: listHeight,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TherapistHeaderSkeleton
    extends StatelessWidget {
  const _TherapistHeaderSkeleton();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 52,
          height: 52,
          decoration: const BoxDecoration(
            color: AppColors.white,
            shape: BoxShape.circle,
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
              Container(
                width: 150,
                height: 16,
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius:
                      BorderRadius.circular(8),
                ),
              ),

              const SizedBox(
                height: AppSizes.spacingSm,
              ),

              Container(
                width: 100,
                height: 12,
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius:
                      BorderRadius.circular(6),
                ),
              ),
            ],
          ),
        ),

        Container(
          width: 44,
          height: 44,
          decoration: const BoxDecoration(
            color: AppColors.white,
            shape: BoxShape.circle,
          ),
        ),
      ],
    );
  }
}

class _SummaryCardSkeleton
    extends StatelessWidget {
  const _SummaryCardSkeleton();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 110,
      padding: const EdgeInsets.all(
        AppSizes.spacingMd,
      ),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(
          AppSizes.cardRadius,
        ),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius:
                  BorderRadius.circular(8),
            ),
          ),

          const Spacer(),

          Container(
            width: 42,
            height: 20,
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius:
                  BorderRadius.circular(6),
            ),
          ),

          const SizedBox(
            height: AppSizes.spacingXs,
          ),

          Container(
            width: 72,
            height: 10,
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius:
                  BorderRadius.circular(5),
            ),
          ),
        ],
      ),
    );
  }
}

class _SessionSectionSkeleton
    extends StatelessWidget {
  const _SessionSectionSkeleton({
    required this.listHeight,
  });

  final double listHeight;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: listHeight,
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Container(
            width: 140,
            height: 16,
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius:
                  BorderRadius.circular(8),
            ),
          ),

          const SizedBox(
            height: AppSizes.spacingMd,
          ),

          Expanded(
            child: ListView.separated(
              scrollDirection:
                  Axis.horizontal,
              physics:
                  const NeverScrollableScrollPhysics(),
              itemCount: 2,
              separatorBuilder: (_, _) =>
                  const SizedBox(
                width: AppSizes.spacingMd,
              ),
              itemBuilder: (
                context,
                index,
              ) {
                return Container(
                  width:
                      ResponsiveUtils.isMobile(
                              context)
                          ? ResponsiveUtils
                                  .width(
                                  context,
                                ) *
                              0.72
                          : 300,
                  decoration:
                      BoxDecoration(
                    color:
                        AppColors.white,
                    borderRadius:
                        BorderRadius
                            .circular(
                      AppSizes
                          .cardRadius,
                    ),
                  ),
                  padding:
                      const EdgeInsets.all(
                    AppSizes.spacingMd,
                  ),
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment
                            .start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 42,
                            height: 42,
                            decoration:
                                const BoxDecoration(
                              color:
                                  AppColors
                                      .white,
                              shape:
                                  BoxShape
                                      .circle,
                            ),
                          ),

                          const SizedBox(
                            width:
                                AppSizes
                                    .spacingMd,
                          ),

                          Expanded(
                            child:
                                Container(
                              height: 14,
                              decoration:
                                  BoxDecoration(
                                color:
                                    AppColors
                                        .white,
                                borderRadius:
                                    BorderRadius
                                        .circular(
                                  7,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(
                        height:
                            AppSizes.spacingLg,
                      ),

                      Container(
                        width:
                            double.infinity,
                        height: 12,
                        decoration:
                            BoxDecoration(
                          color:
                              AppColors
                                  .white,
                          borderRadius:
                              BorderRadius
                                  .circular(
                            6,
                          ),
                        ),
                      ),

                      const SizedBox(
                        height:
                            AppSizes.spacingSm,
                      ),

                      Container(
                        width: 130,
                        height: 12,
                        decoration:
                            BoxDecoration(
                          color:
                              AppColors
                                  .white,
                          borderRadius:
                              BorderRadius
                                  .circular(
                            6,
                          ),
                        ),
                      ),

                      const Spacer(),

                      Container(
                        width: 90,
                        height: 28,
                        decoration:
                            BoxDecoration(
                          color:
                              AppColors
                                  .white,
                          borderRadius:
                              BorderRadius
                                  .circular(
                            14,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}