import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/theme.dart';
import '../../../core/dummy_data.dart' show dummyUser;
import '../../../core/widgets/primary_button.dart';
import '../home_dependencies.dart';
import '../presentation/cubit/home_cubit.dart';
import '../presentation/cubit/home_state.dart';
import '../widgets/product_card.dart';
import '../widgets/category_chip.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HomeDependencies.buildHomeCubit()..loadHome(),
      child: const _HomeView(),
    );
  }
}

class _HomeView extends StatefulWidget {
  const _HomeView();

  @override
  State<_HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<_HomeView> {
  static const double _loadMoreThreshold = 300;

  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final position = _scrollController.position;
    if (position.pixels >= position.maxScrollExtent - _loadMoreThreshold) {
      context.read<HomeCubit>().loadNextPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: RefreshIndicator(
          color: AppTheme.primary,
          onRefresh: () => context.read<HomeCubit>().refresh(),
          child: CustomScrollView(
            controller: _scrollController,
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
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
                      _CategoryChips(),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
              BlocBuilder<HomeCubit, HomeState>(
                builder: (context, state) {
                  return switch (state) {
                    HomeInitial() || HomeLoading() => const SliverFillRemaining(
                      hasScrollBody: false,
                      child: Center(
                        child: CircularProgressIndicator(
                          color: AppTheme.primary,
                        ),
                      ),
                    ),
                    HomeEmpty() => const SliverFillRemaining(
                      hasScrollBody: false,
                      child: _EmptyView(),
                    ),
                    HomeError(:final message) => SliverFillRemaining(
                      hasScrollBody: false,
                      child: _ErrorView(message: message),
                    ),
                    HomeLoaded(
                      :final products,
                      :final hasMore,
                      :final isLoadingMore,
                      :final paginationError,
                    ) =>
                      SliverMainAxisGroup(
                        slivers: [
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
                              delegate: SliverChildBuilderDelegate((
                                context,
                                index,
                              ) {
                                return ProductCard(product: products[index]);
                              }, childCount: products.length),
                            ),
                          ),
                          SliverToBoxAdapter(
                            child: _PaginationFooter(
                              hasMore: hasMore,
                              isLoadingMore: isLoadingMore,
                              errorMessage: paginationError,
                              onRetry: () =>
                                  context.read<HomeCubit>().loadNextPage(),
                            ),
                          ),
                        ],
                      ),
                  };
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

class _CategoryChips extends StatelessWidget {
  const _CategoryChips();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      buildWhen: (previous, current) =>
          current is HomeLoaded || current is HomeEmpty || current is HomeError,
      builder: (context, state) {
        final categories = switch (state) {
          HomeLoaded(:final categories) => categories,
          HomeEmpty(:final categories) => categories,
          HomeError(:final categories) => categories,
          _ => const <String>[],
        };
        final selectedCategory = switch (state) {
          HomeLoaded(:final selectedCategory) => selectedCategory,
          HomeEmpty(:final selectedCategory) => selectedCategory,
          HomeError(:final selectedCategory) => selectedCategory,
          _ => kAllCategoryLabel,
        };

        if (categories.isEmpty) {
          return const SizedBox(height: 44);
        }

        return SizedBox(
          height: 44,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: categories.length,
            separatorBuilder: (context, index) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final category = categories[index];
              return CategoryChip(
                label: category,
                isSelected: category == selectedCategory,
                onTap: () => context.read<HomeCubit>().selectCategory(category),
              );
            },
          ),
        );
      },
    );
  }
}

class _EmptyView extends StatelessWidget {
  const _EmptyView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.inventory_2_outlined,
              size: 56,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 16),
            Text(
              'No products found in this category.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium
                  ?.copyWith(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 56, color: AppTheme.error),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium
                  ?.copyWith(fontSize: 16),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: 160,
              child: PrimaryButton(
                text: 'Retry',
                onPressed: () => context.read<HomeCubit>().loadHome(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Shown below the product grid: a spinner while the next page loads, an
/// inline retry if it failed (the grid above stays untouched either way),
/// or nothing once every page has been loaded.
class _PaginationFooter extends StatelessWidget {
  const _PaginationFooter({
    required this.hasMore,
    required this.isLoadingMore,
    required this.errorMessage,
    required this.onRetry,
  });

  final bool hasMore;
  final bool isLoadingMore;
  final String? errorMessage;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    if (errorMessage != null) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: Column(
          children: [
            Text(
              errorMessage!,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium
                  ?.copyWith(fontSize: 14),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: 140,
              height: 44,
              child: PrimaryButton(text: 'Retry', onPressed: onRetry),
            ),
          ],
        ),
      );
    }

    if (isLoadingMore) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 24),
        child: Center(
          child: CircularProgressIndicator(color: AppTheme.primary),
        ),
      );
    }

    if (!hasMore) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: Center(
          child: Text(
            "You've reached the end.",
            style: Theme.of(context).textTheme.bodyMedium
                ?.copyWith(fontSize: 13),
          ),
        ),
      );
    }

    return const SizedBox(height: 24);
  }
}
