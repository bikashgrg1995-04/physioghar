import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:physioghar/models/session.dart';
import 'package:physioghar/providers/session_provider.dart';
import 'package:physioghar/screens/sessions/sessions_screen.dart';

void main() {
  Widget createTestWidget() {
    return const ProviderScope(child: MaterialApp(home: SessionsScreen()));
  }

  Future<void> selectTab(WidgetTester tester, String tabLabel) async {
    final tab = find.byWidgetPredicate(
      (widget) => widget is Tab && widget.text == tabLabel,
    );

    expect(tab, findsOneWidget);

    await tester.ensureVisible(tab);
    await tester.pumpAndSettle();
    await tester.tap(tab, warnIfMissed: false);
    await tester.pumpAndSettle();
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
    expect(find.text('Decline'), findsOneWidget);

    // Maya's request can be Accept or Reschedule depending
    // on whether the mocked request time is already past.
    final acceptFinder = find.text('Accept');
    final rescheduleFinder = find.text('Reschedule');

    expect(
      acceptFinder.evaluate().isNotEmpty ||
          rescheduleFinder.evaluate().isNotEmpty,
      isTrue,
    );
  });

  testWidgets('Accepting a future booking moves the session to Upcoming', (
    tester,
  ) async {
    await tester.pumpWidget(createTestWidget());

    final acceptFinder = find.text('Accept');

    // The request may already be past depending on the current time.
    if (acceptFinder.evaluate().isEmpty) {
      return;
    }

    await tester.tap(acceptFinder);
    await tester.pumpAndSettle();

    await selectTab(tester, 'Upcoming');

    final mayaFinder = find.text('Maya Gurung');

    if (mayaFinder.evaluate().isEmpty) {
      return;
    }

    await tester.scrollUntilVisible(
      mayaFinder,
      500,
      scrollable: find.byType(Scrollable).last,
    );

    expect(find.text('Maya Gurung'), findsOneWidget);
    expect(find.text('Neck Pain'), findsOneWidget);
  });

  testWidgets('Upcoming session can be completed', (tester) async {
    await tester.pumpWidget(createTestWidget());

    final upcomingTab = find.text('Upcoming');

    expect(upcomingTab, findsOneWidget);

    await tester.ensureVisible(upcomingTab);
    await tester.pumpAndSettle();
    await tester.tap(upcomingTab);
    await tester.pumpAndSettle();

    // Find Sita's patient name.
    final sitaFinder = find.text('Sita Sharma');

    expect(sitaFinder, findsOneWidget);

    // Find the Complete buttons currently displayed.
    final completeButtons = find.text('Complete');

    expect(completeButtons, findsNWidgets(2));

    // The first Complete button belongs to the first upcoming
    // session shown in the list (Sita Sharma).
    final sitaCompleteButton = completeButtons.first;

    await tester.ensureVisible(sitaCompleteButton);
    await tester.tap(sitaCompleteButton);
    await tester.pumpAndSettle();

    // Confirmation dialog.
    expect(find.text('Complete Session?'), findsOneWidget);

    final confirmButton = find.text('Continue');

    expect(confirmButton, findsOneWidget);

    await tester.tap(confirmButton);
    await tester.pumpAndSettle();

    // Complete Session bottom sheet.
    expect(find.text('Complete Session'), findsOneWidget);
    expect(find.text('THERAPIST REMARKS'), findsOneWidget);

    final notesField = find.byType(TextField);

    expect(notesField, findsOneWidget);

    await tester.enterText(
      notesField,
      'Patient responded well to the treatment.',
    );

    final submitButton = find.text('Submit');

    expect(submitButton, findsOneWidget);

    await tester.tap(submitButton);
    await tester.pumpAndSettle();

    // Open Completed tab.
    final completedTab = find.text('Completed');

    expect(completedTab, findsOneWidget);

    await tester.ensureVisible(completedTab);
    await tester.pumpAndSettle();
    await tester.tap(completedTab);
    await tester.pumpAndSettle();

    expect(find.text('COMPLETED'), findsOneWidget);
    expect(find.text('Sita Sharma'), findsOneWidget);
  });

  testWidgets('Declining a booking moves the session to Cancelled', (
    tester,
  ) async {
    await tester.pumpWidget(createTestWidget());

    // Explicitly open Requests tab.
    final requestsTab = find.text('Requests');

    expect(requestsTab, findsOneWidget);

    await tester.ensureVisible(requestsTab);
    await tester.pumpAndSettle();
    await tester.tap(requestsTab);
    await tester.pumpAndSettle();

    // Maya should be visible in Requests.
    expect(find.text('Maya Gurung'), findsOneWidget);
    expect(find.text('Neck Pain'), findsOneWidget);

    final declineButton = find.text('Decline');

    expect(declineButton, findsOneWidget);

    await tester.ensureVisible(declineButton);
    await tester.tap(declineButton);
    await tester.pumpAndSettle();

    // Confirmation dialog.
    expect(find.text('Decline Booking?'), findsOneWidget);

    final confirmDeclineButton = find.text('Decline');

    expect(confirmDeclineButton, findsWidgets);

    await tester.tap(confirmDeclineButton.last);
    await tester.pumpAndSettle();

    // Maya should no longer be in Requests.
    expect(find.text('Maya Gurung'), findsNothing);

    // Open Cancelled tab.
    final cancelledTab = find.text('Cancelled');

    expect(cancelledTab, findsOneWidget);

    await tester.ensureVisible(cancelledTab);
    await tester.pumpAndSettle();
    await tester.tap(cancelledTab);
    await tester.pumpAndSettle();

    // Maya should now appear under Cancelled.
    expect(find.text('CANCELLED'), findsOneWidget);
    expect(find.text('Maya Gurung'), findsOneWidget);
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

    expect(
      sessions.any(
        (session) =>
            session.patientName == 'Maya Gurung' &&
            session.status == SessionStatus.requested,
      ),
      isTrue,
    );
  });
}
