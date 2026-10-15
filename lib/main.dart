import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'features/auth/data/datasources/auth_remote_data_source.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/domain/usecases/login.dart';
import 'features/auth/domain/usecases/sign_up.dart';
import 'features/auth/providers/auth_provider.dart';
import 'core/theme.dart';
import 'features/home/data/datasources/home_remote_data_source.dart';
import 'features/home/data/repositories/home_repository_impl.dart';
import 'features/home/domain/usecases/get_home_categories.dart';
import 'features/home/domain/usecases/get_home_products.dart';
import 'features/home/providers/home_provider.dart';
import 'features/splash/screens/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final authRepository = AuthRepositoryImpl(AuthRemoteDataSource());
    final homeRepository = HomeRepositoryImpl(HomeRemoteDataSource());
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthProvider(
            loginUseCase: Login(authRepository),
            signUpUseCase: SignUp(authRepository),
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => HomeProvider(
            getHomeProducts: GetHomeProducts(homeRepository),
            getHomeCategories: GetHomeCategories(homeRepository),
          ),
        ),
      ],
      child: MaterialApp(
        title: 'E-Commerce App',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: const SplashScreen(),
      ),
    );
  }
}
