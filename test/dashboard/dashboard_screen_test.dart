import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/pump_app.dart';

void main() {
  group('Dashboard', () {
    testWidgets('displays therapist information', (tester) async {
      await pumpApp(tester);

      final therapistName = find.byKey(const Key('therapist-name'));

      final availabilityStatus = find.byKey(const Key('availability-status'));

      expect(therapistName, findsOneWidget);
      expect(availabilityStatus, findsOneWidget);

      expect(find.text('Dr. Anisha Sharma'), findsOneWidget);
    });

    testWidgets('displays dashboard summary cards', (tester) async {
      await pumpApp(tester);

      final todaySessionsCard = find.byKey(
        const Key("summary-card-Today's Sessions"),
      );

      final upcomingRequestsCard = find.byKey(
        const Key('summary-card-Upcoming Requests'),
      );

      final completedSessionsCard = find.byKey(
        const Key('summary-card-Completed Sessions'),
      );

      expect(todaySessionsCard, findsOneWidget);
      expect(upcomingRequestsCard, findsOneWidget);
      expect(completedSessionsCard, findsOneWidget);

      expect(
        find.descendant(of: todaySessionsCard, matching: find.text('2')),
        findsOneWidget,
      );

      expect(
        find.descendant(of: upcomingRequestsCard, matching: find.text('1')),
        findsOneWidget,
      );

      expect(
        find.descendant(of: completedSessionsCard, matching: find.text('0')),
        findsOneWidget,
      );
    });

    testWidgets('displays today schedule', (tester) async {
      await pumpApp(tester);

      expect(find.text("Today's Schedule"), findsOneWidget);

      final sitaCard = find.byKey(
        const Key('today-session-card-dashboard_session_001'),
      );

      expect(sitaCard, findsOneWidget);

      expect(
        find.descendant(of: sitaCard, matching: find.text('Sita Sharma')),
        findsOneWidget,
      );

      expect(
        find.descendant(of: sitaCard, matching: find.text('Back Pain')),
        findsOneWidget,
      );

      expect(
        find.descendant(of: sitaCard, matching: find.text('Home Visit')),
        findsOneWidget,
      );

      final ramCard = find.byKey(
        const Key('today-session-card-dashboard_session_002'),
      );

      expect(ramCard, findsOneWidget);

      expect(
        find.descendant(of: ramCard, matching: find.text('Ram Thapa')),
        findsOneWidget,
      );

      expect(
        find.descendant(
          of: ramCard,
          matching: find.text('Knee Rehabilitation'),
        ),
        findsOneWidget,
      );

      expect(
        find.descendant(of: ramCard, matching: find.text('Clinic')),
        findsOneWidget,
      );
    });

    testWidgets('displays upcoming sessions', (tester) async {
      await pumpApp(tester);

      expect(find.text('Upcoming Sessions'), findsOneWidget);

      final sitaCard = find.byKey(
        const Key('upcoming-session-card-dashboard_session_001'),
      );

      final ramCard = find.byKey(
        const Key('upcoming-session-card-dashboard_session_002'),
      );

      expect(sitaCard, findsOneWidget);

      expect(
        find.descendant(of: sitaCard, matching: find.text('Sita Sharma')),
        findsOneWidget,
      );

      expect(
        find.descendant(of: sitaCard, matching: find.text('Back Pain')),
        findsOneWidget,
      );

      expect(
        find.descendant(of: sitaCard, matching: find.text('Home Visit')),
        findsOneWidget,
      );

      final upcomingList = find.byKey(const Key('upcoming-sessions-list'));

      final listView = tester.widget<ListView>(upcomingList);
      final controller = listView.controller;

      expect(controller, isNotNull);

      controller!.jumpTo(controller.position.maxScrollExtent);

      await tester.pumpAndSettle();

      expect(ramCard, findsOneWidget);

      expect(
        find.descendant(of: ramCard, matching: find.text('Ram Thapa')),
        findsOneWidget,
      );

      expect(
        find.descendant(
          of: ramCard,
          matching: find.text('Knee Rehabilitation'),
        ),
        findsOneWidget,
      );

      expect(
        find.descendant(of: ramCard, matching: find.text('Clinic')),
        findsOneWidget,
      );
    });
    testWidgets('toggles therapist availability', (tester) async {
      await pumpApp(tester);

      final availabilityStatus = find.byKey(const Key('availability-status'));

      final availabilitySwitch = find.byKey(const Key('availability-switch'));

      expect(availabilityStatus, findsOneWidget);
      expect(availabilitySwitch, findsOneWidget);

      expect(find.text('Available'), findsOneWidget);

      expect(find.text('Unavailable'), findsNothing);

      await tester.tap(availabilitySwitch);
      await tester.pumpAndSettle();

      expect(find.text('Available'), findsNothing);

      expect(find.text('Unavailable'), findsOneWidget);

      await tester.tap(availabilitySwitch);
      await tester.pumpAndSettle();

      expect(find.text('Available'), findsOneWidget);

      expect(find.text('Unavailable'), findsNothing);
    });
  });
}
