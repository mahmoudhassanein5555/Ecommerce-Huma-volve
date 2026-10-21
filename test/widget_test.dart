// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';

import 'package:ecommerce_app_huma_volve/main.dart';

void main() {
  testWidgets('app shows the splash screen', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    expect(find.text('Huma-volve'), findsOneWidget);
    expect(find.text('Your Ultimate E-Commerce App'), findsOneWidget);
  });
}
