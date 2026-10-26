import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

class ShareProductButton extends StatelessWidget {
  const ShareProductButton({super.key, required this.productId});
  final String productId;
  @override
  Widget build(BuildContext context) {
    return IconButton(onPressed: () async{
      final productLink = 'https://first-firebase-12fd1.web.app/products/$productId';
      final String shareMessage = 'Look At This Product: $productLink';
      await SharePlus.instance.share(
      ShareParams(text: shareMessage, subject: 'Check out this product on Huma Volve')
    );
    }, icon: Icon(Icons.share));
  }
}