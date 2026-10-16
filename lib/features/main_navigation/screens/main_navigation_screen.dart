import 'package:ecommerce_app_huma_volve/core/network%20services/network_services.dart';
import 'package:ecommerce_app_huma_volve/core/theme.dart';
import 'package:ecommerce_app_huma_volve/features/cart/screens/cart_screen.dart';
import 'package:ecommerce_app_huma_volve/features/home/data/datasource/home_data_source.dart';
import 'package:ecommerce_app_huma_volve/features/home/data/datasource/home_data_source_imp.dart';
import 'package:ecommerce_app_huma_volve/features/home/data/repository/home_repo_imp.dart';
import 'package:ecommerce_app_huma_volve/features/home/domain/repository/home_repo.dart';
import 'package:ecommerce_app_huma_volve/features/home/domain/usecase/categories_use_case.dart';
import 'package:ecommerce_app_huma_volve/features/home/domain/usecase/products_use_case.dart';
import 'package:ecommerce_app_huma_volve/features/home/presentation/cubit/home_cubit.dart';
import 'package:ecommerce_app_huma_volve/features/home/presentation/pages/home_screen.dart';
import 'package:ecommerce_app_huma_volve/features/profile/screens/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;
  late final NetworkServices networkServices;
  late final HomeDataSource homeDataSource;
  late final HomeRepo homeRepo;
  late final CategoriesUseCase categoriesUseCase;
  late final ProductsUseCase productsUseCase;
  late final HomeCubit homeCubit;

  @override
  void initState() {
    super.initState();

    networkServices = NetworkServices();
    homeDataSource = HomeDataSourceImp(networkServices);
    homeRepo = HomeRepoImp(homeDataSource);
    categoriesUseCase = CategoriesUseCase(homeRepo);
    productsUseCase = ProductsUseCase(homeRepo);
    homeCubit = HomeCubit(categoriesUseCase, productsUseCase);
  }

  @override
  void dispose() {
    homeCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> screens = [
      BlocProvider.value(value: homeCubit, child: const HomeScreen()),
      const CartScreen(),
      const ProfileScreen(),
    ];
    return Scaffold(
      body: screens[_currentIndex],
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
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
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
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: Icon(Icons.home_filled, size: 28),
                ),
                activeIcon: Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: Icon(Icons.home_filled, size: 32),
                ),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: Icon(Icons.shopping_cart_outlined, size: 28),
                ),
                activeIcon: Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: Icon(Icons.shopping_cart, size: 32),
                ),
                label: 'Cart',
              ),
              BottomNavigationBarItem(
                icon: Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: Icon(Icons.person_outline, size: 28),
                ),
                activeIcon: Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: Icon(Icons.person, size: 32),
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