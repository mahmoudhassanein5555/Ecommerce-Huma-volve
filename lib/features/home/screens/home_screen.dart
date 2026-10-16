
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:ecommerce_app_huma_volve/core/theme.dart';
import 'package:ecommerce_app_huma_volve/core/dummy_data.dart';

import '../cubit/home_cubit.dart';
import '../cubit/home_states.dart';

import 'widgets/product_card.dart';
import 'widgets/category_chip.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int? _selectedCategoryId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(24),
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
                      style: Theme.of(context)
                          .textTheme
                          .displayLarge
                          ?.copyWith(fontSize: 36),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Best trendy collection!',
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(fontSize: 18),
                    ),
                    const SizedBox(height: 32),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Search clothes...',
                          hintStyle:
                              TextStyle(color: Colors.grey.shade400),
                          prefixIcon: const Icon(
                            Icons.search,
                            color: Colors.grey,
                          ),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Categories from API
                    SizedBox(
                      height: 44,
                      child: BlocBuilder<HomeCubit, HomeState>(
                        buildWhen: (previous, current) =>
                            current is CategoriesLoading ||
                            current is CategoriesSuccess ||
                            current is CategoriesError,
                        builder: (context, state) {
                          if (state is CategoriesLoading ||
                              state is HomeInitial) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }

                          if (state is CategoriesError) {
                            return Center(
                              child: Text(
                                'Could not load categories',
                                style: TextStyle(
                                  color: Colors.red.shade700,
                                ),
                              ),
                            );
                          }

                          if (state is CategoriesSuccess) {
                            final categories = state.categories;

                            return ListView.separated(
                              scrollDirection: Axis.horizontal,
                              itemCount: categories.length,
                              separatorBuilder: (_, _) => const SizedBox(width: 12),
                              itemBuilder: (context, index) {
                                final category = categories[index];

                                return CategoryChip(
                                  label: category.name,
                                  isSelected:
                                      _selectedCategoryId == category.id,
                                  onTap: () {
                                    setState(() {
                                      _selectedCategoryId = category.id;
                                    });
                                    context
                                        .read<HomeCubit>()
                                        .getProducts(category.id);
                                  },
                                );
                              },
                            );
                          }

                          return const SizedBox.shrink();
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Products from API
            BlocBuilder<HomeCubit, HomeState>(
              buildWhen: (previous, current) =>
                  current is ProductsLoading ||
                  current is ProductsSuccess ||
                  current is ProductsError,
              builder: (context, state) {
                if (state is ProductsLoading || state is HomeInitial) {
                  return const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.all(32),
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  );
                }

                if (state is ProductsError) {
                  return SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Text(
                        'Could not load products: ${state.message}',
                      ),
                    ),
                  );
                }

                if (state is ProductsSuccess) {
                  final products = state.products;

                  if (products.isEmpty) {
                    return const SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.all(24),
                        child: Center(
                          child: Text('No products found'),
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
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          return ProductCard(
                            product: products[index],
                          );
                        },
                        childCount: products.length,
                      ),
                    ),
                  );
                }

                return const SliverToBoxAdapter(
                  child: SizedBox.shrink(),
                );
              },
            ),

            const SliverToBoxAdapter(
              child: SizedBox(height: 24),
            ),
          ],
        ),
      ),
    );
  }
}
