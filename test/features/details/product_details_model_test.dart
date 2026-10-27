import 'package:ecommerce_app_huma_volve/features/details/data/models/product_details_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('maps product response into the domain entity', () {
    final product = ProductDetailsModel.fromJson({
      'id': 7,
      'title': 'Leather Wallet',
      'price': 39.95,
      'description': 'Compact leather wallet.',
      'images': ['https://example.com/wallet.jpg', 12],
    }).toDomain();

    expect(product.id, 7);
    expect(product.title, 'Leather Wallet');
    expect(product.price, 39.95);
    expect(product.description, 'Compact leather wallet.');
    expect(product.images, ['https://example.com/wallet.jpg']);
  });

  test('rejects incomplete product responses', () {
    final model = ProductDetailsModel.fromJson({
      'id': 7,
      'title': 'Leather Wallet',
      'images': const [],
    });

    expect(model.toDomain, throwsFormatException);
  });
}
