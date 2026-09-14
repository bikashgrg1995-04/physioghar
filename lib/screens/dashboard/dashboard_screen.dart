import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:physioghar/core/constants/app_sizes.dart';
import 'package:physioghar/core/utils/date_time_utils.dart';
import 'package:physioghar/core/utils/responsive_utils.dart';
import 'package:physioghar/models/session.dart';
import 'package:physioghar/providers/session_provider.dart';
import 'package:physioghar/screens/dashboard/widgets/dashboard_summary_card.dart';
import 'package:physioghar/screens/dashboard/widgets/therapist_header.dart';
import 'package:physioghar/screens/dashboard/widgets/today_schedule_section.dart';
import 'package:physioghar/screens/dashboard/widgets/upcoming_sessions_section.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sessions = ref.watch(sessionProvider);
    final today = DateTime.now();

    // Today's dashboard sessions.
    final todaySessions =
        sessions
            .where(
              (session) =>
                  session.source == SessionSource.dashboard &&
                  DateTimeUtils.isSameDay(session.dateTime, today) &&
                  session.status == SessionStatus.upcoming,
            )
            .toList()
          ..sort((a, b) => a.dateTime.compareTo(b.dateTime));

    // Booking requests.
    final upcomingRequests =
        sessions
            .where((session) => session.status == SessionStatus.requested)
            .toList()
          ..sort((a, b) => a.dateTime.compareTo(b.dateTime));

    // Upcoming accepted sessions.
    final upcomingSessions =
        sessions
            .where((session) => session.status == SessionStatus.upcoming)
            .toList()
          ..sort((a, b) => a.dateTime.compareTo(b.dateTime));

    // Completed sessions.
    final completedSessions = sessions
        .where((session) => session.status == SessionStatus.completed)
        .toList();

    final listHeight = ResponsiveUtils.isMobile(context)
        ? ResponsiveUtils.height(context) * 0.28
        : ResponsiveUtils.height(context) * 0.25;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const TherapistHeader(),

            const SizedBox(height: AppSizes.spacingSm),

            Row(
              children: [
                Expanded(
                  child: DashboardSummaryCard(
                    title: "Today's Sessions",
                    value: todaySessions.length.toString(),
                    icon: Icons.calendar_today_outlined,
                  ),
                ),
                const SizedBox(width: AppSizes.spacingMd),
                Expanded(
                  child: DashboardSummaryCard(
                    title: 'Upcoming Requests',
                    value: upcomingRequests.length.toString(),
                    icon: Icons.pending_actions_outlined,
                  ),
                ),
                const SizedBox(width: AppSizes.spacingMd),
                Expanded(
                  child: DashboardSummaryCard(
                    title: 'Completed Sessions',
                    value: completedSessions.length.toString(),
                    icon: Icons.check_circle_outline,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSizes.spacingSection),
            Expanded(
              child: SingleChildScrollView(
                key: const Key('dashboard-content-scroll'),
                child: Column(
                  children: [
                    TodayScheduleSection(
                      sessions: todaySessions,
                      listHeight: listHeight,
                    ),

                    const SizedBox(height: AppSizes.spacingSm),

                    UpcomingSessionsSection(
                      sessions: upcomingSessions,
                      listHeight: listHeight,
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
}
