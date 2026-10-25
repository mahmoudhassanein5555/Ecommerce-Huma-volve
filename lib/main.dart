import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/theme.dart';
import 'features/auth/data/datasources/auth_remote_data_source.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/domain/usecases/login_usecase.dart';
import 'features/auth/presentation/cubit/auth_cubit.dart';
import 'features/home/data/datasources/home_remote_data_source.dart';
import 'features/home/data/repositories/home_repository_impl.dart';
import 'features/home/domain/usecases/get_products_usecase.dart';
import 'features/home/presentation/cubit/home_cubit.dart';
import 'features/splash/screens/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // توفير الـ AuthCubit وحقن تبعياته
        BlocProvider<AuthCubit>(
          create: (context) => AuthCubit(
            loginUseCase: LoginUseCase(
              AuthRepositoryImpl(remoteDataSource: AuthRemoteDataSourceImpl()),
            ),
          ),
        ),
        // توفير الـ HomeCubit وحقن تبعياته وجلب المنتجات فوراً
        BlocProvider<HomeCubit>(
          create: (context) => HomeCubit(
            getProductsUseCase: GetProductsUseCase(
              HomeRepositoryImpl(remoteDataSource: HomeRemoteDataSourceImpl()),
            ),
          )..getProducts(),
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
