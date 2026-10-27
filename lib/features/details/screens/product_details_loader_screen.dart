import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/theme.dart';
import '../../../core/widgets/primary_button.dart';
import '../details_dependencies.dart';
import '../presentation/cubit/product_details_cubit.dart';
import '../presentation/cubit/product_details_state.dart';
import 'product_details_screen.dart';

/// Entry point for opening Product Details from just a product id - what a
/// deep link carries - rather than an already-loaded [Product] object, which
/// is all the existing [ProductDetailsScreen] accepts. Fetches the product
/// via [ProductDetailsCubit], then hands off to the existing, unmodified
/// [ProductDetailsScreen] once it's loaded.
class ProductDetailsLoaderScreen extends StatelessWidget {
  const ProductDetailsLoaderScreen({
    super.key,
    required this.productId,
    ProductDetailsCubit Function()? cubitBuilder,
  }) : _cubitBuilder = cubitBuilder;

  final int productId;

  /// Overrides how the cubit is built - for tests only, so they can inject
  /// a fake instead of hitting the real network. Production code always
  /// omits this and gets `DetailsDependencies.buildProductDetailsCubit`.
  final ProductDetailsCubit Function()? _cubitBuilder;

  @override
  Widget build(BuildContext context) {
    final builder =
        _cubitBuilder ?? DetailsDependencies.buildProductDetailsCubit;
    return BlocProvider(
      create: (_) => builder()..loadProduct(productId),
      child: _ProductDetailsLoaderView(productId: productId),
    );
  }
}

class _ProductDetailsLoaderView extends StatelessWidget {
  const _ProductDetailsLoaderView({required this.productId});

  final int productId;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductDetailsCubit, ProductDetailsState>(
      builder: (context, state) {
        return switch (state) {
          ProductDetailsLoaded(:final product) => ProductDetailsScreen(
            product: product,
          ),
          ProductDetailsNotFound() => const _StatusScaffold(
            icon: Icons.search_off,
            message: 'This product could not be found.',
          ),
          ProductDetailsError(:final message) => _StatusScaffold(
            icon: Icons.error_outline,
            message: message,
            onRetry: () =>
                context.read<ProductDetailsCubit>().loadProduct(productId),
          ),
          _ => const _StatusScaffold(isLoading: true),
        };
      },
    );
  }
}

class _StatusScaffold extends StatelessWidget {
  const _StatusScaffold({
    this.isLoading = false,
    this.icon,
    this.message,
    this.onRetry,
  });

  final bool isLoading;
  final IconData? icon;
  final String? message;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        backgroundColor: AppTheme.background,
        elevation: 0,
        leading: Navigator.of(context).canPop()
            ? IconButton(
                icon: const Icon(Icons.arrow_back_ios_new, size: 16),
                onPressed: () => Navigator.of(context).pop(),
              )
            : null,
      ),
      body: Center(
        child: isLoading
            ? const CircularProgressIndicator(color: AppTheme.primary)
            : Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(icon, size: 56, color: AppTheme.error),
                    const SizedBox(height: 16),
                    Text(
                      message ?? 'Something went wrong. Please try again.',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium
                          ?.copyWith(fontSize: 16),
                    ),
                    if (onRetry != null) ...[
                      const SizedBox(height: 24),
                      SizedBox(
                        width: 160,
                        child: PrimaryButton(
                          text: 'Retry',
                          onPressed: onRetry!,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
      ),
    );
  }
}
