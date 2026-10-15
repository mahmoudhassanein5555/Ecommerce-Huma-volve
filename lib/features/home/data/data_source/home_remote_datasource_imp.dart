import 'package:ecommerce_app_huma_volve/core/constants/api_endpoints.dart';
import 'package:ecommerce_app_huma_volve/core/network/api_client.dart';
import 'package:ecommerce_app_huma_volve/features/home/data/data_source/home_remote_datasource.dart';
import 'package:ecommerce_app_huma_volve/features/home/data/models/home_categories_model.dart';
import 'package:ecommerce_app_huma_volve/features/home/data/models/home_products_model.dart';

class HomeRemoteDatasourceImp implements HomeRemoteDatasource {
  final ApiClient apiClient;
  HomeRemoteDatasourceImp(this.apiClient);
  @override
  Future<List<HomeCategoriesModel>> getCategories() async {
    final response = await apiClient.dio.get(ApiEndpoints.categories);
    return (response.data as List)
        .map((e) => HomeCategoriesModel.fromJson(e))
        .toList();
  }

  @override
  Future<List<HomeProductsModel>> getProducts(
    int? categoryId, {
    required int limit,
    required int offset,
  }) async {
    final response = await apiClient.dio.get(
      "${ApiEndpoints.categories}/$categoryId/${ApiEndpoints.products}",
      queryParameters: {"limit": limit, "offset": offset},
    );
    return (response.data as List)
        .map((e) => HomeProductsModel.fromJson(e))
        .toList();
  }
}
