import '../../models/category_model.dart';
import '../../models/products_model.dart';

abstract class HomeRemoteDataSource {
  Future<List<HomeCategoryModel>> getCategories();
  Future<List<HomeProductsModel>> getProducts(
    num? categoryId, {
    required int? limit,
    required int? offset,
  });
}
