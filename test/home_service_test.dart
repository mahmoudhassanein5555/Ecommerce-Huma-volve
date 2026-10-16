
import 'package:flutter_test/flutter_test.dart';
import 'package:ecommerce_app_huma_volve/features/home/services/home_service.dart';

void main() {
  test('Fetch categories and products', () async {
    final homeService = HomeService();

    final categories = await homeService.getCategories();

    expect(categories, isNotEmpty);

    final products = await homeService.getProducts(
      categories.first.id,
    );

    expect(products, isNotEmpty);
  });
}
