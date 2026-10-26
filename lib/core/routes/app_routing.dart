import 'package:ecommerce_app_huma_volve/features/details/screens/product_details_screen.dart';
import 'package:ecommerce_app_huma_volve/features/home/domain/entities/home_product_entity.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/login/screens/login_screen.dart';
import '../../features/main_navigation/screens/main_navigation_screen.dart';
import '../../features/splash/screens/splash_screen.dart';

final appRouting = GoRouter(
  initialLocation: "/",
  routes: [
    GoRoute(path: '/', builder: (context, state) => const SplashScreen()),
    GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
    GoRoute(
      path: '/main',
      builder: (context, state) => const MainNavigationScreen(),
    ),
    GoRoute(
      path: '/products/:id',
      builder: (context, state) {
        if (state.extra is HomeProductEntity) {
          return ProductDetailsScreen(
            product: state.extra as HomeProductEntity,
          );
        }

        final productId = state.pathParameters['id'];
        return ProductDetailsScreen(
          product: HomeProductEntity(
            id: int.tryParse(productId ?? '0') ?? 0,
            title: "Product Details",
            images: [],
          ),
        );
      },
    ),
  ],
);
