import 'package:ecommerce_app_huma_volve/features/home/presentation/view/widgets/category_chip.dart';
import 'package:ecommerce_app_huma_volve/features/home/presentation/view/widgets/product_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/dummy_data.dart';
import '../../../../core/theme.dart';
import '../../domain/entity/home_product_entity.dart';
import '../view_model/home_cubit.dart';
import '../view_model/home_states.dart';

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
    scrollController = ScrollController()..addListener(_onScroll);
    context.read<HomeCubit>().loadHomeData();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!scrollController.hasClients) return;
    final position = scrollController.position;
    const triggerDistance = 200;
    if (position.pixels >= position.maxScrollExtent - triggerDistance) {
      context.read<HomeCubit>().loadMoreProducts();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: BlocListener<HomeCubit, HomeStates>(
        listenWhen: (previous, current) => current is ProductsLoadingError,
        listener: (context, state) {
          if (state is ProductsLoadingError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.errorMessage)),
            );
          }
        },
        child: SafeArea(
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
                      BlocBuilder<HomeCubit, HomeStates>(
                        buildWhen: (previous, current) =>
                        current is CategoriesLodaing ||
                            current is CategoriesSuccess ||
                            current is CategoriesError,
                        builder: (BuildContext context, state) {
                          if (state is CategoriesLodaing) {
                            return Center(child: CircularProgressIndicator());
                          } else if (state is CategoriesError) {
                            return Center(child: Text(state.errorMessage));
                          } else if (state is CategoriesSuccess) {
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
                                    label: categories[index].name,
                                    isSelected: _selectedCategoryIndex == index,
                                    onTap: () {
                                      setState(() {
                                        _selectedCategoryIndex = index;
                                      });
                                      context
                                          .read<HomeCubit>()
                                          .getProductsByCategoryId(
                                        categories[index].id,
                                      );
                                    },
                                  );
                                },
                              ),
                            );
                          } else {
                            return SizedBox.shrink();
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
              BlocBuilder<HomeCubit, HomeStates>(
                buildWhen: (previous, current) =>
                current is ProductsLoading ||
                    current is ProductsSuccess ||
                    current is ProductsError ||
                    current is ProductsLoadingMore ||
                    current is ProductsLoadingError,
                builder: (context, state) {
                  if (state is ProductsLoading) {
                    return const SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 48),
                        child: Center(child: CircularProgressIndicator()),
                      ),
                    );
                  } else if (state is ProductsError) {
                    return SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Center(child: Text(state.errorMessage)),
                      ),
                    );
                  }

                  List<HomeProductEntity>? products;
                  if (state is ProductsSuccess) {
                    products = state.products;
                  } else if (state is ProductsLoadingMore) {
                    products = state.products;
                  } else if (state is ProductsLoadingError) {
                    products = state.products;
                  }

                  if (products == null) {
                    return const SliverToBoxAdapter(child: SizedBox.shrink());
                  }
                  if (products.isEmpty) {
                    return const SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 48),
                        child: Center(child: Text('No products found')),
                      ),
                    );
                  }
                  final items = products;
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
                            (context, index) => ProductCard(product: items[index]),
                        childCount: items.length,
                      ),
                    ),
                  );
                },
              ),
              BlocBuilder<HomeCubit, HomeStates>(
                buildWhen: (previous, current) =>
                current is ProductsLoadingMore ||
                    current is ProductsSuccess ||
                    current is ProductsLoadingError ||
                    current is ProductsLoading,
                builder: (context, state) {
                  if (state is ProductsLoadingMore) {
                    return const SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 24),
                        child: Center(child: CircularProgressIndicator()),
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