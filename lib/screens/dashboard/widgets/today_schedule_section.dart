import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:physioghar/core/constants/app_colors.dart';
import 'package:physioghar/core/constants/app_sizes.dart';
import 'package:physioghar/providers/session_provider.dart';
import 'package:physioghar/screens/dashboard/widgets/schedule_item_card.dart';

class TodayScheduleSection extends ConsumerWidget {
  const TodayScheduleSection({super.key});

  bool _isSameDay(DateTime first, DateTime second) {
    return first.year == second.year &&
        first.month == second.month &&
        first.day == second.day;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sessions = ref.watch(sessionProvider);
    final today = DateTime.now();

    final todaySessions = sessions
        .where((session) => _isSameDay(session.dateTime, today))
        .toList()
      ..sort(
        (a, b) => a.dateTime.compareTo(b.dateTime),
      );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Today's Schedule",
              style: Theme.of(context).textTheme.headlineLarge,
            ),

            if (todaySessions.isNotEmpty)
              Text(
                '${todaySessions.length} sessions',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.inkMute,
                      fontSize: AppSizes.fontSizeSm,
                    ),
              ),
          ],
        ),

        const SizedBox(height: AppSizes.spacingMd),

        // Schedule / Empty State
        if (todaySessions.isEmpty)
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
                  'No sessions scheduled for today',
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
            itemCount: todaySessions.length,
            separatorBuilder: (_, _) =>
                const SizedBox(height: AppSizes.spacingSm),
            itemBuilder: (context, index) {
              final session = todaySessions[index];

              return ScheduleItemCard(
                cardKey: Key('today-session-card-${session.id}'),
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