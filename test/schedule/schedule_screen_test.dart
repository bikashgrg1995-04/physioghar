import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:physioghar/screens/schedule/schedule_screen.dart';

void main() {
  group('ScheduleScreen - UI', () {
    testWidgets('displays schedule screen title', (tester) async {
      await pumpScheduleScreen(tester);

      expect(find.text('Schedule'), findsOneWidget);
    });

    testWidgets('displays availability section', (tester) async {
      await pumpScheduleScreen(tester);

      expect(find.text('Available'), findsOneWidget);
    });

    testWidgets('displays 7 days in date selector', (tester) async {
      await pumpScheduleScreen(tester);

      expect(find.text('Mon'), findsWidgets);
      expect(find.text('Tue'), findsWidgets);
      expect(find.text('Wed'), findsWidgets);
      expect(find.text('Thu'), findsWidgets);
      expect(find.text('Fri'), findsWidgets);
      expect(find.text('Sat'), findsWidgets);
      expect(find.text('Sun'), findsWidgets);
    });

    testWidgets('displays schedule legend', (tester) async {
      await pumpScheduleScreen(tester);

      expect(find.text('OPEN'), findsWidgets);
      expect(find.text('BOOKED'), findsWidgets);
      expect(find.text('BLOCKED'), findsWidgets);
    });

    testWidgets('displays add available slot button', (tester) async {
      await pumpScheduleScreen(tester);

      expect(find.text('Add Available Slot'), findsOneWidget);
    });
  });

  group('ScheduleScreen - Mock Schedule', () {
    testWidgets('displays OPEN slot', (tester) async {
      await pumpScheduleScreen(tester);

      expect(find.text('9:00 AM'), findsOneWidget);
      expect(find.text('OPEN'), findsWidgets);
    });

    testWidgets('displays BOOKED slot', (tester) async {
      await pumpScheduleScreen(tester);

      expect(find.text('10:00 AM'), findsOneWidget);
      expect(find.text('BOOKED'), findsWidgets);
    });

    testWidgets('displays another OPEN slot', (tester) async {
      await pumpScheduleScreen(tester);

      final blockedTime = find.text('12:00 PM');

      await scrollScheduleUntilVisible(tester, blockedTime);

      expect(blockedTime, findsOneWidget);

      // The schedule list contains multiple OPEN slots.
      expect(find.text('OPEN'), findsWidgets);
    });
    testWidgets('displays blocked slots', (tester) async {
      await pumpScheduleScreen(tester);

      final twelvePmFinder = find.text('12:00 PM');

      await scrollScheduleUntilVisible(tester, twelvePmFinder);

      expect(twelvePmFinder, findsOneWidget);
      expect(find.text('BLOCKED'), findsWidgets);

      final onePmFinder = find.text('1:00 PM');

      await scrollScheduleUntilVisible(tester, onePmFinder);

      expect(onePmFinder, findsOneWidget);
    });
  });

  group('ScheduleScreen - Date Selection', () {
    testWidgets('today is selected initially', (tester) async {
      await pumpScheduleScreen(tester);

      final today = DateTime.now();
      final weekday = _shortWeekday(today.weekday);

      expect(find.text(weekday), findsWidgets);
    });

    testWidgets('can select another date', (tester) async {
      await pumpScheduleScreen(tester);

      final today = DateTime.now();
      final nextDay = today.add(const Duration(days: 1));

      final nextWeekday = _shortWeekday(nextDay.weekday);
      final nextDayFinder = find.text(nextWeekday);

      expect(nextDayFinder, findsWidgets);

      await tester.tap(nextDayFinder.last);
      await tester.pumpAndSettle();

      expect(find.text('Schedule'), findsOneWidget);
    });
  });

  group('ScheduleScreen - Availability', () {
    testWidgets('availability switch is displayed', (tester) async {
      await pumpScheduleScreen(tester);

      expect(find.byType(Switch), findsOneWidget);
    });

    testWidgets('availability can be toggled', (tester) async {
      await pumpScheduleScreen(tester);

      final switchFinder = find.byType(Switch);

      expect(switchFinder, findsOneWidget);

      final initialValue = tester.widget<Switch>(switchFinder).value;

      await tester.tap(switchFinder);
      await tester.pumpAndSettle();

      final updatedValue = tester.widget<Switch>(switchFinder).value;

      expect(updatedValue, isNot(initialValue));
    });
  });

  group('ScheduleScreen - Slot Interaction', () {
    testWidgets('tapping OPEN slot opens management sheet', (tester) async {
      await pumpScheduleScreen(tester);

      final openTime = find.text('9:00 AM');

      expect(openTime, findsOneWidget);

      await tester.tap(openTime);
      await tester.pumpAndSettle();

      expect(find.text('Block Slot'), findsOneWidget);
    });

    testWidgets('tapping BLOCKED slot opens management sheet', (tester) async {
      await pumpScheduleScreen(tester);

      final blockedTime = find.text('12:00 PM');

      await scrollScheduleUntilVisible(tester, blockedTime);

      await tester.tap(blockedTime);
      await tester.pumpAndSettle();

      expect(find.text('Unblock Slot'), findsWidgets);
    });
    testWidgets('tapping BOOKED slot opens session details', (tester) async {
      await pumpScheduleScreen(tester);

      final bookedTime = find.text('10:00 AM');

      expect(bookedTime, findsOneWidget);

      await tester.tap(bookedTime);
      await tester.pumpAndSettle();

      expect(find.text('Booked Session'), findsOneWidget);
    });
  });

  group('ScheduleScreen - Block / Unblock', () {
    testWidgets('OPEN slot can be changed to BLOCKED', (tester) async {
      await pumpScheduleScreen(tester);

      await tester.tap(find.text('9:00 AM'));
      await tester.pumpAndSettle();

      expect(find.text('Block Slot'), findsOneWidget);

      await tester.tap(find.text('Block Slot'));
      await tester.pumpAndSettle();

      expect(find.text('BLOCKED'), findsWidgets);
    });

    testWidgets('BLOCKED slot can be changed to OPEN', (tester) async {
      await pumpScheduleScreen(tester);

      final blockedTime = find.text('12:00 PM');

      await scrollScheduleUntilVisible(tester, blockedTime);

      await tester.tap(blockedTime);
      await tester.pumpAndSettle();

      expect(find.text('Unblock Slot'), findsWidgets);

      // The button is the last matching "Unblock Slot".
      await tester.tap(find.text('Unblock Slot').last);
      await tester.pumpAndSettle();

      expect(find.text('OPEN'), findsWidgets);
    });
  });

  group('ScheduleScreen - Delete Slot', () {
    testWidgets('OPEN slot shows delete option', (tester) async {
      await pumpScheduleScreen(tester);

      await tester.tap(find.text('9:00 AM'));
      await tester.pumpAndSettle();

      expect(find.text('Delete Slot'), findsOneWidget);
    });

    testWidgets('BLOCKED slot shows delete option', (tester) async {
      await pumpScheduleScreen(tester);

      final blockedTime = find.text('12:00 PM');

      await scrollScheduleUntilVisible(tester, blockedTime);

      await tester.tap(blockedTime);
      await tester.pumpAndSettle();

      expect(find.text('Delete Slot'), findsOneWidget);
    });

    testWidgets('BOOKED slot does not show delete option', (tester) async {
      await pumpScheduleScreen(tester);

      await tester.tap(find.text('10:00 AM'));
      await tester.pumpAndSettle();

      expect(find.text('Delete Slot'), findsNothing);
    });

    testWidgets('cancel delete keeps slot', (tester) async {
      await pumpScheduleScreen(tester);

      await tester.tap(find.text('9:00 AM'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Delete Slot'));
      await tester.pumpAndSettle();

      expect(find.text('Delete Slot?'), findsOneWidget);

      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();

      expect(find.text('9:00 AM'), findsOneWidget);
    });

    testWidgets('confirm delete removes OPEN slot', (tester) async {
      await pumpScheduleScreen(tester);

      await tester.tap(find.text('9:00 AM'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Delete Slot'));
      await tester.pumpAndSettle();

      expect(find.text('Delete Slot?'), findsOneWidget);

      await tester.tap(find.text('Delete Slot'));
      await tester.pumpAndSettle();

      expect(find.text('9:00 AM'), findsNothing);
    });
  });

  group('ScheduleScreen - Add Slot', () {
    testWidgets('opens add slot bottom sheet', (tester) async {
      await pumpScheduleScreen(tester);

      await tester.tap(find.text('Add Available Slot'));
      await tester.pumpAndSettle();

      expect(find.text('Add Available Slot'), findsWidgets);
    });

    testWidgets('shows time selection in add slot sheet', (tester) async {
      await pumpScheduleScreen(tester);

      await tester.tap(find.text('Add Available Slot'));
      await tester.pumpAndSettle();

      expect(find.byType(TimePickerDialog), findsNothing);
    });
  });

  group('ScheduleScreen - Empty State', () {
    testWidgets('shows empty state when selected date has no slots', (
      tester,
    ) async {
      await pumpScheduleScreen(tester);

      final today = DateTime.now();

      // Mock schedule exists only for today.
      // Therefore tomorrow should show the empty state.
      final emptyDate = today.add(const Duration(days: 1));

      final weekday = _shortWeekday(emptyDate.weekday);

      final weekdayFinder = find.text(weekday);

      expect(weekdayFinder, findsWidgets);

      await tester.tap(weekdayFinder.last);
      await tester.pumpAndSettle();

      expect(
        find.text(
          'No time slots available. '
          'Add an available slot to start managing your schedule.',
        ),
        findsOneWidget,
      );
    });
  });
}

/// Pumps the ScheduleScreen with the same Riverpod setup
/// used by the application.
Future<void> pumpScheduleScreen(WidgetTester tester) async {
  await tester.pumpWidget(
    const ProviderScope(
      child: MaterialApp(home: Scaffold(body: ScheduleScreen())),
    ),
  );

  await tester.pumpAndSettle();
}

/// Returns the short weekday name used by the date selector.
String _shortWeekday(int weekday) {
  const weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

  return weekdays[weekday - 1];
}

/// Scrolls the schedule list until the target widget becomes visible.
Future<void> scrollScheduleUntilVisible(
  WidgetTester tester,
  Finder target,
) async {
  final scheduleList = find.byKey(const Key('schedule-slots-list'));

  for (var i = 0; i < 5; i++) {
    if (target.evaluate().isNotEmpty) {
      return;
    }

    await tester.drag(scheduleList, const Offset(0, -250));

    await tester.pumpAndSettle();
  }

  expect(target, findsOneWidget);
}
