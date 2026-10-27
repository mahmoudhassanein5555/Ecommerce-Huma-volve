import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

class ShareProductBottom extends StatelessWidget {
  final String productId;

  const ShareProductBottom({super.key, required this.productId});

  @override
  Widget build(BuildContext context) {
    // رابط المنتج
    final String productLink = "https://example.com/product/$productId";

    return IconButton(
      onPressed: () async {
        final String shareMessage = "Look at this product: $productLink";
        
        // الطريقة الصحيحة للمشاركة
        await Share.share(
          shareMessage,
          subject: 'Check out this product on Human Volve',
        );
      },
      icon: const Icon(Icons.share),
    );
  }
}