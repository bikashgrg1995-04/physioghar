import 'package:flutter_test/flutter_test.dart';
import 'package:physioghar/app/app.dart';

void main() {
  testWidgets('PhysioGhar app loads successfully', (tester) async {
    await tester.pumpWidget(const PhysioGharApp());

    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Schedule'), findsOneWidget);
    expect(find.text('Sessions'), findsOneWidget);
    expect(find.text('Patients'), findsOneWidget);
    expect(find.text('Profile'), findsOneWidget);
  });
}