import 'package:flutter/material.dart';
import '../../../core/dummy_data.dart';
import '../../../core/theme.dart';
import '../../home/presentation/widgets/color_selector.dart';
import '../../home/presentation/widgets/size_selector.dart';
import '../../../core/widgets/primary_button.dart';

class ProductDetailsScreen extends StatefulWidget {
  final String productId; // تعديل لاستقبال الـ ID بدلاً من الـ Product كامل

  const ProductDetailsScreen({super.key, required this.productId});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  late Product product;
  late Color _selectedColor;
  late String _selectedSize;

  @override
  void initState() {
    super.initState();
    // البحث عن المنتج باستخدام الـ ID القادم من الـ Deep Link
    product = dummyProducts.firstWhere(
      (p) => p.id.toString() == widget.productId,
      orElse: () => dummyProducts.first, // قيمة افتراضية لو مش موجود
    );
    _selectedColor = product.colors.first;
    _selectedSize = product.sizes.first;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 400,
            pinned: true,
            backgroundColor: AppTheme.background,
            leading: IconButton(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.9),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.arrow_back_ios_new, size: 16),
              ),
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
              IconButton(
                icon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.9),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.favorite_border, size: 18),
                ),
                onPressed: () {},
              ),
              const SizedBox(width: 8),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Hero(
                tag: 'product-${product.id}',
                child: Image.network(product.imageUrl, fit: BoxFit.cover),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
              ),
              transform: Matrix4.translationValues(0.0, -32.0, 0.0),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            product.name,
                            style: Theme.of(context).textTheme.headlineLarge
                                ?.copyWith(fontSize: 28, height: 1.2),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Text(
                          '\$${product.price.toStringAsFixed(2)}',
                          style: Theme.of(context).textTheme.headlineLarge
                              ?.copyWith(color: AppTheme.primary, fontSize: 24),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Description',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      product.description,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        height: 1.6,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Select Color',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ColorSelector(
                      colors: product.colors,
                      selectedColor: _selectedColor,
                      onColorSelected: (color) {
                        setState(() {
                          _selectedColor = color;
                        });
                      },
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Select Size',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizeSelector(
                      sizes: product.sizes,
                      selectedSize: _selectedSize,
                      onSizeSelected: (size) {
                        setState(() {
                          _selectedSize = size;
                        });
                      },
                    ),
                    const SizedBox(height: 32),
                    PrimaryButton(
                      text: 'Add to Cart',
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('${product.name} added to cart'),
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            backgroundColor: AppTheme.primary,
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
