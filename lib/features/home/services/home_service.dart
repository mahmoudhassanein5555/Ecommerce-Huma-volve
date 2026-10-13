import 'package:ecommerce_app_huma_volve/features/home/services/models/product_model.dart';

import '../../../core/constants/api_endpoints.dart';
import '../../../core/network/api_client.dart';
import 'models/category_model.dart';

class HomeService {
  final ApiClient _apiClient;
  HomeService(this._apiClient);

  Future<List<CategoryModel>> getCategories() async {
    final response = await _apiClient.dio.get(ApiEndpoints.categoriesEndpoint);

    final List jsonData = response.data;
    final List<CategoryModel> category = jsonData
        .map((e) => CategoryModel.fromJson(e))
        .toList();

    return category;
  }

  Future<List<ProductModel>> getProducts(int? categoryId) async {
    final response = await _apiClient.dio.get(
      "${ApiEndpoints.categoriesEndpoint}/$categoryId/${ApiEndpoints.productsEndpoint}",
    );

    final List jsonData = response.data;
    final List<ProductModel> product = jsonData
        .map((e) => ProductModel.fromJson(e))
        .toList();

    return product;
  }
}
