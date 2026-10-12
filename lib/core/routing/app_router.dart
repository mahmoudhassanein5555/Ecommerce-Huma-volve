import 'package:dartz/dartz.dart';
import 'package:ecommerce_app_huma_volve/core/di/injection.dart';
import 'package:ecommerce_app_huma_volve/core/routing/routes.dart';
import 'package:ecommerce_app_huma_volve/features/auth/login/logic/cubit/login_cubit.dart';
import 'package:ecommerce_app_huma_volve/features/auth/login/ui/screens/login_screen.dart';
import 'package:ecommerce_app_huma_volve/features/auth/sign_up/logic/cubit/sign_up_cubit.dart';
import 'package:ecommerce_app_huma_volve/features/auth/sign_up/ui/screens/sign_up_screen.dart';
import 'package:ecommerce_app_huma_volve/features/main_navigation/screens/main_navigation_screen.dart';
import 'package:ecommerce_app_huma_volve/features/splash/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppRouter {
  Route? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.splash:
        return MaterialPageRoute(builder: (context) => const SplashScreen());
      case Routes.mainScreen:
        return MaterialPageRoute(
          builder: (context) => const MainNavigationScreen(),
        );
      case Routes.login:
        return MaterialPageRoute(
          builder:
              (context) => BlocProvider(
                create: (context) => getIt<LoginCubit>(),
                child: const LoginScreen(),
              ),
        );
      case Routes.signup:
        return MaterialPageRoute(
          builder:
              (context) => BlocProvider(
                create: (context) => getIt<SignUpCubit>(),
                child: const SignUpScreen(),
              ),
        );
      default:
        return null;
    }
  }
}
