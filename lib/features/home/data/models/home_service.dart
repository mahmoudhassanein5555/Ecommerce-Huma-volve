import 'package:ecommerce_app_huma_volve/core/constants/api_constants.dart';
import 'package:ecommerce_app_huma_volve/core/constants/api_endpoints.dart';
import 'package:ecommerce_app_huma_volve/core/network/api_client.dart';

import 'category_model.dart';
import 'product_model.dart';

class HomeService {
  HomeService(this._apiClient);

  final ApiClient _apiClient;

  Future<List<CategoryModel>> getCategories() async {
    final response = await _apiClient.get(ApiEndpoints.categories);
    final List jsonData = response.data;
    final categoriesData = jsonData
        .map((category) => CategoryModel.fromJson(category))
        .toList();
    return categoriesData;
  }

  Future<List<ProductModel>> getCategoryById({
    int? id,
    required int limit,
    required int offset,
  }) async {
    final response = await _apiClient.get(
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
