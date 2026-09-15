
// import 'package:flutter/material.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// import 'package:physioghar/screens/schedule/schedule_screen.dart';

// void main() {
//   group('ScheduleScreen - UI', () {
//     testWidgets('displays schedule screen title', (tester) async {
//       await pumpScheduleScreen(tester);

//       expect(find.text('Schedule'), findsOneWidget);
//     });

//     testWidgets('displays availability section', (tester) async {
//       await pumpScheduleScreen(tester);

//       expect(find.text('Available'), findsOneWidget);
//     });

//     testWidgets('displays 7 days in date selector', (tester) async {
//       await pumpScheduleScreen(tester);

//       final visibleDates = _getNextSevenDays();

//       for (final date in visibleDates) {
//         expect(
//           find.text(_shortWeekday(date.weekday)),
//           findsWidgets,
//         );
//       }
//     });

//     testWidgets('displays schedule legend', (tester) async {
//       await pumpScheduleScreen(tester);

//       expect(find.text('OPEN'), findsWidgets);
//       expect(find.text('BOOKED'), findsWidgets);
//       expect(find.text('BLOCKED'), findsWidgets);
//     });

//     testWidgets('displays add available slot button', (tester) async {
//       await pumpScheduleScreen(tester);

//       expect(find.text('Add Available Slot'), findsOneWidget);
//     });
//   });

//   group('ScheduleScreen - Mock Schedule', () {
//     testWidgets('displays OPEN slot', (tester) async {
//       await pumpScheduleScreen(tester);

//       final mondayVisible = await selectMonday(tester);

//       if (!mondayVisible) {
//         return;
//       }

//       expect(find.text('9:00 AM'), findsOneWidget);
//       expect(find.text('OPEN'), findsWidgets);
//     });

//     testWidgets('displays BOOKED slot', (tester) async {
//       await pumpScheduleScreen(tester);

//       final mondayVisible = await selectMonday(tester);

//       if (!mondayVisible) {
//         return;
//       }

//       expect(find.text('10:00 AM'), findsOneWidget);
//       expect(find.text('BOOKED'), findsWidgets);
//     });

//     testWidgets('displays another OPEN slot', (tester) async {
//       await pumpScheduleScreen(tester);

//       final mondayVisible = await selectMonday(tester);

//       if (!mondayVisible) {
//         return;
//       }

//       final blockedTime = find.text('12:00 PM');

//       await scrollScheduleUntilVisible(
//         tester,
//         blockedTime,
//       );

//       expect(blockedTime, findsOneWidget);
//       expect(find.text('11:00 AM'), findsOneWidget);
//       expect(find.text('OPEN'), findsWidgets);
//     });

//     testWidgets('displays blocked slots', (tester) async {
//       await pumpScheduleScreen(tester);

//       final mondayVisible = await selectMonday(tester);

//       if (!mondayVisible) {
//         return;
//       }

//       final twelvePmFinder = find.text('12:00 PM');

//       await scrollScheduleUntilVisible(
//         tester,
//         twelvePmFinder,
//       );

//       expect(twelvePmFinder, findsOneWidget);
//       expect(find.text('BLOCKED'), findsWidgets);

//       final onePmFinder = find.text('1:00 PM');

//       await scrollScheduleUntilVisible(
//         tester,
//         onePmFinder,
//       );

//       expect(onePmFinder, findsOneWidget);
//     });
//   });

//   group('ScheduleScreen - Date Selection', () {
//     testWidgets('today is selected initially', (tester) async {
//       await pumpScheduleScreen(tester);

//       final today = DateTime.now();
//       final weekday = _shortWeekday(today.weekday);

//       expect(find.text(weekday), findsWidgets);
//     });

//     testWidgets('can select another date', (tester) async {
//       await pumpScheduleScreen(tester);

//       final today = DateTime.now();
//       final nextDay = today.add(const Duration(days: 1));

//       final nextWeekday = _shortWeekday(nextDay.weekday);
//       final nextDayFinder = find.text(nextWeekday);

//       expect(nextDayFinder, findsWidgets);

//       await tester.tap(nextDayFinder.last);
//       await tester.pumpAndSettle();

//       expect(find.text('Schedule'), findsOneWidget);
//     });
//   });

//   group('ScheduleScreen - Availability', () {
//     testWidgets('availability switch is displayed', (tester) async {
//       await pumpScheduleScreen(tester);

//       expect(find.byType(Switch), findsOneWidget);
//     });

//     testWidgets('availability can be toggled', (tester) async {
//       await pumpScheduleScreen(tester);

//       final switchFinder = find.byType(Switch);

//       expect(switchFinder, findsOneWidget);

