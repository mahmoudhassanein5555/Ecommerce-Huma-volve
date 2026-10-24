import 'package:ecommerce_app_huma_volve/features/home/persentation/view/widgets/category_chip.dart';
import 'package:ecommerce_app_huma_volve/features/home/persentation/view/widgets/product_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';import '../../../../core/dummy_data.dart';

import '../../../../core/theme.dart';
import '../view_model/home_cubit.dart';
import '../view_model/home_stats.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedCategoryIndex = 0;

  @override
  void initState() {
    super.initState();
    context.read<HomeCubit>().loadingData();
  }

  void _selectCategory(int index, int categoryId) {
    if (index == _selectedCategoryIndex) return;
    setState(() => _selectedCategoryIndex = index);
    context.read<HomeCubit>().changeSelectedCategory(categoryId: categoryId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: RefreshIndicator(
          color: AppTheme.primary,
          onRefresh: () async => null,
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
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
                      // Categories: rebuilds only on the categories states.
                      BlocBuilder<HomeCubit, HomeStats>(
                        buildWhen: (previous, current) =>
                            current is CategoriesLoading ||
                            current is CategoriesSuccess ||
                            current is CategoriesError,
                        builder: (context, state) {
                          if (state is CategoriesError) {
                            return Text(state.errorMessage);
                          }
                          if (state is CategoriesSuccess) {
                            final categories = state.categories;
                            if (categories.isEmpty) {
                              return const SizedBox.shrink();
                            }
                            return SizedBox(
                              height: 44,
                              child: ListView.separated(
                                scrollDirection: Axis.horizontal,
                                itemCount: categories.length,
                                separatorBuilder: (context, index) =>
                                    const SizedBox(width: 12),
                                itemBuilder: (context, index) {
                                  return CategoryChip(
                                    label: categories[index].name ?? 'All',
                                    isSelected: _selectedCategoryIndex == index,
                                    onTap: () => _selectCategory(
                                      index,
                                      categories[index].id ?? 0,
                                    ),
                                  );
                                },
                              ),
                            );
                          }
                          return const SizedBox(
                            height: 44,
                            child: Center(
                              child: CircularProgressIndicator(
                                color: AppTheme.primary,
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
              // Products: rebuilds only on the products states.
              BlocBuilder<HomeCubit, HomeStats>(
                buildWhen: (previous, current) =>
                    current is ProductsLoading ||
                    current is ProductsSuccess ||
                    current is ProductsError,
                builder: (context, state) {
                  if (state is ProductsLoading) {
                    return const SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.only(top: 48),
                        child: Center(
                          child: CircularProgressIndicator(
                            color: AppTheme.primary,
                          ),
                        ),
                      ),
                    );
                  }
                  if (state is ProductsError) {
                    return SliverToBoxAdapter(child: Text(state.errorMessage));
                  }
                  if (state is ProductsSuccess) {
                    final products = state.products;
                    if (products.isEmpty) {
                      return SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 48),
                          child: Text(
                            'No products in this category yet.',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.grey.shade600),
                          ),
                        ),
                      );
                    }
                    return SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      sliver: SliverGrid(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 0.7,
                              crossAxisSpacing: 16,
                              mainAxisSpacing: 16,
                            ),
                        delegate: SliverChildBuilderDelegate((context, index) {
                          return ProductCard(product: products[index]);
                        }, childCount: products.length),
                      ),
                    );
                  }
                  return const SliverToBoxAdapter(child: SizedBox.shrink());
                },
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 24)),
            ],
          ),
        ),
      ),
    );
  }
}
