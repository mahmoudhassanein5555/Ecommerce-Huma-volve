import 'package:ecommerce_app_huma_volve/features/home/data/models/category_response_model.dart';
import 'package:ecommerce_app_huma_volve/features/home/data/models/products_response_model.dart';

abstract class HomeRemoteDataSource {
  Future<List<ProductsResponseModel>> getProductByCategoryId(int? categoryId);

  Future<List<CategoryResponseModel>> getCategoryList();
}
