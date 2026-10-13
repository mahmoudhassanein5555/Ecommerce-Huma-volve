
import 'package:flutter_test/flutter_test.dart';

// ignore: avoid_relative_lib_imports
import '../lib/main.dart';

void main() {
  testWidgets('App starts successfully', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    // Advance the fake clock past the splash timer.
    await tester.pump(const Duration(seconds: 3));

    // Finish any pending navigation animations.
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
  });
}