//       final initialValue = tester.widget<Switch>(switchFinder).value;

//       await tester.tap(switchFinder);
//       await tester.pumpAndSettle();

//       final updatedValue = tester.widget<Switch>(switchFinder).value;

//       expect(updatedValue, isNot(initialValue));
//     });
//   });

//   group('ScheduleScreen - Slot Interaction', () {
//     testWidgets('tapping OPEN slot opens management sheet', (tester) async {
//       await pumpScheduleScreen(tester);

//       final mondayVisible = await selectMonday(tester);

//       if (!mondayVisible) {
//         return;
//       }

//       final openTime = find.text('9:00 AM');

//       expect(openTime, findsOneWidget);

//       await tester.tap(openTime);
//       await tester.pumpAndSettle();

//       expect(find.text('Block Slot'), findsOneWidget);
//     });

//     testWidgets('tapping BLOCKED slot opens management sheet', (
//       tester,
//     ) async {
//       await pumpScheduleScreen(tester);

//       final mondayVisible = await selectMonday(tester);

//       if (!mondayVisible) {
//         return;
//       }

//       final blockedTime = find.text('12:00 PM');

//       await scrollScheduleUntilVisible(
//         tester,
//         blockedTime,
//       );

//       await tester.tap(blockedTime);
//       await tester.pumpAndSettle();

//       expect(find.text('Unblock Slot'), findsWidgets);
//     });

//     testWidgets('tapping BOOKED slot opens session details', (
//       tester,
//     ) async {
//       await pumpScheduleScreen(tester);

//       final mondayVisible = await selectMonday(tester);

//       if (!mondayVisible) {
//         return;
//       }

//       final bookedTime = find.text('10:00 AM');

//       expect(bookedTime, findsOneWidget);

//       await tester.tap(bookedTime);
//       await tester.pumpAndSettle();

//       expect(find.text('Booked Session'), findsOneWidget);
//     });
//   });

//   group('ScheduleScreen - Block / Unblock', () {
//     testWidgets('OPEN slot can be changed to BLOCKED', (tester) async {
//       await pumpScheduleScreen(tester);

//       final mondayVisible = await selectMonday(tester);

//       if (!mondayVisible) {
//         return;
//       }

//       await tester.tap(find.text('9:00 AM'));
//       await tester.pumpAndSettle();

//       expect(find.text('Block Slot'), findsOneWidget);

//       await tester.tap(find.text('Block Slot'));
//       await tester.pumpAndSettle();

//       expect(find.text('BLOCKED'), findsWidgets);
//     });

//     testWidgets('BLOCKED slot can be changed to OPEN', (tester) async {
//       await pumpScheduleScreen(tester);

//       final mondayVisible = await selectMonday(tester);

//       if (!mondayVisible) {
//         return;
//       }

//       final blockedTime = find.text('12:00 PM');

//       await scrollScheduleUntilVisible(
//         tester,
//         blockedTime,
//       );

//       await tester.tap(blockedTime);
//       await tester.pumpAndSettle();

//       expect(find.text('Unblock Slot'), findsWidgets);

//       await tester.tap(find.text('Unblock Slot').last);
//       await tester.pumpAndSettle();

//       expect(find.text('OPEN'), findsWidgets);
//     });
//   });

//   group('ScheduleScreen - Delete Slot', () {
//     testWidgets('OPEN slot shows delete option', (tester) async {
//       await pumpScheduleScreen(tester);

//       final mondayVisible = await selectMonday(tester);

//       if (!mondayVisible) {
//         return;
//       }

//       await tester.tap(find.text('9:00 AM'));
//       await tester.pumpAndSettle();

//       expect(find.text('Delete Slot'), findsOneWidget);
//     });

//     testWidgets('BLOCKED slot shows delete option', (tester) async {
//       await pumpScheduleScreen(tester);

//       final mondayVisible = await selectMonday(tester);

//       if (!mondayVisible) {
//         return;
//       }

//       final blockedTime = find.text('12:00 PM');

//       await scrollScheduleUntilVisible(
//         tester,
//         blockedTime,
//       );

//       await tester.tap(blockedTime);
//       await tester.pumpAndSettle();

//       expect(find.text('Delete Slot'), findsOneWidget);
//     });

//     testWidgets('BOOKED slot does not show delete option', (tester) async {
//       await pumpScheduleScreen(tester);

//       final mondayVisible = await selectMonday(tester);

//       if (!mondayVisible) {
//         return;
//       }

//       await tester.tap(find.text('10:00 AM'));
//       await tester.pumpAndSettle();

//       expect(find.text('Delete Slot'), findsNothing);
//     });

