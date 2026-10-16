import 'package:ecommerce_app_huma_volve/features/home/domain/entities/product.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

class ShareProductButton extends StatelessWidget {
  final Product product;

  const ShareProductButton({super.key, required this.product});

  Future<void> _shareProduct() async {
    final String productLink = 'https://hume-volve-ecommerce.web.app/products/${product.id}';
    final String shareText = 'Check out this product: ${product.title}\nPrice: \$${product.price.toStringAsFixed(2)}\n\n${product.description}\n\n$productLink';

    await Share.share(
      shareText,
      subject: product.title,
    );
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.9),
          shape: BoxShape.circle,
        ),
        child: const Icon(Icons.share, size: 18),
      ),
      onPressed: _shareProduct,
    );
  }
}
