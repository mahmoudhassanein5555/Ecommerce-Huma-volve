
import 'package:flutter_test/flutter_test.dart';
import 'package:ecommerce_app_huma_volve/features/home/services/home_service.dart';

void main() {
  test('Fetch categories and products', () async {
    final homeService = HomeService();

    final categories = await homeService.getCategories();

    print('Categories count: ${categories.length}');

    for (final category in categories) {
      print('${category.id} - ${category.name}');
    }

    expect(categories, isNotEmpty);

    final products = await homeService.getProducts(
      categories.first.id,
    );

    print('Products count: ${products.length}');

    for (final product in products) {
      print('${product.id} - ${product.title} - ${product.price}');
    }

    expect(products, isNotEmpty);
  });
}

