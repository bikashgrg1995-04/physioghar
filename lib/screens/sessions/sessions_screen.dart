import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:physioghar/models/session.dart';
import 'package:physioghar/providers/session_provider.dart';
import 'package:physioghar/screens/sessions/widgets/session_list.dart';
import 'package:physioghar/screens/sessions/widgets/session_tabs.dart';
import 'package:physioghar/screens/sessions/widgets/sessions_header.dart';

class SessionsScreen extends ConsumerStatefulWidget {
  const SessionsScreen({super.key});

  @override
  ConsumerState<SessionsScreen> createState() => _SessionsScreenState();
}

class _SessionsScreenState extends ConsumerState<SessionsScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(
      length: 4,
      vsync: this,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<Session> _sessionsByStatus(
    List<Session> sessions,
    SessionStatus status,
  ) {
    return sessions
        .where((session) => session.status == status)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final sessions = ref.watch(sessionProvider);

    final requests = _sessionsByStatus(
      sessions,
      SessionStatus.requested,
    );

    final upcoming = _sessionsByStatus(
      sessions,
      SessionStatus.upcoming,
    );

    final completed = _sessionsByStatus(
      sessions,
      SessionStatus.completed,
    );

    final cancelled = _sessionsByStatus(
      sessions,
      SessionStatus.cancelled,
    );

    final sessionLists = [
      requests,
      upcoming,
      completed,
      cancelled,
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFFBFBF8),
      body: SafeArea(
        child: Column(
          children: [
            const SessionsHeader(),

            SessionTabs(
              controller: _tabController,
            ),

            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  for (final sessionList in sessionLists)
                    SessionList(
                      sessions: sessionList,
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}