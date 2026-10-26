import 'package:ecommerce_app_huma_volve/features/details/widgets/share_product_button.dart';
import 'package:ecommerce_app_huma_volve/features/home/domain/entities/home_product_entity.dart';
import 'package:flutter/material.dart';

import '../../../core/theme.dart';
import '../widgets/color_selector.dart';
import '../widgets/size_selector.dart';
import '../../../core/widgets/primary_button.dart';

class ProductDetailsScreen extends StatefulWidget {
  final HomeProductEntity product;
  final  int? productId;
 
  const ProductDetailsScreen({super.key, required this.product, this.productId});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  late Color _selectedColor;
  late String _selectedSize;
  final List<Color> _colors = [
    Colors.black,
    Colors.blue,
    Colors.red,
  ];
  final List<String> _sizes = [
    'S',
    'M',
    'L',
    'XL',
  ];

  @override
  void initState() {
    super.initState();
    _selectedColor = _colors.first;
    _selectedSize = _sizes.first;
  }

  @override
  Widget build(BuildContext context) {
    final imageUrl = widget.product.images.isNotEmpty ? widget.product.images.first : '';

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            backgroundColor: AppTheme.background,
            leading: IconButton(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.9),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.arrow_back_ios_new,
                  size: 16,
                ),
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
                  child: const Icon(
                    Icons.favorite_border,
                    size: 18,
                  ),
                ),
                onPressed: () {},
              ),
              const SizedBox(width: 8),
              ShareProductButton(productId: widget.productId.toString()),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Hero(
                tag: 'product-${widget.product.id}',
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: Colors.grey.shade200,
                    child: const Center(
                      child: Icon(
                        Icons.image_not_supported_outlined,
                        color: Colors.grey,
                        size: 40,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(
                    32,
                  ),
                ),
              ),
              transform: Matrix4.translationValues(
                0.0,
                -32.0,
                0.0,
              ),
              child: Padding(
                padding: const EdgeInsets.all(
                  24.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            widget.product.title,
                            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                              fontSize: 28,
                              height: 1.2,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Text(
                          '\$${widget.product.price.toStringAsFixed(2)}',
                          style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                            color: AppTheme.primary,
                            fontSize: 24,
                          ),
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
                      widget.product.description,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        height: 1.6,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    Text(
                      'Select Color',
                      style:
                          Theme.of(
                            context,
                          ).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    ColorSelector(
                      colors: _colors,
                      selectedColor: _selectedColor,
                      onColorSelected:
                          (
                            color,
                          ) {
                            setState(() {
                              _selectedColor = color;
                            });
                          },
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    Text(
                      'Select Size',
                      style:
                          Theme.of(
                            context,
                          ).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    SizeSelector(
                      sizes: _sizes,
                      selectedSize: _selectedSize,
                      onSizeSelected:
                          (
                            size,
                          ) {
                            setState(() {
                              _selectedSize = size;
                            });
                          },
                    ),
                    const SizedBox(
                      height: 32,
                    ),
                    PrimaryButton(
                      text: 'Add to Cart',
                      onPressed: () {
                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(
                          SnackBar(
                            content: Text(
                              '${widget.product.title} added to cart',
                            ),
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            backgroundColor: AppTheme.primary,
                          ),
                        );
                      },
                    ),
                    const SizedBox(
                      height: 24,
                    ),
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
