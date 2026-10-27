import 'package:ecommerce_app_huma_volve/features/details/screens/product_details_screen.dart';
import 'package:ecommerce_app_huma_volve/features/home/data/service/models/prodduct_model.dart';
import 'package:ecommerce_app_huma_volve/features/splash/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final GoRouter appRouting =GoRouter(initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
  path: '/products/:id',
  builder: (context, state) {
    final int productId = int.parse(state.pathParameters['id']!);
    return ProductDetailsScreen(product: state.extra as ProductModel);
  },
),
  ],
);

