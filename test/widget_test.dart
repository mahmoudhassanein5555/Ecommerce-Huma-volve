import 'package:flutter_test/flutter_test.dart';

import 'package:ecommerce_app_huma_volve/core/di/service_locator.dart';
import 'package:ecommerce_app_huma_volve/main.dart';

void main() {
  setUpAll(setupServiceLocator);

  tearDownAll(() => getIt.reset());

  testWidgets('app shows splash branding', (tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('Huma-volve'), findsOneWidget);
    expect(find.text('Your Ultimate E-Commerce App'), findsOneWidget);

    await tester.pump(const Duration(seconds: 2));
    await tester.pumpAndSettle();

    expect(find.text('Welcome Back!'), findsOneWidget);
  });
}
