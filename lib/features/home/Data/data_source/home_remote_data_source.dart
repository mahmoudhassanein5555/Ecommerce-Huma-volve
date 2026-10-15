import 'package:ecommerce_app_huma_volve/features/home/Data/model/category_model.dart';
import 'package:ecommerce_app_huma_volve/features/home/Data/model/product_model.dart';

abstract class HomeRemoteDataSource {
  Future<List<HomeCategoryModel>> getCategories();
  Future<List<HomeProductModel>> getProducts(int categoryId, int offSet);
}
