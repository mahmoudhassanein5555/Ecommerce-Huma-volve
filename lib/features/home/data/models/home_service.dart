import 'package:dio/dio.dart';
import 'package:ecommerce_app_huma_volve/core/constants/api_constants.dart';
import 'package:ecommerce_app_huma_volve/core/constants/api_endpoints.dart';

import 'category_model.dart';
import 'product_model.dart';

class HomeService {
  HomeService(this._dio);

  final Dio _dio;

  Future<List<CategoryModel>> getCategories() async {
    try {
      final response = await _dio.get(ApiEndpoints.categories);
      List jsonData = response.data;
      List<CategoryModel> categoriesData = jsonData
          .map((category) => CategoryModel.fromJson(category))
          .toList();
      return categoriesData;
    } on DioException catch (e) {
      throw Exception(e.message);
    }
  }

  Future<List<ProductModel>> getCategoryById({
    int? id,
    required int limit,
    required int offset,
  }) async {
    final response = await _dio.get(
      '${ApiEndpoints.categories}/$id/${ApiEndpoints.products}',
      queryParameters: {ApiConstants.limit: limit, ApiConstants.offset: offset},
    );
    final List jsonData = response.data;
    List<ProductModel> products = jsonData
        .map((product) => ProductModel.fromJson(product))
        .toList();
    return products;
  }
}
