import '../entities/product_entity.dart';

abstract class HomeRepository {
  Future<List<ProductEntity>> getProducts({
    required int limit,
    required int offset,
  });

  Future<List<ProductEntity>> getProductsByCategory({
    required int categoryId,
    required int limit,
    required int offset,
  });

  Future<ProductEntity> getProductById(int id);
}
