import 'package:ecommerce_app_huma_volve/core/network%20services/network_services.dart';
import 'package:ecommerce_app_huma_volve/core/storage_services/storage_services.dart';
import 'package:ecommerce_app_huma_volve/core/theme.dart';
import 'package:ecommerce_app_huma_volve/features/auth/login/data/data_source/;ogin_datasource_imp.dart';
import 'package:ecommerce_app_huma_volve/features/auth/login/data/data_source/login_datasource.dart';
import 'package:ecommerce_app_huma_volve/features/auth/login/data/repository/login_repo_imp.dart';
import 'package:ecommerce_app_huma_volve/features/auth/login/domain/repository/login_repo.dart';
import 'package:ecommerce_app_huma_volve/features/auth/login/domain/usecase/login_usecase.dart';
import 'package:ecommerce_app_huma_volve/features/auth/login/presentation/cubit/login_cubit.dart';
import 'package:ecommerce_app_huma_volve/features/auth/login/presentation/screens/login_screen.dart';
import 'package:ecommerce_app_huma_volve/features/main_navigation/screens/main_navigation_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late final NetworkServices networkServices;

  late final LoginDatasource loginDataSource;
  late final LoginRepository loginRepo;
  late final LoginUseCase loginUseCase;
  late final LoginCubit loginCubit;

  @override
  void initState() {
    super.initState();

    networkServices = NetworkServices();
    loginDataSource = LoginDataSourceImp(networkServices);
    loginRepo = LoginRepoImp(loginDataSource);
    loginUseCase = LoginUseCase(loginRepo);
    loginCubit = LoginCubit(loginUseCase);

    _navigateToNext();
  }

  Future<void> _navigateToNext() async {
    await Future.delayed(const Duration(seconds: 2));

    final accessToken = await StorageServices.getAccessToken();

    if (!mounted) return;

    final Widget nextScreen;

    if (accessToken != null && accessToken.isNotEmpty) {
      nextScreen = const MainNavigationScreen();
    } else {
      nextScreen = BlocProvider<LoginCubit>.value(
        value: loginCubit,
        child: const LoginScreen(),
      );
    }

    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => nextScreen,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
    );
  }
}
