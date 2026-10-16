
import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/home_cubit.dart';
import '../cubit/home_states.dart';
import '../domain/entities/category_entity.dart';
import '../domain/entities/product_entity.dart';
import 'product_details_api_screen.dart';
import 'widgets/product_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();

  late final AppLinks _appLinks;
  StreamSubscription<Uri>? _linkSubscription;

  bool _isHandlingDeepLink = false;

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(_onScroll);

    _appLinks = AppLinks();

    _handleInitialLink();

    _linkSubscription = _appLinks.uriLinkStream.listen(
      _handleDeepLink,
    );
  }

  Future<void> _handleInitialLink() async {
    try {
      final uri = await _appLinks.getInitialLink();

      if (uri != null && mounted) {
        _handleDeepLink(uri);
      }
    } catch (e) {
      debugPrint('Error reading initial link: $e');
    }
  }

  void _handleDeepLink(Uri uri) {
    if (!mounted || _isHandlingDeepLink) return;

    if (uri.scheme != 'huma-volve' ||
        uri.host != 'product') {
      return;
    }

    if (uri.pathSegments.isEmpty) return;

    final productId = int.tryParse(uri.pathSegments.first);

    if (productId == null || productId <= 0) return;

    _isHandlingDeepLink = true;

    final homeCubit = context.read<HomeCubit>();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: homeCubit,
          child: ProductDetailsApiScreen(
            productId: productId,
          ),
        ),
      ),
    ).then((_) {
      _isHandlingDeepLink = false;
    });
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;

    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      context.read<HomeCubit>().loadMoreProducts();
    }
  }

  @override
  void dispose() {
    _linkSubscription?.cancel();

    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Discover Products',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
      ),
      body: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          if (state is HomeInitial ||
              state is CategoriesLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state is CategoriesError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 48,
                      color: Colors.red,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Failed to load categories:\n${state.message}',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: () {
                        context.read<HomeCubit>().loadHomeData();
                      },
                      child: const Text('Try Again'),
                    ),
                  ],
                ),
              ),
            );
          }

          final categories =
              context.read<HomeCubit>().categories;

          if (state is ProductsLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state is ProductsError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 48,
                      color: Colors.red,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Failed to load products:\n${state.message}',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: () {
                        context.read<HomeCubit>().loadHomeData();
                      },
                      child: const Text('Try Again'),
                    ),
                  ],
                ),
              ),
            );
          }

          List<ProductEntity> products = [];
          bool isLoadingMore = false;
          bool hasMore = true;

          if (state is ProductsSuccess) {
            products = state.products;
            isLoadingMore = state.isLoadingMore;
            hasMore = state.hasMore;
          }

          return RefreshIndicator(
            onRefresh: () async {
              await context.read<HomeCubit>().loadHomeData();
            },
            child: CustomScrollView(
              controller: _scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(
                      16,
                      12,
                      16,
                      8,
                    ),
                    child: Text(
                      'Categories',
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge
                          ?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                ),

                SliverToBoxAdapter(
                  child: SizedBox(
                    height: 55,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                      ),
                      itemCount: categories.length,
                      itemBuilder: (context, index) {
                        final CategoryEntity category =
                            categories[index];

                        return Padding(
                          padding: const EdgeInsets.only(
                            right: 8,
                          ),
                          child: ActionChip(
                            label: Text(category.name),
                            onPressed: () {
                              context
                                  .read<HomeCubit>()
                                  .getProducts(category.id);
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ),

                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(
                      16,
                      16,
                      16,
                      12,
                    ),
                    child: Text(
                      'Products',
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge
                          ?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                ),

                if (products.isEmpty)
                  const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.all(32),
                      child: Center(
                        child: Text('No products found'),
                      ),
                    ),
                  )
                else
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                    ),
                    sliver: SliverGrid(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final product = products[index];

                          return ProductCard(
                            product: product,
                            onTap: () {
                              final homeCubit =
                                  context.read<HomeCubit>();

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      BlocProvider.value(
                                    value: homeCubit,
                                    child: ProductDetailsApiScreen(
                                      productId: product.id,
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        },
                        childCount: products.length,
                      ),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 0.68,
                      ),
                    ),
                  ),

                if (isLoadingMore)
                  const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  ),

                if (!hasMore && products.isNotEmpty)
                  const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Center(
                        child: Text('No more products'),
                      ),
                    ),
                  ),

                const SliverToBoxAdapter(
                  child: SizedBox(height: 20),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
