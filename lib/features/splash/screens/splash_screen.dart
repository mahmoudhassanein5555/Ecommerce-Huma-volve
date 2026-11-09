import 'package:ecommerce_app_huma_volve/features/auth/presentation/view/login/screens/login_screen.dart';
import 'package:ecommerce_app_huma_volve/features/main_navigation/screens/main_navigation_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/theme.dart';
import '../../auth/presentation/viewmodel/auth_cubit.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is Unauthenticated) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => LoginScreen()),
          );
        } else if (state is Authenticated) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => MainNavigationScreen()),
          );
        }
      },
      child: Scaffold(
        backgroundColor: AppTheme.background,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.shopping_bag, size: 120, color: AppTheme.primary),
              const SizedBox(height: 24),
              Text(
                'Huma-volve',
                style: Theme.of(context).textTheme.displayLarge
                    ?.copyWith(fontSize: 40, color: AppTheme.primary),
              ),
              const SizedBox(height: 8),
              Text(
                'Your Ultimate E-Commerce App',
                style: Theme.of(context).textTheme.bodyMedium
                    ?.copyWith(fontSize: 16, color: Colors.grey.shade600),
              ),
              const SizedBox(height: 48),
              CircularProgressIndicator(color: AppTheme.primary),
            ],
          ),
        ),
      ),
    );
  }
}
