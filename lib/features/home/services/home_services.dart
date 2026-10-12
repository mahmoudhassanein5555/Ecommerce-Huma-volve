import '../../../core/constants/api_endpoints.dart';
import '../../../core/network/api_client.dart';
import '../models/category_model.dart';
import '../models/product_model.dart';

class HomeServices {
  Future<List<CategoryModel>> getCategories() async {
    final response = await ApiClient.dio.get(ApiEndpoints.categories);
    final data = response.data as List;
    return data
        .map((item) => CategoryModel.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<List<ProductModel>> getProducts({required int categoryId}) async {
    final response = await ApiClient.dio.get(
      ApiEndpoints.categoryProducts(categoryId),
    );
    final data = response.data as List;
    return data
        .map((item) => ProductModel.fromJson(item as Map<String, dynamic>))
        .toList();
  }
}