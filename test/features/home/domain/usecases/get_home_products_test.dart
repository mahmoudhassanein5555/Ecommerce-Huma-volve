import 'package:flutter_test/flutter_test.dart';
import 'package:ecommerce_app_huma_volve/core/domain/entities/product.dart';
import 'package:ecommerce_app_huma_volve/features/home/domain/entities/home_category.dart';
import 'package:ecommerce_app_huma_volve/features/home/domain/repositories/home_repository.dart';
import 'package:ecommerce_app_huma_volve/features/home/domain/usecases/get_home_products.dart';

void main() {
  test('uses first valid image URL and fallback for invalid images', () async {
    final useCase = GetHomeProducts(_FakeHomeRepository());

    final products = await useCase();

    expect(products.first.imageUrl, 'https://example.com/product.png');
    expect(
      products.last.imageUrl,
      'https://placehold.co/600x600/png?text=Product',
    );
  });
}

class _FakeHomeRepository implements HomeRepository {
  @override
  Future<List<Product>> fetchProducts({
    int? categoryId,
    String? title,
    int offset = 0,
    int limit = 20,
  }) async {
    return [
      _product(id: '1', imageUrl: 'broken ["https://example.com/product.png"]'),
      _product(id: '2', imageUrl: 'not a valid image URL'),
    ];
  }

  @override
  Future<List<HomeCategory>> fetchCategories() async => const [];

  Product _product({required String id, required String imageUrl}) {
    return Product(
      id: id,
      name: 'Product $id',
      description: '',
      price: 1,
      imageUrl: imageUrl,
      colors: const [],
      sizes: const [],
    );
  }
}
