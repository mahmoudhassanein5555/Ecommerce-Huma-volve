import 'package:ecommerce_app_huma_volve/core/network/dio_helper.dart';
import 'package:ecommerce_app_huma_volve/core/storage/SharedPreferencesService.dart';
import 'package:flutter/material.dart';

import 'core/theme.dart';
import 'features/splash/screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Core Services
  await SharedPreferencesService.init();
  DioHelper.init();
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
