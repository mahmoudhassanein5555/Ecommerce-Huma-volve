import 'package:flutter/material.dart';

import '../../../core/dummy_data.dart';
import '../../../core/theme.dart';
import '../data/datasources/home_remote_data_source.dart';
import '../data/repositories/home_repository_impl.dart';
import '../domain/entities/category.dart';
import '../domain/entities/product.dart';
import '../domain/failures/home_failure.dart';
import '../domain/repositories/home_repository.dart';
import '../domain/usecases/get_home_data.dart';
import '../widgets/product_card.dart';
import '../widgets/category_chip.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, this.repository});

  final HomeRepository? repository;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const _pageSize = 20;

  late final GetHomeData _getHomeData = GetHomeData(
    widget.repository ?? HomeRepositoryImpl(DioHomeRemoteDataSource()),
  );
  late final ScrollController _scrollController = ScrollController()
    ..addListener(_onScroll);
  List<Product> _products = const [];
  List<Category> _categories = const [];
  String _selectedCategory = 'All';
  String? _errorMessage;
  String? _loadMoreError;
  bool _isLoading = true;
  bool _isLoadingMore = false;
  bool _hasMoreProducts = true;
  int _nextOffset = 0;
  int _requestGeneration = 0;

  @override
  void initState() {
    super.initState();
    _loadHomeData();
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  String? get _selectedCategoryId {
    if (_selectedCategory == 'All') return null;
    for (final category in _categories) {
      if (category.name == _selectedCategory) return category.id;
    }
    return null;
  }

  Future<void> _loadHomeData() =>
      _loadFirstPage(includeCategories: true, categoryId: _selectedCategoryId);

  Future<void> _refreshHome() => _loadHomeData();

  Future<void> _loadFirstPage({
    bool includeCategories = false,
    String? categoryId,
  }) async {
    final requestGeneration = ++_requestGeneration;
    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _loadMoreError = null;
      _isLoadingMore = false;
      _hasMoreProducts = true;
      _nextOffset = 0;
      _products = const [];
    });

    try {
      List<Product> products;
      List<Category>? categories;
      if (includeCategories) {
        final data = await _getHomeData(
          limit: _pageSize,
          offset: 0,
          categoryId: categoryId,
        );
        products = data.products;
        categories = data.categories;
      } else {
        products = await _getHomeData.fetchProducts(
          limit: _pageSize,
          offset: 0,
          categoryId: categoryId,
        );
      }
      if (!mounted || requestGeneration != _requestGeneration) return;
      setState(() {
        _products = products;
        if (categories != null) _categories = categories;
        _nextOffset = products.length;
        _hasMoreProducts = products.length == _pageSize;
      });
    } on HomeFailure catch (error) {
      if (mounted && requestGeneration == _requestGeneration) {
        setState(() => _errorMessage = error.message);
      }
    } finally {
      if (mounted && requestGeneration == _requestGeneration) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _loadMoreProducts() async {
    if (_isLoading ||
        _isLoadingMore ||
        !_hasMoreProducts ||
        _loadMoreError != null) {
      return;
    }

    final requestGeneration = _requestGeneration;
    final offset = _nextOffset;
    setState(() {
      _isLoadingMore = true;
      _loadMoreError = null;
    });

    try {
      final products = await _getHomeData.fetchProducts(
        limit: _pageSize,
        offset: offset,
        categoryId: _selectedCategoryId,
      );
      if (!mounted || requestGeneration != _requestGeneration) return;
      setState(() {
        final productIds = _products.map((product) => product.id).toSet();
        _products = [
          ..._products,
          ...products.where((product) => productIds.add(product.id)),
        ];
        _nextOffset = offset + products.length;
        _hasMoreProducts = products.length == _pageSize;
      });
    } on HomeFailure catch (error) {
      if (mounted && requestGeneration == _requestGeneration) {
        setState(() => _loadMoreError = error.message);
      }
    } finally {
      if (mounted && requestGeneration == _requestGeneration) {
        setState(() => _isLoadingMore = false);
      }
    }
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    if (_scrollController.position.extentAfter < 400) {
      _loadMoreProducts();
    }
  }

  void _selectCategory(String category, String? categoryId) {
    if (_selectedCategory == category) return;
    setState(() => _selectedCategory = category);
    _loadFirstPage(categoryId: categoryId);
  }

  List<Product> get _visibleProducts {
    if (_selectedCategory == 'All') return _products;
    return _products
        .where(
          (product) =>
              product.category.toLowerCase() == _selectedCategory.toLowerCase(),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _refreshHome,
          child: CustomScrollView(
            controller: _scrollController,
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
                            onBackgroundImageError: (exception, stackTrace) {},
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
                          itemCount: _categories.length + 1,
                          separatorBuilder: (context, index) =>
                              const SizedBox(width: 12),
                          itemBuilder: (context, index) {
                            final selectedCategory = index == 0
                                ? null
                                : _categories[index - 1];
                            final category = selectedCategory?.name ?? 'All';
                            return CategoryChip(
                              label: category,
                              isSelected: _selectedCategory == category,
                              onTap: () => _selectCategory(
                                category,
                                selectedCategory?.id,
                              ),
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
                sliver: _buildProductsSliver(),
              ),
              _buildPaginationSliver(),
              const SliverToBoxAdapter(child: SizedBox(height: 24)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProductsSliver() {
    if (_isLoading) {
      return const SliverFillRemaining(
        hasScrollBody: false,
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (_errorMessage case final message?) {
      return SliverFillRemaining(
        hasScrollBody: false,
        child: _MessageState(
          icon: Icons.wifi_off_outlined,
          message: message,
          buttonLabel: 'Retry',
          onPressed: _loadHomeData,
        ),
      );
    }

    final products = _visibleProducts;
    if (products.isEmpty) {
      final isFiltered = _selectedCategory != 'All';
      return SliverFillRemaining(
        hasScrollBody: false,
        child: _MessageState(
          icon: Icons.inventory_2_outlined,
          message: isFiltered
              ? 'No products found in $_selectedCategory.'
              : 'No products are available right now.',
          buttonLabel: isFiltered ? 'Show all products' : 'Retry',
          onPressed: isFiltered
              ? () => _selectCategory('All', null)
              : _loadHomeData,
        ),
      );
    }

    return SliverGrid(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.7,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      delegate: SliverChildBuilderDelegate((context, index) {
        return ProductCard(product: products[index]);
      }, childCount: products.length),
    );
  }

  Widget _buildPaginationSliver() {
    if (_isLoading || _products.isEmpty || !_hasMoreProducts) {
      return const SliverToBoxAdapter(child: SizedBox.shrink());
    }
    if (_loadMoreError case final message?) {
      return SliverToBoxAdapter(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Text(message, textAlign: TextAlign.center),
                TextButton(
                  onPressed: () {
                    setState(() => _loadMoreError = null);
                    _loadMoreProducts();
                  },
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
        ),
      );
    }
    if (_isLoadingMore) {
      return const SliverToBoxAdapter(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Center(child: CircularProgressIndicator()),
        ),
      );
    }
    return const SliverToBoxAdapter(child: SizedBox.shrink());
  }
}

class _MessageState extends StatelessWidget {
  const _MessageState({
    required this.icon,
    required this.message,
    required this.buttonLabel,
    required this.onPressed,
  });

  final IconData icon;
  final String message;
  final String buttonLabel;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 48, color: AppTheme.textSecondary),
            const SizedBox(height: 12),
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            ElevatedButton(onPressed: onPressed, child: Text(buttonLabel)),
          ],
        ),
      ),
    );
  }
}
