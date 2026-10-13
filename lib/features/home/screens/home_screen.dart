import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/dummy_data.dart';
import '../../../core/theme.dart';
import '../cubit/home_cubit.dart';
import '../cubit/home_states.dart';
import '../models/product_model.dart';
import '../widgets/product_card.dart';
import '../widgets/category_chip.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    context.read<HomeCubit>().loadHomeData();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeStates>(
      builder: (context, state) {
        final homeCubit = context.read<HomeCubit>();
        final categories = homeCubit.categories;
        final selectedCategoryId =
            homeCubit.selectedCategoryId ??
            (categories.isEmpty ? null : categories.first.id);

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
                        SizedBox(
                          height: 44,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemCount: categories.length,
                            separatorBuilder: (context, index) =>
                                const SizedBox(width: 12),
                            itemBuilder: (context, index) {
                              final category = categories[index];
                              return CategoryChip(
                                label: category.name ?? 'Category',
                                isSelected: category.id == selectedCategoryId,
                                onTap: category.id == null
                                    ? () {}
                                    : () => context
                                          .read<HomeCubit>()
                                          .loadProducts(
                                            categoryId: category.id!,
                                          ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                if (state is CategoriesLoading)
                  const SliverToBoxAdapter(child: _LoadingIndicator())
                else if (state is CategoriesError)
                  SliverToBoxAdapter(
                    child: _StatusMessage(
                      message: state.errorMessage,
                      onRetry: () => context.read<HomeCubit>().loadHomeData(),
                    ),
                  )
                else if (state is ProductsLoading)
                  const SliverToBoxAdapter(child: _LoadingIndicator())
                else if (state is ProductsError)
                  SliverToBoxAdapter(
                    child: _StatusMessage(
                      message: state.errorMessage,
                      onRetry: homeCubit.selectedCategoryId == null
                          ? () => context.read<HomeCubit>().loadHomeData()
                          : () => context.read<HomeCubit>().loadProducts(
                              categoryId: homeCubit.selectedCategoryId!,
                            ),
                    ),
                  )
                else if (state is ProductsSuccess && state.products.isEmpty)
                  const SliverToBoxAdapter(
                    child: _StatusMessage(message: 'No products found.'),
                  )
                else if (state is ProductsSuccess)
                  SliverPadding(
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
                        return ProductCard(
                          product: _toDisplayProduct(state.products[index]),
                        );
                      }, childCount: state.products.length),
                    ),
                  ),
                const SliverToBoxAdapter(child: SizedBox(height: 24)),
              ],
            ),
          ),
        );
      },
    );
  }
}

Product _toDisplayProduct(ProductModel product) {
  final images = product.images;

  return Product(
    id: product.id?.toString() ?? '',
    name: product.title ?? 'Untitled product',
    description: product.description ?? '',
    price: (product.price ?? 0).toDouble(),
    imageUrl: images != null && images.isNotEmpty
        ? images.first
        : 'https://picsum.photos/seed/${product.id ?? 'product'}/300/300',
    colors: const [Colors.white, Colors.black, Colors.grey],
    sizes: const ['S', 'M', 'L', 'XL'],
  );
}

class _LoadingIndicator extends StatelessWidget {
  const _LoadingIndicator();

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 260,
      child: Center(child: CircularProgressIndicator()),
    );
  }
}

class _StatusMessage extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;

  const _StatusMessage({required this.message, this.onRetry});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 260,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(message, textAlign: TextAlign.center),
            if (onRetry != null) ...[
              const SizedBox(height: 12),
              TextButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: const Text('Retry'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
