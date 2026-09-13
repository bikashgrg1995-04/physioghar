import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:physioghar/providers/session_provider.dart';
import 'package:physioghar/screens/sessions/sessions_screen.dart';
import 'package:physioghar/screens/sessions/widgets/session_card.dart';

void main() {
  Widget createTestWidget() {
    return const ProviderScope(child: MaterialApp(home: SessionsScreen()));
  }

  testWidgets('SessionsScreen displays all session tabs', (tester) async {
    await tester.pumpWidget(createTestWidget());

    expect(find.text('Requests'), findsOneWidget);
    expect(find.text('Upcoming'), findsOneWidget);
    expect(find.text('Completed'), findsOneWidget);
    expect(find.text('Cancelled'), findsOneWidget);
  });

  testWidgets('Requests tab displays booking request', (tester) async {
    await tester.pumpWidget(createTestWidget());

    expect(find.text('Maya Gurung'), findsOneWidget);
    expect(find.text('Neck Pain'), findsOneWidget);
    expect(find.text('Accept'), findsOneWidget);
    expect(find.text('Decline'), findsOneWidget);
  });

  testWidgets('Accepting a booking moves the session to Upcoming', (
    tester,
  ) async {
    await tester.pumpWidget(createTestWidget());

    // Accept Maya's booking request.
    await tester.tap(find.text('Accept'));
    await tester.pumpAndSettle();

    // Switch to Upcoming tab.
    await tester.tap(find.text('Upcoming'));
    await tester.pumpAndSettle();

    // Maya is further down the list, so scroll until she is built.
    await tester.scrollUntilVisible(
      find.text('Maya Gurung'),
      500,
      scrollable: find.byType(Scrollable).last,
    );

    expect(find.text('Maya Gurung'), findsOneWidget);
    expect(find.text('Neck Pain'), findsOneWidget);
  });

  testWidgets('Upcoming session can be completed', (tester) async {
    await tester.pumpWidget(createTestWidget());

    // Switch to Upcoming tab.
    await tester.tap(find.text('Upcoming'));
    await tester.pumpAndSettle();

    expect(find.text('Sita Sharma'), findsOneWidget);

    // Find Sita's card.
    final sitaCard = find.ancestor(
      of: find.text('Sita Sharma'),
      matching: find.byType(SessionCard),
    );

    // Tap Complete only inside Sita's card.
    await tester.tap(
      find.descendant(of: sitaCard, matching: find.text('Complete')),
    );

    await tester.pumpAndSettle();

    // Switch to Completed tab.
    await tester.tap(find.text('Completed'));
    await tester.pumpAndSettle();

    expect(find.text('Sita Sharma'), findsOneWidget);
    expect(find.text('COMPLETED'), findsOneWidget);
  });

  testWidgets('Declining a booking moves the session to Cancelled', (
    tester,
  ) async {
    await tester.pumpWidget(createTestWidget());

    // Decline Maya's booking request.
    await tester.tap(find.text('Decline'));
    await tester.pumpAndSettle();

    // Switch to Cancelled tab.
    await tester.tap(find.text('Cancelled'));
    await tester.pumpAndSettle();

    expect(find.text('Maya Gurung'), findsOneWidget);
    expect(find.text('CANCELLED'), findsOneWidget);
  });

  testWidgets('Session provider contains booking request initially', (
    tester,
  ) async {
    late ProviderContainer container;

    await tester.pumpWidget(
      ProviderScope(
        child: Builder(
          builder: (context) {
            container = ProviderScope.containerOf(context);
            return const MaterialApp(home: SessionsScreen());
          },
        ),
      ),
    );

    final sessions = container.read(sessionProvider);

    expect(
      sessions.any((session) => session.patientName == 'Maya Gurung'),
      isTrue,
    );
  });
}
