import 'package:flutter/material.dart';

import 'core/product_deep_link.dart';
import 'core/services/product_api_service.dart';
import 'core/theme.dart';
import 'features/details/screens/product_details_screen.dart';
import 'features/splash/screens/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  final String? initialRoute;
  final ProductApiService? apiService;

  const MyApp({super.key, this.initialRoute, this.apiService});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'E-Commerce App',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialRoute: initialRoute,
      onGenerateInitialRoutes: (routeName) => [
        _generateRoute(RouteSettings(name: routeName)),
      ],
      onGenerateRoute: _generateRoute,
    );
  }

  Route<dynamic> _generateRoute(RouteSettings settings) {
    if (settings.name == Navigator.defaultRouteName) {
      return MaterialPageRoute<void>(
        settings: settings,
        builder: (_) => const SplashScreen(),
      );
    }

    final productId = productIdForDeepLink(settings.name);
    if (productId != null) {
      return MaterialPageRoute<void>(
        settings: settings,
        builder: (_) => ProductDetailsLoaderScreen(
          productId: productId,
          apiService: apiService ?? ProductApiService(),
        ),
      );
    }

    return MaterialPageRoute<void>(
      settings: settings,
      builder: (_) =>
          const Scaffold(body: Center(child: Text('Product not found'))),
    );
  }
}
