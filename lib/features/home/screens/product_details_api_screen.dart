
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/home_cubit.dart';
import '../domain/entities/product_entity.dart';

class ProductDetailsApiScreen extends StatefulWidget {
  final int productId;

  const ProductDetailsApiScreen({
    super.key,
    required this.productId,
  });

  @override
  State<ProductDetailsApiScreen> createState() =>
      _ProductDetailsApiScreenState();
}

class _ProductDetailsApiScreenState
    extends State<ProductDetailsApiScreen> {
  late Future<ProductEntity> _productFuture;

  @override
  void initState() {
    super.initState();
    _productFuture = context
        .read<HomeCubit>()
        .getProductById(widget.productId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Details'),
      ),
      body: FutureBuilder<ProductEntity>(
        future: _productFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState ==
              ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
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
                    const Text(
                      'Could not load product details.',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _productFuture = context
                              .read<HomeCubit>()
                              .getProductById(widget.productId);
                        });
                      },
                      child: const Text('Try Again'),
                    ),
                  ],
                ),
              ),
            );
          }

          if (!snapshot.hasData) {
            return const Center(
              child: Text('Product not found'),
            );
          }

          final product = snapshot.data!;
          final imageUrl = product.images.isNotEmpty
              ? product.images.first
              : null;

          return ListView(
            padding: const EdgeInsets.all(20),
            children: [
              if (imageUrl != null)
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.network(
                    imageUrl,
                    height: 300,
                    fit: BoxFit.cover,
                    errorBuilder: (_, _, _) {
                      return const SizedBox(
                        height: 300,
                        child: Center(
                          child: Icon(
                            Icons.broken_image_outlined,
                            size: 60,
                          ),
                        ),
                      );
                    },
                  ),
                )
              else
                const SizedBox(
                  height: 200,
                  child: Center(
                    child: Icon(
                      Icons.image_not_supported,
                      size: 60,
                    ),
                  ),
                ),
              const SizedBox(height: 24),
              Text(
                product.title,
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall
                    ?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 12),
              Text(
                '\$${product.price.toStringAsFixed(2)}',
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 16),
              Text('Product ID: ${product.id}'),
            ],
          );
        },
      ),
    );
  }
}
