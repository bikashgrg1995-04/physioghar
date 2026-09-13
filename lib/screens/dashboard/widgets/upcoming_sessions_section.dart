import 'package:flutter/material.dart';
import 'package:physioghar/core/constants/app_colors.dart';
import 'package:physioghar/core/constants/app_sizes.dart';
import 'package:physioghar/models/session.dart';
import 'package:physioghar/screens/dashboard/widgets/schedule_item_card.dart';

class UpcomingSessionsSection extends StatelessWidget {
  const UpcomingSessionsSection({super.key, required this.sessions});

  final List<Session> sessions;

  @override
  Widget build(BuildContext context) {
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
            if (sessions.isNotEmpty)
              Text(
                '${sessions.length} sessions',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.inkMute,
                  fontSize: AppSizes.fontSizeSm,
                ),
              ),
          ],
        ),
        const SizedBox(height: AppSizes.spacingMd),
        if (sessions.isEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppSizes.spacingXl),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(AppSizes.cardRadius),
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
                  style: Theme.of(context).textTheme.bodyMedium
                      ?.copyWith(color: AppColors.inkMute),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          )
        else
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: sessions.length,
            separatorBuilder: (_, _) =>
                const SizedBox(height: AppSizes.spacingSm),
            itemBuilder: (context, index) {
              final session = sessions[index];

              return ScheduleItemCard(
                cardKey: Key('upcoming-session-card-${session.id}'),
                session: session,
                onTap: () {},
              );
            },
          ),
      ],
    );
  }
}
