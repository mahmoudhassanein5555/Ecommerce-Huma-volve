import 'package:ecommerce_app_huma_volve/core/constants/api_endpoints.dart';
import 'package:ecommerce_app_huma_volve/core/network/api_client.dart';
import 'package:ecommerce_app_huma_volve/features/home/models/category_model.dart';
import 'package:ecommerce_app_huma_volve/features/home/models/product_model.dart';

class HomeService {
  final ApiClient apiClient;

  HomeService(this.apiClient);

  Future<List<CategoryModel>> getCategories() async {
    final response = await apiClient.dio.get(ApiEndpoints.categoriesEndpoint);
    final List jsonData = response.data;
    final List<CategoryModel> categories = jsonData
        .map((category) => CategoryModel.fromJson(category))
        .toList();

    return categories;
  }

  Future<List<ProductModel>> getProducts({required int categoryId}) async {
    final response = await apiClient.dio.get(
      '${ApiEndpoints.categoriesEndpoint}/$categoryId/${ApiEndpoints.productsEndpoint}',
    );
    final List jsonData = response.data;
    final List<ProductModel> products = jsonData
        .map((product) => ProductModel.fromJson(product))
        .toList();

    return products;
  }
}
