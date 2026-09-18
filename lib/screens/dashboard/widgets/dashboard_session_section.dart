import 'package:flutter/material.dart';

import 'package:physioghar/app/router.dart';
import 'package:physioghar/common_widgets/app_card.dart';
import 'package:physioghar/common_widgets/app_empty_state.dart';
import 'package:physioghar/core/constants/app_colors.dart';
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

class _DashboardSessionSectionState
    extends State<DashboardSessionSection> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(AppSizes.spacingMd),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.title,
            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  fontSize: AppSizes.fontSizeLg,
                  color: AppColors.ink,
                ),
          ),

          const SizedBox(height: AppSizes.spacingMd),

          SizedBox(
            height: widget.listHeight,
            child: widget.sessions.isEmpty
                ? 
 const AppEmptyState(
                  title: 'No sessions',
                  message: 'There are no sessions to show here.',
                  icon: Icons.event_note_outlined,
                )
                : Scrollbar(
                    controller: _scrollController,
                    thumbVisibility: true,
                    child: ListView.separated(
                      key: Key('${widget.cardKeyPrefix}-list'),
                      controller: _scrollController,
                      padding: const EdgeInsets.only(
                        right: AppSizes.spacingSm,
                      ),
                      itemCount: widget.sessions.length,
                      separatorBuilder: (_, _) => const SizedBox(
                        height: AppSizes.spacingSm,
                      ),
                      itemBuilder: (context, index) {
                        final session = widget.sessions[index];

                        return ScheduleItemCard(
                          cardKey: Key(
                            '${widget.cardKeyPrefix}-session-card-${session.id ?? index}',
                          ),
                          session: session,
                          onTap: session.id == null
                              ? null
                              : () {
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
      ),
    );
  }
}
