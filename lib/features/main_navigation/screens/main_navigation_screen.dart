import 'package:ecommerce_app_huma_volve/features/home/data/data/home_remote_data_source.dart';
import 'package:ecommerce_app_huma_volve/features/home/domain/repository/home_repository.dart';
import 'package:ecommerce_app_huma_volve/features/home/domain/use_cases/get_categories_use_case.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/Network/api_manager.dart';
import '../../../core/theme.dart';
import '../../cart/screens/cart_screen.dart';
import '../../home/data/data/home_remote_data_source_imp.dart';
import '../../home/data/repository/home_repository_imp.dart';
import '../../home/domain/use_cases/get_product_use_case.dart';
import '../../home/presentation/view/home_screen.dart';
import '../../home/presentation/view_model/home_cubit.dart';
import '../../profile/screens/profile_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;
  late final ApiManager apiManager;
  late final HomeRemoteDataSource homeRemoteDataSource;
  late final HomeRepository homeRepository;
  late final HomeCubit homeCubit;
  late final GetProductsUseCase getProductsUseCase;
  late final GetCategoriesUseCase getCategoriesUseCase;

  @override
  void initState() {
    apiManager = ApiManager();
    homeRemoteDataSource = HomeRemoteDataSourceImp(apiManager);
    homeRepository = HomeRepositoryImp(homeRemoteDataSource);
    getCategoriesUseCase = GetCategoriesUseCase(homeRepository);
    getProductsUseCase = GetProductsUseCase(homeRepository);
    super.initState();

    homeCubit = HomeCubit(
      getCategoriesUseCase: getCategoriesUseCase,
      getProductsUseCase: getProductsUseCase,
    );
    super.initState();
    homeCubit.loadHomeData();
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> screens = [
      BlocProvider(
        create: (BuildContext context) => homeCubit,
        child: const HomeScreen(),
      ),
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
