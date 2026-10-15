import 'package:ecommerce_app_huma_volve/core/di/dependancy_injection.dart';
import 'package:flutter/material.dart';

import 'core/theme.dart';
import 'features/splash/screens/splash_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  setupGetIt();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'E-Commerce App',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const SplashScreen(),
    );
  }
}
