import 'package:ecommerce_app_huma_volve/core/Network/api_client.dart';
import 'package:ecommerce_app_huma_volve/core/constants/api_endpoints.dart';

import '../models/categoryModel.dart';
import '../models/productModel/productModel.dart';

class HomeService {
  final ApiClient apiClient;

  HomeService(this.apiClient);

  Future<List<CategoryModel>> getCategories() async {
    final response = await apiClient.dio.get(
      ApiEndpoints.categoriesEndpoint,
    );

    final List<dynamic> data = response.data;

    return data
        .map(
          (item) => CategoryModel.fromJson(
        Map<String, dynamic>.from(item),
      ),
    )
        .toList();
  }

  Future<List<ProductModel>> getProducts() async {
    final response = await apiClient.dio.get(
      ApiEndpoints.productsEndpoint,
    );

    final List<dynamic> data = response.data;

    return data
        .map(
          (item) => ProductModel.fromJson(
        Map<String, dynamic>.from(item),
      ),
    )
        .toList();
  }
}
