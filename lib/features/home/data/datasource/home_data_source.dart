

import 'package:ecommerce_app_huma_volve/features/home/data/model/Categories_model.dart';
import 'package:ecommerce_app_huma_volve/features/home/data/model/Products_model.dart';

abstract class HomeDataSource {
  Future<List<CategoriesModel>> getCategories();

  Future<List<ProductsModel>> getProducts(num? categoryId);
}