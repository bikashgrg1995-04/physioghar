import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import 'package:physioghar/core/constants/app_colors.dart';
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
        child: ValueListenableBuilder<bool>(
          valueListenable: _controller.isLoading,
          builder: (context, isLoading, _) {
            if (isLoading) {
              return const _DashboardSkeleton();
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TherapistHeader(
                  controller: _therapistController,
                ),

                const SizedBox(height: AppSizes.spacingSm),

                ValueListenableBuilder<List<Session>>(
                  valueListenable: _sessionController.allSessions,
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
                            value:
                                _controller.upcomingRequestsCount.toString(),
                            icon: Icons.pending_actions_outlined,
                          ),
                        ),
                        const SizedBox(width: AppSizes.spacingMd),
                        Expanded(
                          child: DashboardSummaryCard(
                            title: 'Completed Sessions',
                            value:
                                _controller.completedSessionsCount.toString(),
                            icon: Icons.check_circle_outline,
                          ),
                        ),
                      ],
                    );
                  },
                ),

                const SizedBox(height: AppSizes.spacingSection),

                Expanded(
                  child: ValueListenableBuilder<List<Session>>(
                    valueListenable: _sessionController.allSessions,
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
                            const SizedBox(
                              height: AppSizes.spacingSm,
                            ),
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
            );
          },
        ),
      ),
    );
  }


}

class _DashboardSkeleton extends StatelessWidget {
  const _DashboardSkeleton();

  @override
  Widget build(BuildContext context) {
    final listHeight = ResponsiveUtils.isMobile(context)
        ? ResponsiveUtils.height(context) * 0.28
        : ResponsiveUtils.height(context) * 0.25;

    return Shimmer.fromColors(
      baseColor: AppColors.mist,
      highlightColor: AppColors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _TherapistHeaderSkeleton(),

          const SizedBox(height: AppSizes.spacingSm),

          Row(
            children: const [
              Expanded(child: _SummaryCardSkeleton()),
              SizedBox(width: AppSizes.spacingMd),
              Expanded(child: _SummaryCardSkeleton()),
              SizedBox(width: AppSizes.spacingMd),
              Expanded(child: _SummaryCardSkeleton()),
            ],
          ),

          const SizedBox(height: AppSizes.spacingSection),

          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _SessionSectionSkeleton(
                    listHeight: listHeight,
                  ),
                  SizedBox(height: AppSizes.spacingSm),
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

class _TherapistHeaderSkeleton extends StatelessWidget {
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
        const SizedBox(width: AppSizes.spacingMd),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 150,
                height: 16,
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              const SizedBox(height: AppSizes.spacingSm),
              Container(
                width: 100,
                height: 12,
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(6),
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

class _SummaryCardSkeleton extends StatelessWidget {
  const _SummaryCardSkeleton();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 110,
      padding: const EdgeInsets.all(AppSizes.spacingMd),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppSizes.cardRadius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          const Spacer(),
          Container(
            width: 42,
            height: 20,
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(6),
            ),
          ),
          const SizedBox(height: AppSizes.spacingXs),
          Container(
            width: 72,
            height: 10,
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(5),
            ),
          ),
        ],
      ),
    );
  }
}

class _SessionSectionSkeleton extends StatelessWidget {
  const _SessionSectionSkeleton({
    required this.listHeight,
  });

  final double listHeight;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: listHeight,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 140,
            height: 16,
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          const SizedBox(height: AppSizes.spacingMd),
          Expanded(
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 2,
              separatorBuilder: (_, _) =>
                  const SizedBox(width: AppSizes.spacingMd),
              itemBuilder: (context, index) {
                return Container(
                  width: ResponsiveUtils.isMobile(context)
                      ? ResponsiveUtils.width(context) * 0.72
                      : 300,
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(
                      AppSizes.cardRadius,
                    ),
                  ),
                  padding: const EdgeInsets.all(
                    AppSizes.spacingMd,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 42,
                            height: 42,
                            decoration: const BoxDecoration(
                              color: AppColors.white,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(
                            width: AppSizes.spacingMd,
                          ),
                          Expanded(
                            child: Container(
                              height: 14,
                              decoration: BoxDecoration(
                                color: AppColors.white,
                                borderRadius: BorderRadius.circular(7),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSizes.spacingLg),
                      Container(
                        width: double.infinity,
                        height: 12,
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      const SizedBox(height: AppSizes.spacingSm),
                      Container(
                        width: 130,
                        height: 12,
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      const Spacer(),
                      Container(
                        width: 90,
                        height: 28,
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(14),
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