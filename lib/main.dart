import 'dart:async';

import 'package:flutter/material.dart';

import 'core/theme.dart';
import 'features/details/deep_link/product_deep_link_handler.dart';
import 'features/splash/screens/splash_screen.dart';

/// Shared by the deep-link handler so it can navigate from outside any
/// widget's own BuildContext (links can arrive at any time).
final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  StreamSubscription<Uri>? _deepLinkSubscription;

  @override
  void initState() {
    super.initState();
    // Links received while the app is already running (foreground or
    // background). The link that cold-launched the app is handled
    // separately, once splash has navigated away - see LoginScreen.
    _deepLinkSubscription = ProductDeepLinkHandler().listen(rootNavigatorKey);
  }

  @override
  void dispose() {
    _deepLinkSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: rootNavigatorKey,
      title: 'E-Commerce App',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const SplashScreen(),
    );
  }
}
