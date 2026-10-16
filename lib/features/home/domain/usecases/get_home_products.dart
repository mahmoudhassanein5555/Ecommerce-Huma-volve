import '../../../../core/domain/entities/product.dart';
import '../../../../core/utils/image_url_sanitizer.dart';
import '../repositories/home_repository.dart';

class GetHomeProducts {
  const GetHomeProducts(this._repository);

  final HomeRepository _repository;

  Future<List<Product>> call({
    int? categoryId,
    String? title,
    int offset = 0,
    int limit = 20,
  }) async {
    final products = await _repository.fetchProducts(
      categoryId: categoryId,
      title: title,
      offset: offset,
      limit: limit,
    );
    return products.map((product) {
      final imageUrl = ImageUrlSanitizer.firstValidUrl([product.imageUrl]);
      return Product(
        id: product.id,
        name: product.name,
        description: product.description,
        price: product.price,
        imageUrl: imageUrl,
        colors: product.colors,
        sizes: product.sizes,
        categoryId: product.categoryId,
        categoryName: product.categoryName,
      );
    }).toList();
  }
}
