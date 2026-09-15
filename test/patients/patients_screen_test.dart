
// import 'package:flutter/material.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:physioghar/screens/patients/patients_screen.dart';
// import 'package:physioghar/screens/patients/widgets/patient_empty_state.dart';
// import 'package:physioghar/screens/patients/widgets/patient_search_field.dart';

// import '../helpers/pump_app.dart';

// void main() {
//   group('PatientsScreen', () {
//     Future<void> openPatientsScreen(WidgetTester tester) async {
//       await pumpApp(tester);

//       await tester.tap(find.text('Patients'));
//       await tester.pumpAndSettle();
//     }

//     testWidgets('displays patient records', (tester) async {
//       await openPatientsScreen(tester);

//       expect(find.byType(PatientsScreen), findsOneWidget);

//       expect(find.text('Sita Sharma'), findsOneWidget);
//       expect(find.text('Ram Thapa'), findsOneWidget);

//       final maya = find.text('Maya Gurung');

//       await tester.scrollUntilVisible(
//         maya,
//         300,
//         scrollable: find.byType(Scrollable).last,
//       );

//       expect(maya, findsOneWidget);
//     });

//     testWidgets('displays patient search field', (tester) async {
//       await openPatientsScreen(tester);

//       expect(find.byType(PatientsScreen), findsOneWidget);
//       expect(find.byType(PatientSearchField), findsOneWidget);
//     });

//     testWidgets('filters patients when searching', (tester) async {
//       await openPatientsScreen(tester);

//       final searchField = find.byType(PatientSearchField);

//       await tester.enterText(
//         find.descendant(
//           of: searchField,
//           matching: find.byType(TextField),
//         ),
//         'Sita',
//       );

//       await tester.pumpAndSettle();

//       expect(find.text('Sita Sharma'), findsOneWidget);
//       expect(find.text('Ram Thapa'), findsNothing);
//       expect(find.text('Maya Gurung'), findsNothing);
//     });

//     testWidgets('shows empty state when no patient matches search',
//         (tester) async {
//       await openPatientsScreen(tester);

//       final searchField = find.byType(PatientSearchField);

//       await tester.enterText(
//         find.descendant(
//           of: searchField,
//           matching: find.byType(TextField),
//         ),
//         'Unknown Patient',
//       );

//       await tester.pumpAndSettle();

//       expect(
//         find.byType(PatientEmptyState),
//         findsOneWidget,
//       );
//     });

//     testWidgets('clears search and shows patients again', (tester) async {
//       await openPatientsScreen(tester);

//       final searchField = find.byType(PatientSearchField);

//       final textField = find.descendant(
//         of: searchField,
//         matching: find.byType(TextField),
//       );

//       await tester.enterText(textField, 'Sita');
//       await tester.pumpAndSettle();

//       expect(find.text('Sita Sharma'), findsOneWidget);
//       expect(find.text('Ram Thapa'), findsNothing);

//       await tester.enterText(textField, '');
//       await tester.pumpAndSettle();

//       expect(find.text('Sita Sharma'), findsOneWidget);
//       expect(find.text('Ram Thapa'), findsOneWidget);

//       final maya = find.text('Maya Gurung');

//       await tester.scrollUntilVisible(
//         maya,
//         300,
//         scrollable: find.byType(Scrollable).last,
//       );

//       expect(maya, findsOneWidget);
//     });
//   });
// }