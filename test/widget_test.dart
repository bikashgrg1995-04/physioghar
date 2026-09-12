
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:physioghar/app/app.dart';

void main() {
  Future<void> pumpApp(WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: PhysioGharApp(),
      ),
    );

    await tester.pumpAndSettle();
  }

  group('Main navigation', () {
    testWidgets('loads all navigation destinations', (tester) async {
      await pumpApp(tester);

      expect(find.text('Home'), findsOneWidget);
      expect(find.text('Schedule'), findsOneWidget);
      expect(find.text('Sessions'), findsOneWidget);
      expect(find.text('Patients'), findsOneWidget);
      expect(find.text('Profile'), findsOneWidget);
    });

    testWidgets('navigates to Schedule tab', (tester) async {
      await pumpApp(tester);

      await tester.tap(find.text('Schedule'));
      await tester.pumpAndSettle();

      expect(
        find.byKey(const Key('schedule-screen-title')),
        findsOneWidget,
      );
    });

    testWidgets('navigates to Sessions tab', (tester) async {
      await pumpApp(tester);

      await tester.tap(find.text('Sessions'));
      await tester.pumpAndSettle();

      expect(
        find.byKey(const Key('sessions-screen-title')),
        findsOneWidget,
      );
    });

    testWidgets('navigates to Patients tab', (tester) async {
      await pumpApp(tester);

      await tester.tap(find.text('Patients'));
      await tester.pumpAndSettle();

      expect(
        find.byKey(const Key('patients-screen-title')),
        findsOneWidget,
      );
    });

    testWidgets('navigates to Profile tab', (tester) async {
      await pumpApp(tester);

      await tester.tap(find.text('Profile'));
      await tester.pumpAndSettle();

      expect(
        find.byKey(const Key('profile-screen-title')),
        findsOneWidget,
      );
    });
  });

  group('Dashboard', () {
    testWidgets('displays therapist information', (tester) async {
      await pumpApp(tester);

      final therapistName = find.byKey(
        const Key('therapist-name'),
      );

      final availabilityStatus = find.byKey(
        const Key('availability-status'),
      );

      expect(therapistName, findsOneWidget);
      expect(availabilityStatus, findsOneWidget);

      expect(
        find.text('Dr. Anisha Sharma'),
        findsOneWidget,
      );
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
        find.descendant(
          of: todaySessionsCard,
          matching: find.text('2'),
        ),
        findsOneWidget,
      );

      expect(
        find.descendant(
          of: upcomingRequestsCard,
          matching: find.text('0'),
        ),
        findsOneWidget,
      );

      expect(
        find.descendant(
          of: completedSessionsCard,
          matching: find.text('0'),
        ),
        findsOneWidget,
      );
    });

    testWidgets('displays today schedule', (tester) async {
      await pumpApp(tester);

      expect(
        find.text("Today's Schedule"),
        findsOneWidget,
      );

      final sitaCard = find.byKey(
        const Key('today-session-card-session_001'),
      );

      expect(sitaCard, findsOneWidget);

      expect(
        find.descendant(
          of: sitaCard,
          matching: find.text('Sita Sharma'),
        ),
        findsOneWidget,
      );

      expect(
        find.descendant(
          of: sitaCard,
          matching: find.text('Back Pain'),
        ),
        findsOneWidget,
      );

      expect(
        find.descendant(
          of: sitaCard,
          matching: find.text('Home Visit'),
        ),
        findsOneWidget,
      );

      final ramCard = find.byKey(
        const Key('today-session-card-session_002'),
      );

      expect(ramCard, findsOneWidget);

      expect(
        find.descendant(
          of: ramCard,
          matching: find.text('Ram Thapa'),
        ),
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
        find.descendant(
          of: ramCard,
          matching: find.text('Clinic'),
        ),
        findsOneWidget,
      );
    });

    testWidgets('displays upcoming sessions', (tester) async {
      await pumpApp(tester);

      expect(
        find.text('Upcoming Sessions'),
        findsOneWidget,
      );

      final sitaCard = find.byKey(
        const Key('upcoming-session-card-session_001'),
      );

      final ramCard = find.byKey(
        const Key('upcoming-session-card-session_002'),
      );

      expect(sitaCard, findsOneWidget);
      expect(ramCard, findsOneWidget);

      expect(
        find.descendant(
          of: sitaCard,
          matching: find.text('Sita Sharma'),
        ),
        findsOneWidget,
      );

      expect(
        find.descendant(
          of: sitaCard,
          matching: find.text('Back Pain'),
        ),
        findsOneWidget,
      );

      expect(
        find.descendant(
          of: sitaCard,
          matching: find.text('Home Visit'),
        ),
        findsOneWidget,
      );

      expect(
        find.descendant(
          of: ramCard,
          matching: find.text('Ram Thapa'),
        ),
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
        find.descendant(
          of: ramCard,
          matching: find.text('Clinic'),
        ),
        findsOneWidget,
      );
    });

    testWidgets('toggles therapist availability', (tester) async {
      await pumpApp(tester);

      final availabilityStatus = find.byKey(
        const Key('availability-status'),
      );

      final availabilitySwitch = find.byKey(
        const Key('availability-switch'),
      );

      expect(availabilityStatus, findsOneWidget);
      expect(availabilitySwitch, findsOneWidget);

      expect(
        find.text('Available'),
        findsOneWidget,
      );

      expect(
        find.text('Unavailable'),
        findsNothing,
      );

      await tester.tap(availabilitySwitch);
      await tester.pumpAndSettle();

      expect(
        find.text('Available'),
        findsNothing,
      );

      expect(
        find.text('Unavailable'),
        findsOneWidget,
      );

      await tester.tap(availabilitySwitch);
      await tester.pumpAndSettle();

      expect(
        find.text('Available'),
        findsOneWidget,
      );

      expect(
        find.text('Unavailable'),
        findsNothing,
      );
    });
  });
}
