
import '../entities/category_entity.dart';
import '../entities/product_entity.dart';

abstract class HomeRepository {
  Future<List<CategoryEntity>> getCategories();

  Future<List<ProductEntity>> getProducts(
    int categoryId, {
    int offset = 0,
    int limit = 10,
  });

  Future<ProductEntity> getProductById(int id);
}
