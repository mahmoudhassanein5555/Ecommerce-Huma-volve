import '../data/models/home_category_model.dart';
import '../data/models/home_product_model.dart';
import '../../../core/constants/api_endpoints.dart';
import '../../../core/network/api_client.dart';

class HomeServices {
  Future<List<HomeCategoryModel>> getCategories() async {
    final response = await ApiClient.dio.get(ApiEndpoints.categories);

    final data = response.data as List;

    return data
        .map(
          (item) => HomeCategoryModel.fromJson(
            item as Map<String, dynamic>,
          ),
        )
        .toList();
  }

  Future<List<HomeProductModel>> getProducts({
    required int categoryId,
  }) async {
    final response = await ApiClient.dio.get(
      ApiEndpoints.categoryProducts(categoryId),
    );

    final data = response.data as List;

    return data
        .map(
          (item) => HomeProductModel.fromJson(
            item as Map<String, dynamic>,
          ),
        )
        .toList();
  }
}