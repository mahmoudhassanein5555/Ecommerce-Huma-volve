import 'package:flutter/material.dart';

import '../../../core/dummy_data.dart';
import '../../../core/theme.dart';
import '../data/home_repository.dart';
import '../widgets/product_card.dart';
import '../widgets/category_chip.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, this.repository});

  final HomeRepository? repository;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final HomeRepository _repository = widget.repository ?? HomeRepository();
  List<Product> _products = const [];
  List<String> _categories = const [];
  String _selectedCategory = 'All';
  String? _errorMessage;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadHomeData();
  }

  Future<void> _loadHomeData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final data = await _repository.fetchHomeData();
      if (!mounted) return;
      setState(() {
        _products = data.products;
        _categories = data.categories;
        _selectedCategory = 'All';
      });
    } on HomeRepositoryException catch (error) {
      if (mounted) setState(() => _errorMessage = error.message);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
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
                          final category = index == 0
                              ? 'All'
                              : _categories[index - 1];
                          return CategoryChip(
                            label: category,
                            isSelected: _selectedCategory == category,
                            onTap: () {
                              setState(() {
                                _selectedCategory = category;
                              });
                            },
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
            const SliverToBoxAdapter(child: SizedBox(height: 24)),
          ],
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
              ? () => setState(() => _selectedCategory = 'All')
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
