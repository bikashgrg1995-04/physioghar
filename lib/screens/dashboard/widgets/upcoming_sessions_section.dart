
import 'package:flutter/material.dart';
import 'package:physioghar/app/router.dart';
import 'package:physioghar/core/constants/app_sizes.dart';
import 'package:physioghar/models/session.dart';
import 'package:physioghar/screens/dashboard/widgets/schedule_item_card.dart';

class UpcomingSessionsSection extends StatefulWidget {
  const UpcomingSessionsSection({
    super.key,
    required this.sessions,
    required this.listHeight,
  });

  final List<Session> sessions;
  final double listHeight;

  @override
  State<UpcomingSessionsSection> createState() =>
      _UpcomingSessionsSectionState();
}

class _UpcomingSessionsSectionState
    extends State<UpcomingSessionsSection> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Upcoming Sessions',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: AppSizes.spacingMd),
        SizedBox(
          height: widget.listHeight,
          child: Scrollbar(
            controller: _scrollController,
            thumbVisibility: true,
            child: ListView.separated(
              key: const Key('upcoming-sessions-list'),
              controller: _scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.only(right: AppSizes.spacingSm),
              itemCount: widget.sessions.length,
              separatorBuilder: (_, _) => const SizedBox(
                height: AppSizes.spacingSm,
              ),
              itemBuilder: (context, index) {
                final session = widget.sessions[index];

                return ScheduleItemCard(
                  cardKey: Key(
                    'upcoming-session-card-${session.id}',
                  ),
                  session: session,
                  onTap: () {
                    Navigator.of(context).pushNamed(
                      AppRouter.sessionDetail,
                      arguments: session.id,
                    );
                  },
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
