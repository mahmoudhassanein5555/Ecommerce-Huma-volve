// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ecommerce_app_huma_volve/features/auth/data/auth_service.dart';
import 'package:ecommerce_app_huma_volve/features/auth/login/screens/login_screen.dart';
import 'package:ecommerce_app_huma_volve/features/auth/models/auth_tokens.dart';
import 'package:ecommerce_app_huma_volve/features/splash/screens/splash_screen.dart';

void main() {
  testWidgets('login validates empty email and password', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: LoginScreen()));

    await tester.tap(find.text('Login').first);
    await tester.pumpAndSettle();

    expect(find.text('Please enter your email'), findsOneWidget);
    expect(find.text('Please enter your password'), findsOneWidget);
    expect(find.text('Welcome Back!'), findsOneWidget);
  });

  testWidgets('splash routes to login when no session is stored', (tester) async {
    final authService = AuthService(tokenStorage: EmptyAuthTokenStorage());
    await tester.pumpWidget(
      MaterialApp(home: SplashScreen(authService: authService)),
    );

    await tester.pump(const Duration(seconds: 3));
    await tester.pumpAndSettle();

    expect(find.text('Welcome Back!'), findsOneWidget);
  });
}

class EmptyAuthTokenStorage implements AuthTokenStorage {
  @override
  Future<String?> readAccessToken() async => null;

  @override
  Future<String?> readRefreshToken() async => null;

  @override
  Future<void> save(AuthTokens tokens) async {}

  @override
  Future<void> clear() async {}
}
