import 'package:ecommerce_app_huma_volve/core/networking/api_service.dart';
import 'package:ecommerce_app_huma_volve/features/home/data/models/category_response_model.dart';
import 'package:ecommerce_app_huma_volve/features/home/data/models/product_response_model.dart';

class HomeRemoteDataSource {
  final ApiServices apiServices;

  HomeRemoteDataSource(this.apiServices);

  Future<List<ProductResponseModel>> getAllProducts({
    required int limit,
    required int offset,
  }) async {
    return await apiServices.getProducts(limit, offset);
  }

  Future<List<ProductResponseModel>> getCategoriesProducts({
    required int categoryId,
    required int limit,
    required int offset,
  }) async {
    return await apiServices.getCategoriesProducts(categoryId, limit, offset);
  }

  Future<List<CategoryResponseModel>> getAllCategories() async {
    return await apiServices.getCategories();
  }
}
