// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:physioghar/screens/patients/patient_detail_screen.dart';
// import 'package:physioghar/screens/patients/widgets/patient_notes_section.dart';
// import 'package:physioghar/screens/patients/widgets/patient_info_card.dart';

// void main() {
//   group('PatientDetailScreen', () {
//     Future<void> openSitaDetail(WidgetTester tester) async {
//       await tester.pumpWidget(
//         const ProviderScope(
//           child: MaterialApp(
//             home: PatientDetailScreen(patientId: 'patient_001'),
//           ),
//         ),
//       );

//       await tester.pump();

//       expect(find.byType(PatientDetailScreen), findsOneWidget);
//     }

//     Future<void> scrollToNotes(WidgetTester tester) async {
//       final scrollView = find.byType(SingleChildScrollView);

//       expect(scrollView, findsOneWidget);

//       // Scroll the patient detail page down until the notes section
//       // is brought into the viewport.
//       for (var i = 0; i < 4; i++) {
//         await tester.drag(scrollView, const Offset(0, -500));

//         await tester.pumpAndSettle();
//       }

//       expect(find.byType(PatientNotesSection), findsOneWidget);
//     }

//     testWidgets('displays patient information', (tester) async {
//       await openSitaDetail(tester);

//       final patientInfoCard = find.byType(PatientInfoCard);

//       expect(
//         find.descendant(
//           of: patientInfoCard,
//           matching: find.text('Sita Sharma'),
//         ),
//         findsOneWidget,
//       );

//       expect(
//         find.descendant(of: patientInfoCard, matching: find.text('42 years')),
//         findsOneWidget,
//       );

//       expect(
//         find.descendant(of: patientInfoCard, matching: find.text('Female')),
//         findsOneWidget,
//       );

//       expect(
//         find.descendant(
//           of: patientInfoCard,
//           matching: find.text('+977 9812345678'),
//         ),
//         findsOneWidget,
//       );
//     });

//     testWidgets('displays previous patient notes', (tester) async {
//       await openSitaDetail(tester);

//       await scrollToNotes(tester);

//       expect(
//         find.textContaining(
//           'Patient reported reduced pain compared to previous session.',
//         ),
//         findsOneWidget,
//       );
//     });

//     testWidgets('adds a new patient note', (tester) async {
//       await openSitaDetail(tester);

//       await scrollToNotes(tester);

//       final addNoteButton = find.byKey(const Key('add-patient-note-button'));

//       expect(addNoteButton, findsOneWidget);

//       await tester.ensureVisible(addNoteButton);
//       await tester.pumpAndSettle();

//       await tester.tap(addNoteButton);
//       await tester.pumpAndSettle();

//       expect(find.byType(TextField), findsOneWidget);
//       expect(find.text('Add Note'), findsWidgets);

//       await tester.enterText(
//         find.byType(TextField),
//         'New exercise session note',
//       );

//       await tester.tap(find.text('Save'));
//       await tester.pumpAndSettle();

//       expect(find.text('New exercise session note'), findsOneWidget);
//     });

//     testWidgets('edits an existing patient note', (tester) async {
//       await openSitaDetail(tester);

//       await scrollToNotes(tester);

//       final editButton = find.byTooltip('Edit note').first;

//       expect(editButton, findsOneWidget);

//       await tester.ensureVisible(editButton);
//       await tester.tap(editButton);
//       await tester.pumpAndSettle();

//       expect(find.text('Edit Note'), findsOneWidget);

//       final textField = find.byType(TextField);

//       expect(textField, findsOneWidget);

//       await tester.enterText(textField, 'Updated patient session note');

//       await tester.tap(find.text('Update'));
//       await tester.pumpAndSettle();

//       expect(find.text('Updated patient session note'), findsOneWidget);
//     });

//     testWidgets('deletes an existing patient note after confirmation', (
//       tester,
//     ) async {
//       await openSitaDetail(tester);

//       await scrollToNotes(tester);

//       const deletedNotePreview =
//           'Patient reported reduced pain compared to previous session.';

//       expect(find.textContaining(deletedNotePreview), findsOneWidget);

//       final deleteButton = find.byTooltip('Delete note').first;

//       expect(deleteButton, findsOneWidget);

//       await tester.ensureVisible(deleteButton);
//       await tester.tap(deleteButton);
//       await tester.pumpAndSettle();

//       expect(find.text('Delete Note?'), findsOneWidget);

//       await tester.tap(find.text('Delete'));
//       await tester.pumpAndSettle();

//       // Sita has two notes, so another "Delete note" button
//       // should still exist. We only verify that the selected
//       // note was actually removed.
//       expect(find.textContaining(deletedNotePreview), findsNothing);
//     });
//   });
// }
