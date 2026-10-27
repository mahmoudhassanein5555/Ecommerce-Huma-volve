import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

class ShareProductButton extends StatelessWidget {
  const ShareProductButton({super.key, required this.productId});
  final String productId;
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.share),
      onPressed: () async {
        final productLink = 'https://ecommerce-huma-volve-125b9.web.app/products/$productId';
        String shareMessage = 'Look at this product: $productLink';
       await SharePlus.instance.share(ShareParams(
        text: shareMessage,
        subject: "Check out this product on huma volve"
       ));
      },
    );
  }
}
