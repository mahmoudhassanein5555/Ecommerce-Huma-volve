import 'package:flutter/material.dart';

import '../../../core/theme.dart';
import '../../../core/widgets/primary_button.dart';
import '../../home/domain/entities/home_product_entity.dart';
import '../../home/widgets/share_product_button.dart';

class ProductDetailsScreen extends StatefulWidget {
  final HomeProductEntity product;

  const ProductDetailsScreen({super.key, required this.product});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    final hasImages = widget.product.images.isNotEmpty;

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
                  color: Colors.white.withOpacity(0.9),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.arrow_back_ios_new,
                  size: 16,
                  color: Colors.black,
                ),
              ),
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
              ShareProductButton(
                productId: widget.product.id.toString(),
                productTitle: widget.product.title,
              ),
              IconButton(
                icon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.favorite_border,
                    size: 18,
                    color: Colors.black,
                  ),
                ),
                onPressed: () {},
              ),
              const SizedBox(width: 8),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Hero(
                tag: 'product-${widget.product.id}',
                child:
                    hasImages
                        ? Image.network(
                          widget.product.images.first,
                          fit: BoxFit.cover,
                          errorBuilder:
                              (context, error, stackTrace) =>
                                  const Center(child: Icon(Icons.error)),
                        )
                        : Container(
                          color: Colors.grey.shade200,
                          child: const Icon(
                            Icons.image,
                            size: 100,
                            color: Colors.grey,
                          ),
                        ),
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
                            widget.product.title,
                            style: Theme.of(context).textTheme.headlineLarge
                                ?.copyWith(fontSize: 28, height: 1.2),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Text(
                          '\$${widget.product.price.toStringAsFixed(2)}',
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
                      widget.product.description.isEmpty
                          ? "No description available."
                          : widget.product.description,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        height: 1.6,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 32),
                    PrimaryButton(
                      text: 'Add to Cart',
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              '${widget.product.title} added to cart',
                            ),
                            behavior: SnackBarBehavior.floating,
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
