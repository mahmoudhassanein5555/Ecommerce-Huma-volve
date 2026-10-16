import 'package:ecommerce_app_huma_volve/core/di/injection.dart';
import 'package:ecommerce_app_huma_volve/core/routing/routes.dart';
import 'package:ecommerce_app_huma_volve/features/auth/login/logic/cubit/login_cubit.dart';
import 'package:ecommerce_app_huma_volve/features/auth/login/ui/screens/login_screen.dart';
import 'package:ecommerce_app_huma_volve/features/auth/sign_up/logic/cubit/sign_up_cubit.dart';
import 'package:ecommerce_app_huma_volve/features/auth/sign_up/ui/screens/sign_up_screen.dart';
import 'package:ecommerce_app_huma_volve/features/details/screens/product_details_screen.dart';
import 'package:ecommerce_app_huma_volve/features/home/domain/entities/category.dart';
import 'package:ecommerce_app_huma_volve/features/home/domain/entities/product.dart';
import 'package:ecommerce_app_huma_volve/features/home/logic/all_categories/cubit/all_categories_cubit.dart';
import 'package:ecommerce_app_huma_volve/features/home/logic/all_products/cubit/all_products_cubit.dart';
import 'package:ecommerce_app_huma_volve/features/main_navigation/screens/main_navigation_screen.dart';
import 'package:ecommerce_app_huma_volve/features/splash/screens/splash_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class AppRouting {
  static GoRouter router({String initialLocation = Routes.splash}) {
    return GoRouter(
      initialLocation: initialLocation,
      debugLogDiagnostics: true,
      routes: [
      GoRoute(
        path: Routes.splash,
        name: Routes.splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: Routes.mainScreen,
        name: Routes.mainScreen,
        builder: (context, state) => MultiBlocProvider(
          providers: [
            BlocProvider(create: (context) => getIt<AllProductsCubit>()),
            BlocProvider(create: (context) => getIt<AllCategoriesCubit>()),
          ],
          child: const MainNavigationScreen(),
        ),
      ),
      GoRoute(
        path: Routes.login,
        name: Routes.login,
        builder: (context, state) => BlocProvider(
          create: (context) => getIt<LoginCubit>(),
          child: const LoginScreen(),
        ),
      ),
      GoRoute(
        path: Routes.signup,
        name: Routes.signup,
        builder: (context, state) => BlocProvider(
          create: (context) => getIt<SignUpCubit>(),
          child: const SignUpScreen(),
        ),
      ),
      GoRoute(
        path: Routes.productDetailsWithId,
        name: Routes.productDetails,
        builder: (context, state) {
          final productId = int.parse(state.pathParameters['id']!);
          // For deep linking, we'll need to fetch the product by ID
          // For now, we'll handle it differently based on whether it's a deep link or internal navigation
          final product = state.extra as Product?;
          if (product != null) {
            return ProductDetailsScreen(product: product);
          }
          // TODO: Fetch product by ID for deep linking
          return ProductDetailsScreen(
            product: Product(
              id: productId,
              title: 'Loading...',
              slug: '',
              price: 0,
              description: '',
              category: Category(
                id: 0,
                name: '',
                slug: '',
                image: '',
                creationAt: DateTime.now(),
                updatedAt: DateTime.now(),
              ),
              images: [],
              creationAt: DateTime.now(),
              updatedAt: DateTime.now(),
            ),
          );
        },
      ),
    ],
    );
  }
}
