import '../entities/home_category_entity.dart';
import '../entities/home_product_entity.dart';

abstract class HomeRepository {
  Future<List<HomeCategoryEntity>> getCategories();

  Future<List<HomeProductEntity>> getProducts({
    required int categoryId,
  });
}