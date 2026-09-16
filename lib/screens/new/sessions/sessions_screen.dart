
import 'package:flutter/material.dart';

import 'package:physioghar/core/constants/app_sizes.dart';
import 'package:physioghar/models/session.dart';
import 'package:physioghar/screens/new/schedule/schedule_controller.dart';
import 'package:physioghar/screens/new/sessions/session_controller.dart';
import 'package:physioghar/screens/new/sessions/widgets/session_list.dart';
import 'package:physioghar/screens/new/sessions/widgets/session_tabs.dart';
import 'package:physioghar/screens/new/sessions/widgets/sessions_header.dart';

class SessionsScreen extends StatefulWidget {
  const SessionsScreen({
    super.key,
  });

  @override
  State<SessionsScreen> createState() =>
      _SessionsScreenState();
}

class _SessionsScreenState
    extends State<SessionsScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  late final ScheduleController _scheduleController;
  final _controller = sessionController;

  final List<SessionStatus> _statuses = [
    SessionStatus.requested,
    SessionStatus.upcoming,
    SessionStatus.completed,
    SessionStatus.cancelled,
  ];

  @override
  void initState() {
    super.initState();

    _scheduleController = ScheduleController();


    _tabController = TabController(
      length: _statuses.length,
      vsync: this,
    );

    _tabController.addListener(
      _onTabChanged,
    );

    _controller.loadSessions(
      status: SessionStatus.requested,
    );
  }

  void _onTabChanged() {
    if (_tabController.indexIsChanging) {
      return;
    }

    final status =
        _statuses[_tabController.index];

    _controller.selectStatus(status);
  }

  @override
  void dispose() {
    _tabController.removeListener(
      _onTabChanged,
    );
    _tabController.dispose();

    _scheduleController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          Theme.of(context)
              .scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            const SessionsHeader(),

            const SizedBox(
              height: AppSizes.spacingSm,
            ),

            SessionTabs(
              controller: _tabController,
            ),

            const SizedBox(
              height: AppSizes.spacingSm,
            ),

            Expanded(
              child: ValueListenableBuilder<bool>(
                valueListenable:
                    _controller.isLoading,
                builder: (
                  context,
                  isLoading,
                  _,
                ) {
                  return ValueListenableBuilder<
                      List<Session>>(
                    valueListenable:
                        _controller.sessions,
                    builder: (
                      context,
                      sessions,
                      _,
                    ) {
                      if (isLoading &&
                          sessions.isEmpty) {
                        return const Center(
                          child:
                              CircularProgressIndicator(),
                        );
                      }

                      if (sessions.isEmpty) {
                        return _EmptySessionsState(
                          status:
                              _controller
                                  .selectedStatus
                                  .value,
                        );
                      }

                      return SessionList(
                        sessions: sessions,
                        controller: _controller,
                        scheduleController: _scheduleController,
                      );
                    },
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

class _EmptySessionsState
    extends StatelessWidget {
  const _EmptySessionsState({
    required this.status,
  });

  final SessionStatus status;

  @override
  Widget build(
    BuildContext context,
  ) {
    final message = switch (status) {
      SessionStatus.requested =>
        'No session requests yet.',
      SessionStatus.upcoming =>
        'No upcoming sessions.',
      SessionStatus.completed =>
        'No completed sessions.',
      SessionStatus.cancelled =>
        'No cancelled sessions.',
    };

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(
          AppSizes.spacingXl,
        ),
        child: Text(
          message,
          textAlign: TextAlign.center,
          style: Theme.of(context)
              .textTheme
              .bodyMedium,
        ),
      ),
    );
  }
}
