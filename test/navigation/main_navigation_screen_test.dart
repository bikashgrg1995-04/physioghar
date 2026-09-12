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
}