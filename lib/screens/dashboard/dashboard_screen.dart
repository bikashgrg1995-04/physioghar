import 'package:flutter/material.dart';

import 'package:physioghar/core/constants/app_sizes.dart';
import 'package:physioghar/core/utils/responsive_utils.dart';
import 'package:physioghar/models/session.dart';
import 'package:physioghar/screens/dashboard/dashboard_controller.dart';
import 'package:physioghar/screens/dashboard/widgets/dashboard_session_section.dart';
import 'package:physioghar/screens/dashboard/widgets/dashboard_summary_card.dart';
import 'package:physioghar/screens/dashboard/widgets/therapist_header.dart';
import 'package:physioghar/screens/profile/therapist_controller.dart';
import 'package:physioghar/screens/sessions/session_controller.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late final DashboardController _controller;

  // Global shared controllers.
  final TherapistController _therapistController = therapistController;

  final SessionController _sessionController = sessionController;

  @override
  void initState() {
    super.initState();

    _controller = DashboardController(
      therapistController: _therapistController,
      sessionController: _sessionController,
    );

    _controller.loadDashboard();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final listHeight = ResponsiveUtils.isMobile(context)
        ? ResponsiveUtils.height(context) * 0.28
        : ResponsiveUtils.height(context) * 0.25;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.spacingXl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // -----------------------------------------------------------------
            // Therapist Header
            // -----------------------------------------------------------------
            TherapistHeader(controller: _therapistController),

            const SizedBox(height: AppSizes.spacingSm),

            // -----------------------------------------------------------------
            // Dashboard Summary
            // -----------------------------------------------------------------
            ValueListenableBuilder<List<Session>>(
              valueListenable: _sessionController.sessions,
              builder: (context, sessions, _) {
                return Row(
                  children: [
                    Expanded(
                      child: DashboardSummaryCard(
                        title: "Today's Sessions",
                        value: _controller.todaySessionsCount.toString(),
                        icon: Icons.calendar_today_outlined,
                      ),
                    ),

                    const SizedBox(width: AppSizes.spacingMd),

                    Expanded(
                      child: DashboardSummaryCard(
                        title: 'Upcoming Requests',
                        value: _controller.upcomingRequestsCount.toString(),
                        icon: Icons.pending_actions_outlined,
                      ),
                    ),

                    const SizedBox(width: AppSizes.spacingMd),

                    Expanded(
                      child: DashboardSummaryCard(
                        title: 'Completed Sessions',
                        value: _controller.completedSessionsCount.toString(),
                        icon: Icons.check_circle_outline,
                      ),
                    ),
                  ],
                );
              },
            ),

            const SizedBox(height: AppSizes.spacingSection),

            // -----------------------------------------------------------------
            // Dashboard Sessions
            // -----------------------------------------------------------------
            Expanded(
              child: ValueListenableBuilder<List<Session>>(
                valueListenable: _sessionController.sessions,
                builder: (context, sessions, _) {
                  return SingleChildScrollView(
                    key: const Key('dashboard-content-scroll'),
                    child: Column(
                      children: [
                        DashboardSessionSection(
                          title: "Today's Schedule",
                          sessions: _controller.todaySessions,
                          listHeight: listHeight,
                          cardKeyPrefix: 'today',
                        ),
                        const SizedBox(height: AppSizes.spacingSm),
                        DashboardSessionSection(
                          title: 'Upcoming Sessions',
                          sessions: _controller.upcomingSessions,
                          listHeight: listHeight,
                          cardKeyPrefix: 'upcoming',
                        ),
                      ],
                    ),
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
