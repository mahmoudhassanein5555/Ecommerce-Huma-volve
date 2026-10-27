import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/theme.dart';
import '../cubit/home_cubit.dart';
import '../cubit/home_state.dart';
import '../widgets/product_card.dart';
import '../widgets/category_chip.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_isBottom) {
      context.read<HomeCubit>().loadMoreProducts();
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9); // يبدأ التحميل قبل النهاية بقليل
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: BlocBuilder<HomeCubit, HomeState>(
          builder: (context, state) {
            if (state is HomeLoading) {
              return const Center(
                child: CircularProgressIndicator(color: AppTheme.primary),
              );
            } else if (state is HomeFailure) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      state.message,
                      style: const TextStyle(color: Colors.red),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        context.read<HomeCubit>().getProducts();
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            } else if (state is HomeSuccess) {
              final products = state.products;
              final hasMore = state.hasMore;

              return CustomScrollView(
                controller: _scrollController,
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
                              const CircleAvatar(
                                radius: 24,
                                backgroundImage: NetworkImage(
                                  'https://images.unsplash.com/photo-1534528741775-53994a69daeb',
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 32),
                          Text(
                            'Explore',
                            style: Theme.of(
                              context,
                            ).textTheme.displayLarge?.copyWith(fontSize: 36),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Best trendy collection!',
                            style: Theme.of(
                              context,
                            ).textTheme.bodyMedium?.copyWith(fontSize: 18),
                          ),
                          const SizedBox(height: 32),
                          // Search bar ...
                          const SizedBox(height: 32),
                          SizedBox(
                            height: 44,
                            child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              itemCount: 3,
                              separatorBuilder: (context, index) =>
                                  const SizedBox(width: 12),
                              itemBuilder: (context, index) {
                                return CategoryChip(
                                  label: 'Category ${index + 1}',
                                  isSelected: index == 0,
                                  onTap: () {},
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
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
                        final product = products[index];
                        return InkWell(
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              '/product-details',
                              arguments: product.id.toString(),
                            );
                          },
                          child: ProductCard(product: product),
                        );
                      }, childCount: products.length),
                    ),
                  ),
                  // مؤشر التحميل في الأسفل عند سحب المزيد
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Center(
                        child: hasMore
                            ? const CircularProgressIndicator(
                                color: AppTheme.primary,
                              )
                            : const Text(
                                'No more products',
                                style: TextStyle(color: Colors.grey),
                              ),
                      ),
                    ),
                  ),
                ],
              );
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }
}
