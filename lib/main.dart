import 'package:ecommerce_app_huma_volve/core/di/injection.dart';
import 'package:ecommerce_app_huma_volve/core/observers/app_bloc_observer.dart';
import 'package:ecommerce_app_huma_volve/core/routing/app_router.dart';
import 'package:ecommerce_app_huma_volve/core/routing/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'core/theme.dart';
import 'features/splash/screens/splash_screen.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = SimpleBlocObserver();
  await setupGetIt();
  runApp(MyApp(appRouter: AppRouter()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.appRouter});
  final AppRouter appRouter;
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      minTextAdapt: true,
      ensureScreenSize: true,
      splitScreenMode: true,
      designSize: const Size(392, 872),
      child: MaterialApp(
        navigatorKey: navigatorKey,
        initialRoute: Routes.splash,
        onGenerateRoute: appRouter.generateRoute,
        title: 'E-Commerce App',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
      ),
    );
  }
}
