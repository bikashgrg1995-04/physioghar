import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:physioghar/core/constants/app_colors.dart';
import 'package:physioghar/core/constants/app_sizes.dart';
import 'package:physioghar/models/session.dart';
import 'package:physioghar/providers/session_provider.dart';
import 'package:physioghar/screens/dashboard/widgets/schedule_item_card.dart';

class UpcomingSessionsSection extends ConsumerWidget {
  const UpcomingSessionsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sessions = ref.watch(sessionProvider);

    final upcomingSessions = sessions
        .where(
          (session) => session.status == SessionStatus.upcoming,
        )
        .toList()
      ..sort(
        (a, b) => a.dateTime.compareTo(b.dateTime),
      );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Upcoming Sessions',
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            if (upcomingSessions.isNotEmpty)
              Text(
                '${upcomingSessions.length} sessions',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.inkMute,
                      fontSize: AppSizes.fontSizeSm,
                    ),
              ),
          ],
        ),
        const SizedBox(height: AppSizes.spacingMd),

        if (upcomingSessions.isEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppSizes.spacingXl),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(
                AppSizes.cardRadius,
              ),
            ),
            child: Column(
              children: [
                const Icon(
                  Icons.event_available_outlined,
                  size: 32,
                  color: AppColors.inkMute,
                ),
                const SizedBox(height: AppSizes.spacingSm),
                Text(
                  'No upcoming sessions',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.inkMute,
                      ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          )
        else
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: upcomingSessions.length,
            separatorBuilder: (_, _) => const SizedBox(
              height: AppSizes.spacingSm,
            ),
            itemBuilder: (context, index) {
              final session = upcomingSessions[index];

              return ScheduleItemCard(
                cardKey: Key('upcoming-session-card-${session.id}'),
                session: session,
                onTap: () {
                  // Session detail navigation will be added later.
                },
              );
            },
          ),
      ],
    );
  }
}