import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/theme.dart';
import '../../auth/providers/auth_provider.dart';
import '../../auth/views/login_screen.dart';
import '../../main_navigation/screens/main_navigation_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToNext();
  }

  Future<void> _navigateToNext() async {
    final authProvider = context.read<AuthProvider>();
    // Keep the splash for at least 2s while checking the saved session.
    final results = await Future.wait([
      authProvider.restoreSession(),
      Future<void>.delayed(const Duration(seconds: 2)),
    ]);
    final isLoggedIn = results.first as bool;
    if (mounted) {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => isLoggedIn
              ? const MainNavigationScreen()
              : const LoginScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.shopping_bag,
              size: 120,
              color: AppTheme.primary,
            ),
            const SizedBox(height: 24),
            Text(
              'Huma-volve',
              style: Theme.of(context).textTheme.displayLarge?.copyWith(
                fontSize: 40,
                color: AppTheme.primary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Your Ultimate E-Commerce App',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontSize: 16,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 48),
            CircularProgressIndicator(
              color: AppTheme.primary,
            ),
          ],
        ),
      ),
    );
  }
}
