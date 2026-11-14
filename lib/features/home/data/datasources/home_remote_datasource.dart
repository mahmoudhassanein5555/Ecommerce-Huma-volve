import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/network/api_client.dart';
import '../models/category_model.dart';
import '../models/product_model.dart';

abstract class HomeRemoteDataSource {
  Future<List<CategoryModel>> getCategories();
  Future<List<ProductModel>> getProducts(
    int categoryId, {
    required int limit,
    required int offset,
  });
}

class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  final ApiClient _apiClient;
  HomeRemoteDataSourceImpl({required this._apiClient});

  @override
  Future<List<CategoryModel>> getCategories() async {
    final response = await _apiClient.dio.get(ApiEndpoints.categoriesEndpoint);

    final List jsonData = response.data;

    List<CategoryModel> category = jsonData
        .map((e) => CategoryModel.fromJson(e))
        .toList();

    return category;
  }

  //https://api.escuelajs.co/api/v1/products?limit=10&offset=0

  @override
  Future<List<ProductModel>> getProducts(
    int categoryId, {
    required int limit,
    required int offset,
  }) async {
    final response = await _apiClient.dio.get(
      "${ApiEndpoints.categoriesEndpoint}/$categoryId/${ApiEndpoints.productsEndpoint}",

      queryParameters: {"limit": limit, "offset": offset},
    );

    final List jsonData = response.data;

    List<ProductModel> products = jsonData
        .map((e) => ProductModel.fromJson(e))
        .toList();

    return products;
  }
}
