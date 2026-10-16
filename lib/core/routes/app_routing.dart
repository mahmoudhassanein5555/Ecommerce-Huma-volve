import 'package:go_router/go_router.dart';
import '../../features/splash/screens/splash_screen.dart';
import '../../features/details/screens/product_details_screen.dart';
import '../../features/home/domain/entity/home_product_entity.dart';

final appRouting = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) {
        return const SplashScreen();
      },
    ),
    GoRoute(
      path: '/products/:id',
      builder: (context, state) {
        final product = state.extra as HomeProductEntity;

        return ProductDetailsScreen(
          product: product,
        );
      },
    ),
  ],
);