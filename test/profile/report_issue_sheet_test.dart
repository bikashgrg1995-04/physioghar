// import 'package:flutter/material.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:physioghar/screens/profile/widgets/report_issue_sheet.dart';

// void main() {
//   Widget buildTestWidget() {
//     return const MaterialApp(
//       home: Scaffold(
//         body: SizedBox(),
//       ),
//     );
//   }

//   Future<void> openReportIssueSheet(
//     WidgetTester tester,
//   ) async {
//     await tester.pumpWidget(buildTestWidget());

//     final scaffoldContext = tester.element(
//       find.byType(Scaffold),
//     );

//     showModalBottomSheet<bool>(
//       context: scaffoldContext,
//       isScrollControlled: true,
//       builder: (_) {
//         return const ReportIssueSheet();
//       },
//     );

//     await tester.pumpAndSettle();
//   }

//   group('ReportIssueSheet', () {
//     testWidgets(
//       'displays complaint form fields',
//       (tester) async {
//         await openReportIssueSheet(tester);

//         expect(
//           find.text('Report an Issue'),
//           findsOneWidget,
//         );

//         expect(
//           find.text('CATEGORY'),
//           findsOneWidget,
//         );

//         expect(
//           find.text('SUBJECT'),
//           findsOneWidget,
//         );

//         expect(
//           find.text('DESCRIPTION'),
//           findsOneWidget,
//         );

//         expect(
//           find.text('Submit Complaint'),
//           findsOneWidget,
//         );

//         expect(
//           find.text('Patient Issue'),
//           findsOneWidget,
//         );
//       },
//     );

//     testWidgets(
//       'shows validation errors when submitting empty form',
//       (tester) async {
//         await openReportIssueSheet(tester);

//         await tester.tap(
//           find.text('Submit Complaint'),
//         );

//         await tester.pumpAndSettle();

//         expect(
//           find.text('Please enter a subject'),
//           findsOneWidget,
//         );

//         expect(
//           find.text('Please describe the issue'),
//           findsOneWidget,
//         );
//       },
//     );

//     testWidgets(
//       'allows changing complaint category',
//       (tester) async {
//         await openReportIssueSheet(tester);

//         await tester.tap(
//           find.text('Patient Issue'),
//         );

//         await tester.pumpAndSettle();

//         expect(
//           find.text('Booking Issue'),
//           findsOneWidget,
//         );

//         await tester.tap(
//           find.text('Booking Issue'),
//         );

//         await tester.pumpAndSettle();

//         expect(
//           find.text('Booking Issue'),
//           findsOneWidget,
//         );
//       },
//     );

//     testWidgets(
//       'returns true after submitting valid complaint',
//       (tester) async {
//         await tester.pumpWidget(buildTestWidget());

//         final scaffoldContext = tester.element(
//           find.byType(Scaffold),
//         );

//         final resultFuture = showModalBottomSheet<bool>(
//           context: scaffoldContext,
//           isScrollControlled: true,
//           builder: (_) {
//             return const ReportIssueSheet();
//           },
//         );

//         await tester.pumpAndSettle();

//         final textFields = find.byType(TextFormField);

//         expect(
//           textFields,
//           findsNWidgets(2),
//         );

//         await tester.enterText(
//           textFields.at(0),
//           'Unable to update booking',
//         );

//         await tester.enterText(
//           textFields.at(1),
//           'The booking status is not updating correctly.',
//         );

//         await tester.tap(
//           find.text('Submit Complaint'),
//         );

//         await tester.pumpAndSettle();

//         final result = await resultFuture;

//         expect(
//           result,
//           isTrue,
//         );
//       },
//     );
//   });
// }