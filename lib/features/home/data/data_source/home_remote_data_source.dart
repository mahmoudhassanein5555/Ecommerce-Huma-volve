import 'package:ecommerce_app_huma_volve/features/home/data/models/category_model.dart';
import 'package:ecommerce_app_huma_volve/features/home/data/models/product_model.dart';

abstract class HomeRemoteDataSource {
  Future<List<HomeCategoryModel>> getCategories();
  Future<List<HomeProductModel>> getProducts(int? categoryId, {required int offset, required int limit});
}