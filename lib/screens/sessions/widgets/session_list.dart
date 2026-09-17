
import 'package:flutter/material.dart';

import 'package:physioghar/core/constants/app_sizes.dart';
import 'package:physioghar/models/session.dart';
import 'package:physioghar/screens/schedule/schedule_controller.dart';
import 'package:physioghar/screens/sessions/session_controller.dart';
import 'package:physioghar/screens/sessions/widgets/session_card.dart';
import 'package:physioghar/screens/sessions/widgets/session_empty_state.dart';

class SessionList extends StatelessWidget {
  const SessionList({
    super.key,
    required this.sessions,
    required this.controller,
    required this.scheduleController,
  });

  final List<Session> sessions;
  final SessionController controller;
  final ScheduleController scheduleController;

  @override
  Widget build(BuildContext context) {
    if (sessions.isEmpty) {
      return const SessionEmptyState();
    }

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(
        AppSizes.spacingXl,
        AppSizes.spacingMd,
        AppSizes.spacingXl,
        AppSizes.spacingXl,
      ),
      itemCount: sessions.length,
      separatorBuilder: (
        _,
        _,
      ) =>
          const SizedBox(
        height: AppSizes.spacingSm,
      ),
      itemBuilder: (
        context,
        index,
      ) {
        final session = sessions[index];

        return SessionCard(
          session: session,
          controller: controller,
          scheduleController:
              scheduleController,
        );
      },
    );
  }
}