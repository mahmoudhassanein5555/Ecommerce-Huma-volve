import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/network/api_client.dart';
import '../models/home_category_model.dart';
import '../models/home_product_model.dart';

abstract class HomeRemoteDataSource {
  Future<List<HomeCategoryModel>> getCategories();

  Future<List<HomeProductModel>> getProducts({
    required int categoryId,
  });
}

class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  @override
  Future<List<HomeCategoryModel>> getCategories() async {
    final response = await ApiClient.dio.get(
      ApiEndpoints.categories,
    );

    final data = response.data as List;

    return data.map((item) {
      return HomeCategoryModel.fromJson(
        Map<String, dynamic>.from(item as Map),
      );
    }).toList();
  }

  @override
  Future<List<HomeProductModel>> getProducts({
    required int categoryId,
  }) async {
    final response = await ApiClient.dio.get(
      ApiEndpoints.categoryProducts(categoryId),
    );

    final data = response.data as List;

    return data.map((item) {
      return HomeProductModel.fromJson(
        Map<String, dynamic>.from(item as Map),
      );
    }).toList();
  }
}