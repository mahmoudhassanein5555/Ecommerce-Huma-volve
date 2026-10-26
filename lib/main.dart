import 'package:flutter/material.dart';

import 'core/routes/app_routing.dart';
import 'core/theme.dart';

void main() {
  // تم إزالة Firebase.initializeApp ليعمل التطبيق بدون فايربيز
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Huma-volve E-Commerce',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      routerConfig: appRouting,
    );
  }
}
