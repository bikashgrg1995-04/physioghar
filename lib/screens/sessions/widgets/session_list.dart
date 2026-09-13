import 'package:flutter/material.dart';
import 'package:physioghar/models/session.dart';
import 'package:physioghar/screens/sessions/widgets/session_card.dart';
import 'package:physioghar/screens/sessions/widgets/session_empty_state.dart';

class SessionList extends StatelessWidget {
  final List<Session> sessions;

  const SessionList({super.key, required this.sessions});

  @override
  Widget build(BuildContext context) {
    if (sessions.isEmpty) {
      return const SessionEmptyState();
    }

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
      itemCount: sessions.length,
      separatorBuilder: (_, _) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        return SessionCard(session: sessions[index]);
      },
    );
  }
}
