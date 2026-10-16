
import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';

import 'core/theme.dart';
import 'features/home/screens/product_details_screen.dart';
import 'features/main_navigation/screens/main_navigation_screen.dart';
import 'features/splash/screens/splash_screen.dart';

final GlobalKey<NavigatorState> appNavigatorKey =
    GlobalKey<NavigatorState>();

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final AppLinks _appLinks = AppLinks();
  StreamSubscription<Uri>? _linkSubscription;

  @override
  void initState() {
    super.initState();

    _linkSubscription = _appLinks.uriLinkStream.listen(
      _handleIncomingLink,
    );
  }

  void _handleIncomingLink(Uri uri) {
    final int? productId = _extractProductId(uri);

    if (productId == null) return;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final navigator = appNavigatorKey.currentState;

      if (navigator == null) return;

      navigator.pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (_) => MainNavigationScreen(),
        ),
        (route) => false,
      );

      navigator.push(
        MaterialPageRoute(
          builder: (_) => ProductDetailsScreen(
            productId: productId,
          ),
        ),
      );
    });
  }

  int? _extractProductId(Uri uri) {
    final isCustomLink = uri.scheme == 'ecommerceapp';
    final isWebLink =
        uri.scheme == 'https' || uri.scheme == 'http';

    if (!isCustomLink && !isWebLink) return null;

    final segments = uri.pathSegments;

    // Supports ecommerceapp://product/15
    if (isCustomLink && uri.host == 'product') {
      if (segments.length != 1) return null;
      return int.tryParse(segments.first);
    }

    // Supports ecommerceapp:///product/15
    // and web links such as https://example.com/product/15
    if (segments.length == 2 && segments.first == 'product') {
      return int.tryParse(segments[1]);
    }

    return null;
  }

  @override
  void dispose() {
    _linkSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: appNavigatorKey,
      title: 'E-Commerce App',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const SplashScreen(),
    );
  }
}
