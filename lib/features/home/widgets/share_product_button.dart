import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

class ShareProductButton extends StatelessWidget {
  final String productId;
  final String productTitle;

  const ShareProductButton({
    super.key,
    required this.productId,
    required this.productTitle,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.9),
          shape: BoxShape.circle,
        ),
        child: const Icon(Icons.share, size: 18, color: Colors.black),
      ),
      onPressed: () {
        // الطريقة الثانية: رابط HTTPS احترافي يدعم App Links
        final String shareUrl = 'https://huma-volve.com/products/$productId';
        final String shareMessage =
            'Check out $productTitle on Huma-volve:\n$shareUrl';

        Share.share(shareMessage);
      },
    );
  }
}
