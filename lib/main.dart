import 'package:flutter/material.dart';

import 'core/di/service_locator.dart';
import 'core/theme.dart';
import 'features/splash/screens/splash_screen.dart';

Future<void> main() async {
   WidgetsFlutterBinding.ensureInitialized();
 await  setupServiceLocator();
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
