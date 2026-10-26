import 'package:ecommerce_app_huma_volve/core/constants/api_endpoints.dart';
import 'package:ecommerce_app_huma_volve/core/network/api_client.dart';
import 'package:ecommerce_app_huma_volve/features/home/data/data_source/home_remote_data_source.dart';
import 'package:ecommerce_app_huma_volve/features/home/data/models/category_model.dart';
import 'package:ecommerce_app_huma_volve/features/home/data/models/product_model.dart';

class HomeRemoteDataSourceImp implements HomeRemoteDataSource {
  final ApiClient apiClient;
  HomeRemoteDataSourceImp(this.apiClient);

  @override
  Future<List<HomeCategoryModel>> getCategories() async {
    final response = await apiClient.dio.get(ApiEndpoints.categoriesEndpoint);
    final List jsonData = response.data;
    final List<HomeCategoryModel> categories =
        jsonData.map((e) => HomeCategoryModel.fromJson(e)).toList();
    return categories;
  }

  @override
  Future<List<HomeProductModel>> getProducts(int? categoryId, {required int offset, required int limit}) async {
    final response = await apiClient.dio.get(
      '${ApiEndpoints.categoriesEndpoint}/$categoryId/${ApiEndpoints.productsEndpoint}',
      queryParameters: {
        'limit' : limit,
        'offset' : offset
      }
    );

    final List jsonData = response.data;
    final List<HomeProductModel> products =
        jsonData.map((e) => HomeProductModel.fromJson(e)).toList();
    return products;
  }
}