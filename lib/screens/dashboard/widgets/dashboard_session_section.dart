
import 'package:flutter/material.dart';
import 'package:physioghar/app/router.dart';
import 'package:physioghar/core/constants/app_sizes.dart';
import 'package:physioghar/models/session.dart';
import 'package:physioghar/screens/dashboard/widgets/schedule_item_card.dart';

class DashboardSessionSection extends StatefulWidget {
  const DashboardSessionSection({
    super.key,
    required this.title,
    required this.sessions,
    required this.listHeight,
    required this.cardKeyPrefix,
  });

  final String title;
  final List<Session> sessions;
  final double listHeight;
  final String cardKeyPrefix;

  @override
  State<DashboardSessionSection> createState() =>
      _DashboardSessionSectionState();
}

class _DashboardSessionSectionState extends State<DashboardSessionSection> {
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
        // ---------------------------------------------------------------------
        // Section Title
        // ---------------------------------------------------------------------
        Text(
          widget.title,
          style: Theme.of(context).textTheme.titleLarge,
        ),

        const SizedBox(
          height: AppSizes.spacingMd,
        ),

        // ---------------------------------------------------------------------
        // Session List
        // ---------------------------------------------------------------------
        SizedBox(
          height: widget.listHeight,
          child: Scrollbar(
            controller: _scrollController,
            thumbVisibility: true,
            child: ListView.separated(
              key: Key('${widget.cardKeyPrefix}-list'),
              controller: _scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.only(
                right: AppSizes.spacingSm,
              ),
              itemCount: widget.sessions.length,
              separatorBuilder: (_, _) {
                return const SizedBox(
                  height: AppSizes.spacingSm,
                );
              },
              itemBuilder: (context, index) {
                final session = widget.sessions[index];

                return ScheduleItemCard(
                  cardKey: Key(
                    '${
                      widget.cardKeyPrefix
                    }-session-card-${session.id}',
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