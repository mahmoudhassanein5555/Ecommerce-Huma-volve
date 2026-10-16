import 'package:ecommerce_app_huma_volve/core/di/injection.dart';
import 'package:ecommerce_app_huma_volve/core/local_database/shared_prefs_helper.dart';
import 'package:ecommerce_app_huma_volve/core/observers/app_bloc_observer.dart';
import 'package:ecommerce_app_huma_volve/core/routing/app_routing.dart';
import 'package:ecommerce_app_huma_volve/core/routing/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'core/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = SimpleBlocObserver();
  await setupGetIt();
  final initialLocation = await getInitialLocation();
  runApp(MyApp(initialLocation: initialLocation));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.initialLocation});
  final String initialLocation;

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      minTextAdapt: true,
      ensureScreenSize: true,
      splitScreenMode: true,
      designSize: const Size(392, 872),
      child: MaterialApp.router(
        routerConfig: AppRouting.router(initialLocation: initialLocation),
        title: 'E-Commerce App',
        onGenerateTitle: (context) => 'E-Commerce App',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
      ),
    );
  }
}

Future<String> getInitialLocation() async {
  final token = await SharedPrefHelper.getString(SharedPrefHelper.userTokenKey);
  return (token != null && token.isNotEmpty) ? Routes.mainScreen : Routes.splash;
}
