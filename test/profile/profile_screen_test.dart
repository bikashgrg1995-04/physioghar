// import 'package:flutter/material.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:physioghar/screens/profile/profile_screen.dart';

// void main() {
//   Widget buildTestWidget() {
//     return const ProviderScope(
//       child: MaterialApp(home: Scaffold(body: ProfileScreen())),
//     );
//   }

//   Future<void> scrollToText(WidgetTester tester, String text) async {
//     final finder = find.text(text);

//     expect(finder, findsOneWidget);

//     await tester.ensureVisible(finder);
//     await tester.pumpAndSettle();
//   }

//   group('ProfileScreen', () {
//     testWidgets('displays therapist profile information', (tester) async {
//       await tester.pumpWidget(buildTestWidget());
//       await tester.pumpAndSettle();

//       expect(find.text('Dr. Anisha Sharma'), findsOneWidget);

//       expect(find.text('anisha@physioghar.com'), findsOneWidget);

//       expect(find.text('+977 9800000000'), findsOneWidget);

//       expect(find.text('5 years'), findsOneWidget);

//       expect(find.text('Physiotherapist'), findsWidgets);

//       expect(find.text('Bharatpur, Chitwan'), findsOneWidget);

//       expect(find.text('Therapist Details'), findsOneWidget);

//       expect(find.text('Settings'), findsOneWidget);

//       expect(find.text('Logout'), findsOneWidget);
//     });

//     testWidgets(
//       'opens settings and displays availability and language options',
//       (tester) async {
//         await tester.pumpWidget(buildTestWidget());
//         await tester.pumpAndSettle();

//         await scrollToText(tester, 'Settings');

//         await tester.tap(find.text('Settings'));
//         await tester.pumpAndSettle();

//         expect(find.text('Settings'), findsNWidgets(2));

//         expect(find.text('Availability'), findsOneWidget);

//         expect(find.text('Language'), findsOneWidget);

//         expect(find.text('English'), findsOneWidget);

//         expect(find.text('ENG'), findsOneWidget);

//         expect(find.text('NP'), findsOneWidget);
//       },
//     );

//     testWidgets('changes language from English to Nepali', (tester) async {
//       await tester.pumpWidget(buildTestWidget());
//       await tester.pumpAndSettle();

//       await scrollToText(tester, 'Settings');

//       await tester.tap(find.text('Settings'));
//       await tester.pumpAndSettle();

//       expect(find.text('Language'), findsOneWidget);

//       expect(find.text('English'), findsOneWidget);

//       await tester.tap(find.text('NP'));
//       await tester.pumpAndSettle();

//       expect(find.text('भाषा'), findsOneWidget);

//       expect(find.text('नेपाली'), findsOneWidget);

//       expect(find.text('Language'), findsNothing);
//     });

//     testWidgets('changes availability status', (tester) async {
//       await tester.pumpWidget(buildTestWidget());
//       await tester.pumpAndSettle();

//       await scrollToText(tester, 'Settings');

//       await tester.tap(find.text('Settings'));
//       await tester.pumpAndSettle();

//       final switchFinder = find.byType(Switch);

//       expect(switchFinder, findsOneWidget);

//       final initialSwitch = tester.widget<Switch>(switchFinder);

//       expect(initialSwitch.value, isTrue);

//       await tester.tap(switchFinder);
//       await tester.pumpAndSettle();

//       final updatedSwitch = tester.widget<Switch>(switchFinder);

//       expect(updatedSwitch.value, isFalse);

//       expect(find.text('You are currently unavailable'), findsOneWidget);
//     });

//     testWidgets('opens edit profile dialog', (tester) async {
//       await tester.pumpWidget(buildTestWidget());
//       await tester.pumpAndSettle();

//       final editIcon = find.byWidgetPredicate((widget) {
//         if (widget is! Icon) {
//           return false;
//         }

//         return widget.icon == Icons.edit || widget.icon == Icons.edit_outlined;
//       });

//       expect(editIcon, findsOneWidget);

//       await tester.tap(editIcon);
//       await tester.pumpAndSettle();

//       expect(find.text('Edit Profile'), findsOneWidget);
//     });

//     testWidgets('opens logout confirmation dialog', (tester) async {
//       await tester.pumpWidget(buildTestWidget());
//       await tester.pumpAndSettle();

//       await scrollToText(tester, 'Logout');

//       await tester.tap(find.text('Logout'));
//       await tester.pumpAndSettle();

//       expect(find.text('Are you sure you want to logout?'), findsOneWidget);

//       expect(find.text('Cancel'), findsOneWidget);

//       expect(find.text('Logout'), findsNWidgets(3));
//     });

//     testWidgets('canceling logout closes confirmation dialog', (tester) async {
//       await tester.pumpWidget(buildTestWidget());
//       await tester.pumpAndSettle();

//       await scrollToText(tester, 'Logout');

//       await tester.tap(find.text('Logout'));
//       await tester.pumpAndSettle();

//       expect(find.text('Are you sure you want to logout?'), findsOneWidget);

//       await tester.tap(find.text('Cancel'));
//       await tester.pumpAndSettle();

//       expect(find.text('Are you sure you want to logout?'), findsNothing);

//       expect(find.text('Logout'), findsOneWidget);
//     });

//     testWidgets('confirming logout displays success message', (tester) async {
//       await tester.pumpWidget(buildTestWidget());
//       await tester.pumpAndSettle();

//       await scrollToText(tester, 'Logout');

//       await tester.tap(find.text('Logout'));
//       await tester.pumpAndSettle();

//       expect(find.text('Are you sure you want to logout?'), findsOneWidget);

//       // The first Logout belongs to the profile action.
//       // The last Logout belongs to the confirmation dialog.
//       await tester.tap(find.text('Logout').last);

//       await tester.pumpAndSettle();

//       expect(find.text('Logged out successfully'), findsOneWidget);
//     });
//   });
// }
