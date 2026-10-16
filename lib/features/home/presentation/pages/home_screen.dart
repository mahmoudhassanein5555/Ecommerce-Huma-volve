import 'package:ecommerce_app_huma_volve/core/dummy_data.dart';
import 'package:ecommerce_app_huma_volve/core/theme.dart';
import 'package:ecommerce_app_huma_volve/features/home/presentation/cubit/home_cubit.dart';
import 'package:ecommerce_app_huma_volve/features/home/presentation/cubit/home_state.dart';
import 'package:ecommerce_app_huma_volve/features/home/presentation/pages/widgets/category_chip.dart';
import 'package:ecommerce_app_huma_volve/features/home/presentation/pages/widgets/product_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedCategoryIndex = 0;
  late final ScrollController scrollController;

  @override
  void initState() {
    super.initState();
    context.read<HomeCubit>().loadCategories();
    scrollController = ScrollController();
    scrollController.addListener(_addListener);
  }

  void _addListener() {
    final pixel = scrollController.position.pixels;
    final maxScrollExtent = scrollController.position.maxScrollExtent;
    final trigger = 300;
    if (pixel > maxScrollExtent - trigger) {
      context.read<HomeCubit>().loadMoreProducts();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: CustomScrollView(
          controller: scrollController,
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
                      buildWhen: (previous, current) =>
                          current is CategoriesLoadingState ||
                          current is CategoriesErrorState ||
                          current is CategoriesSuccessState,
                      builder: (context, state) {
                        if (state is CategoriesLoadingState) {
                          return const Center(
                            child: CircularProgressIndicator(
                              color: AppTheme.accent,
                            ),
                          );
                        } else if (state is CategoriesErrorState) {
                          return Center(
                            child: Text(
                              'Error loading categories: ${state.errorMessage}',
                              style: const TextStyle(color: Colors.red),
                            ),
                          );
                        }
                        if (state is CategoriesSuccessState) {
                          final categories = state.categories;
                          return SizedBox(
                            height: 44,
                            child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              itemCount: categories.length,
                              separatorBuilder: (context, index) =>
                                  const SizedBox(width: 12),
                              itemBuilder: (context, index) {
                                return CategoryChip(
                                  label: categories[index].name ?? "",
                                  isSelected: _selectedCategoryIndex == index,
                                  onTap: () {
                                    setState(() {
                                      _selectedCategoryIndex = index;
                                    });
                                    context.read<HomeCubit>().loadProducts(
                                      categories[index].id,
                                    );
                                  },
                                );
                              },
                            ),
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  ],
                ),
              ),
            ),

            BlocBuilder<HomeCubit, HomeState>(
              buildWhen: (previous, current) =>
                  current is ProductsLoadingState ||
                  current is ProductsErrorState ||
                  current is ProductsSuccessState,
              builder: (context, state) {
                if (state is ProductsLoadingState) {
                  return const SliverToBoxAdapter(
                    child: Center(
                      child: CircularProgressIndicator(
                        color: AppTheme.primaryVariant,
                      ),
                    ),
                  );
                } else if (state is ProductsErrorState) {
                  return SliverToBoxAdapter(
                    child: Center(
                      child: Text(
                        'Error loading products: ${state.errorMessage}',
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                  );
                }
                if (state is ProductsSuccessState) {
                  final products = state.products;
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
                        (context, index) =>
                            ProductCard(product: products[index]),
                        childCount: products.length,
                      ),
                    ),
                  );
                }
                return const SliverToBoxAdapter(child: SizedBox.shrink());
              },
            ),
            BlocBuilder<HomeCubit, HomeState>(
              builder: (context, state) {
                if (state is ProductsLoadingMoreState) {
                  return const SliverToBoxAdapter(
                    child: Center(
                      child: CircularProgressIndicator(
                        color: AppTheme.primaryVariant,
                      ),
                    ),
                  );
                }
                return const SliverToBoxAdapter(child: SizedBox(height: 24));
              },
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 24)),
          ],
        ),
      ),
    );
  }
}
