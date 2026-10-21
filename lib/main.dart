import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/network/api_client.dart';
import 'core/storage/token_storage.dart';
import 'core/theme.dart';
import 'features/auth/providers/auth_provider.dart';
import 'features/auth/services/auth_service.dart';
import 'features/splash/screens/splash_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final tokenStorage = await TokenStorage.init();

  runApp(AppProviders(tokenStorage: tokenStorage, child: const MyApp()));
}

/// Dependency graph in one place: core services → feature services →
/// ViewModels. Each class receives its dependencies via the constructor.
class AppProviders extends StatelessWidget {
  const AppProviders({
    super.key,
    required this.tokenStorage,
    required this.child,
  });

  final TokenStorage tokenStorage;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // ---- Core ----
        Provider<TokenStorage>.value(value: tokenStorage),
        Provider<ApiClient>(create: (_) => ApiClient(tokenStorage)),
        // ---- Services ----
        Provider<AuthService>(
          create: (context) => AuthService(context.read<ApiClient>()),
        ),
        // ---- ViewModels ----
        ChangeNotifierProvider<AuthProvider>(
          create: (context) =>
              AuthProvider(context.read<AuthService>(), tokenStorage),
        ),
      ],
      child: child,
    );
  }
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
