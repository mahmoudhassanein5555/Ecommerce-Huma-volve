
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ecommerce_app_huma_volve/core/theme.dart';

import '../../home/cubit/home_cubit.dart';
import '../../home/data/repositories/home_repository_impl.dart';
import '../../home/domain/usecases/get_categories_usecase.dart';
import '../../home/domain/usecases/get_products_usecase.dart';
import '../../home/services/home_service.dart';
import '../../home/screens/home_screen.dart';
import '../../cart/screens/cart_screen.dart';
import '../../profile/screens/profile_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() =>
      _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  late final List<Widget> _screens = [
    BlocProvider(
      create: (_) {
        final homeService = HomeService();

        final homeRepository = HomeRepositoryImpl(
          homeService: homeService,
        );

        final getCategoriesUseCase = GetCategoriesUseCase(
          homeRepository,
        );

        final getProductsUseCase = GetProductsUseCase(
          homeRepository,
        );

        return HomeCubit(
          getCategoriesUseCase: getCategoriesUseCase,
          getProductsUseCase: getProductsUseCase,
        )..loadHomeData();
      },
      child: const HomeScreen(),
    ),
    const CartScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.1),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(24),
          ),
          child: BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            backgroundColor: Colors.white,
            selectedItemColor: AppTheme.primary,
            unselectedItemColor: Colors.grey.shade400,
            showSelectedLabels: false,
            showUnselectedLabels: false,
            type: BottomNavigationBarType.fixed,
            elevation: 0,
            items: const [
              BottomNavigationBarItem(
                icon: Padding(
                  padding: EdgeInsets.only(top: 8),
                  child: Icon(Icons.home_outlined),
                ),
                activeIcon: Padding(
                  padding: EdgeInsets.only(top: 8),
                  child: Icon(Icons.home_rounded),
                ),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Padding(
                  padding: EdgeInsets.only(top: 8),
                  child: Icon(Icons.shopping_cart_outlined),
                ),
                activeIcon: Padding(
                  padding: EdgeInsets.only(top: 8),
                  child: Icon(Icons.shopping_cart_rounded),
                ),
                label: 'Cart',
              ),
              BottomNavigationBarItem(
                icon: Padding(
                  padding: EdgeInsets.only(top: 8),
                  child: Icon(Icons.person_outline_rounded),
                ),
                activeIcon: Padding(
                  padding: EdgeInsets.only(top: 8),
                  child: Icon(Icons.person_rounded),
                ),
                label: 'Profile',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
