import 'package:ecommerce_app_huma_volve/features/home/data/models/home_categories_model.dart';
import 'package:ecommerce_app_huma_volve/features/home/data/models/home_products_model.dart';

abstract class HomeRemoteDatasource {
  Future<List<HomeCategoriesModel>> getCategories();

  Future<List<HomeProductsModel>> getProducts(
    int? categoryId, {
    required int limit,
    required int offset,
  });
}
