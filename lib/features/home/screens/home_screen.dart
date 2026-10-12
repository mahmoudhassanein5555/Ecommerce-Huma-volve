import 'package:ecommerce_app_huma_volve/features/home/cubit/home_cubit.dart';
import 'package:ecommerce_app_huma_volve/features/home/cubit/home_state.dart';
import 'package:ecommerce_app_huma_volve/features/home/services/model/category_model.dart';
import 'package:ecommerce_app_huma_volve/features/home/services/model/product_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/dummy_data.dart';
import '../../../core/theme.dart';
import 'widgets/product_card.dart';
import 'widgets/category_chip.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedCategoryIndex = 0;

  @override
  initState() {
    super.initState();
    context.read<HomeCubit>().LoadHome();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withValues(alpha: 0.1),
                                blurRadius: 10,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.menu,
                            color: AppTheme.primary,
                          ),
                        ),
                        CircleAvatar(
                          radius: 24,
                          backgroundImage: NetworkImage(
                            dummyUser.profilePictureUrl,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    Text(
                      'Explore',
                      style: Theme.of(context).textTheme.displayLarge
                          ?.copyWith(fontSize: 36),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Best trendy collection!',
                      style: Theme.of(context).textTheme.bodyMedium
                          ?.copyWith(fontSize: 18),
                    ),
                    const SizedBox(height: 32),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withValues(alpha: 0.05),
                            blurRadius: 15,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Search clothes...',
                          hintStyle: TextStyle(color: Colors.grey.shade400),
                          prefixIcon: const Icon(
                            Icons.search,
                            color: Colors.grey,
                          ),
                          suffixIcon: Container(
                            margin: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: AppTheme.primary,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.tune,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    BlocBuilder<HomeCubit, HomeState>(
                      buildWhen: (previous, current) {
                        print('Current state: $current');
                        if (current is categoriesSuccessState ||
                            current is categoriesErrorState) {
                          return true;
                        }
                        return false;
                      },
                      builder: (context, state) {
                        if (state is categoriesSuccessState) {
                          final category = state.categories;

                          return SizedBox(
                            height: 48,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: state.categories.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  child: CategoryChip(
                                    label: category[index].name,
                                    isSelected: _selectedCategoryIndex == index,
                                    onTap: () {
                                      setState(() {
                                        _selectedCategoryIndex = index;
                                      });
                                      context.read<HomeCubit>().LoadProducts(
                                        category[index].id,
                                      );
                                    },
                                  ),
                                );
                              },
                            ),
                          );
                        } else if (state is HomeLoadingState) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else if (state is categoriesErrorState) {
                          return Center(
                            child: Text(
                              'Error loading categories: ${state.errorMessage}',
                              style: const TextStyle(color: Colors.red),
                            ),
                          );
                        } else {
                          return const SizedBox.shrink();
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
            BlocBuilder<HomeCubit, HomeState>(
              buildWhen: (previous, current) {
                if (current is productsSuccessState ||
                    current is productsLoadedState ||
                    current is productsErrorState) {
                  return true;
                }
                return false;
              },
              builder: (BuildContext context, state) {
                if (state is productsSuccessState) {
                  final List<ProductModel> products = state.products;
                  return SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    sliver: SliverGrid(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 16,
                            crossAxisSpacing: 16,
                            childAspectRatio: 0.7,
                          ),

                      delegate: SliverChildBuilderDelegate((context, index) {
                        return ProductCard(product: products[index]);
                      }, childCount: products.length),
                    ),
                  );
                } else if (state is productsLoadedState) {
                  return const SliverToBoxAdapter(
                    child: Center(child: CircularProgressIndicator()),
                  );
                } else if (state is productsErrorState) {
                  return SliverToBoxAdapter(
                    child: Center(
                      child: Text(
                        'Error loading products: ${state.errorMessage}',
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                  );
                } else {
                  return const SliverToBoxAdapter(child: SizedBox.shrink());
                }
              },
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 24)),
          ],
        ),
      ),
    );
  }
}