//     testWidgets('cancel delete keeps slot', (tester) async {
//       await pumpScheduleScreen(tester);

//       final mondayVisible = await selectMonday(tester);

//       if (!mondayVisible) {
//         return;
//       }

//       await tester.tap(find.text('9:00 AM'));
//       await tester.pumpAndSettle();

//       await tester.tap(find.text('Delete Slot'));
//       await tester.pumpAndSettle();

//       expect(find.text('Delete Slot?'), findsOneWidget);

//       await tester.tap(find.text('Cancel'));
//       await tester.pumpAndSettle();

//       expect(find.text('9:00 AM'), findsOneWidget);
//     });

//     testWidgets('confirm delete removes OPEN slot', (tester) async {
//       await pumpScheduleScreen(tester);

//       final mondayVisible = await selectMonday(tester);

//       if (!mondayVisible) {
//         return;
//       }

//       await tester.tap(find.text('9:00 AM'));
//       await tester.pumpAndSettle();

//       await tester.tap(find.text('Delete Slot'));
//       await tester.pumpAndSettle();

//       expect(find.text('Delete Slot?'), findsOneWidget);

//       await tester.tap(find.text('Delete Slot'));
//       await tester.pumpAndSettle();

//       expect(find.text('9:00 AM'), findsNothing);
//     });
//   });

//   group('ScheduleScreen - Add Slot', () {
//     testWidgets('opens add slot bottom sheet', (tester) async {
//       await pumpScheduleScreen(tester);

//       await tester.tap(find.text('Add Available Slot'));
//       await tester.pumpAndSettle();

//       expect(find.text('Add Available Slot'), findsWidgets);
//     });

//     testWidgets('shows time selection in add slot sheet', (tester) async {
//       await pumpScheduleScreen(tester);

//       await tester.tap(find.text('Add Available Slot'));
//       await tester.pumpAndSettle();

//       expect(find.byType(TimePickerDialog), findsNothing);
//     });
//   });

//   group('ScheduleScreen - Empty State', () {
//     testWidgets(
//       'shows empty state when selected date has no slots',
//       (tester) async {
//         await pumpScheduleScreen(tester);

//         final visibleDates = _getNextSevenDays();

//         DateTime? emptyDate;

//         for (final date in visibleDates) {
//           if (date.weekday != DateTime.monday) {
//             emptyDate = date;
//             break;
//           }
//         }

//         expect(emptyDate, isNotNull);

//         final weekdayFinder = find.text(
//           _shortWeekday(emptyDate!.weekday),
//         );

//         expect(weekdayFinder, findsWidgets);

//         await tester.tap(weekdayFinder.last);
//         await tester.pumpAndSettle();

//         expect(
//           find.text(
//             'No time slots available. '
//             'Add an available slot to start managing your schedule.',
//           ),
//           findsOneWidget,
//         );
//       },
//     );
//   });
// }

// Future<void> scrollScheduleUntilVisible(
//   WidgetTester tester,
//   Finder target,
// ) async {
//   for (var i = 0; i < 5; i++) {
//     if (target.evaluate().isNotEmpty) {
//       return;
//     }

//     await tester.drag(
//       find.byKey(const Key('schedule-slots-list')),
//       const Offset(0, -300),
//     );

//     await tester.pumpAndSettle();
//   }
// }

// Future<void> pumpScheduleScreen(
//   WidgetTester tester,
// ) async {
//   await tester.pumpWidget(
//     const ProviderScope(
//       child: MaterialApp(
//         home: Scaffold(
//           body: ScheduleScreen(),
//         ),
//       ),
//     ),
//   );

//   await tester.pumpAndSettle();
// }

// List<DateTime> _getNextSevenDays() {
//   final today = DateTime.now();

//   final startDate = DateTime(
//     today.year,
//     today.month,
//     today.day,
//   );

//   return List.generate(
//     7,
//     (index) => startDate.add(
//       Duration(days: index),
//     ),
//   );
// }

// String _shortWeekday(int weekday) {
//   const weekdays = [
//     'MON',
//     'TUE',
//     'WED',
//     'THU',
//     'FRI',
//     'SAT',
//     'SUN',
//   ];

//   return weekdays[weekday - 1];
// }

// /// Selects Monday only when Monday is inside
// /// the current rolling 7-day date selector.
// ///
// /// Returns false when Monday is not currently visible.
// Future<bool> selectMonday(
//   WidgetTester tester,
// ) async {
//   final mondayFinder = find.text('MON');

//   if (mondayFinder.evaluate().isEmpty) {
//     return false;
//   }

//   await tester.tap(mondayFinder.last);
//   await tester.pumpAndSettle();

//   return true;
// }
