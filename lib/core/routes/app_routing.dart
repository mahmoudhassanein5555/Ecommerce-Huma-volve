import 'package:ecommerce_app_huma_volve/features/details/screens/product_details_screen.dart';
import 'package:ecommerce_app_huma_volve/features/home/presentation/view/home_screen.dart';
import 'package:ecommerce_app_huma_volve/features/splash/screens/splash_screen.dart';
import 'package:go_router/go_router.dart';

final appRouting = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', builder: (context, state) {
      return const SplashScreen();
    },),
    GoRoute(path: '/products/:id', builder: (context, state) {
      final productId = state.pathParameters['id'];
      return ProductDetailsScreen(
        productId: int.parse(productId!),
        product: state.extra as dynamic,
      );
    },),
  ],
);
