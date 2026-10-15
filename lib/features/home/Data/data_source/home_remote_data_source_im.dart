import 'package:dio/dio.dart';
import 'package:ecommerce_app_huma_volve/core/constant/api_EndPoint.dart';
import 'package:ecommerce_app_huma_volve/core/netWork/api_client.dart';
import 'package:ecommerce_app_huma_volve/features/home/Data/data_source/home_remote_data_source.dart';
import 'package:ecommerce_app_huma_volve/features/home/Data/model/category_model.dart';
import 'package:ecommerce_app_huma_volve/features/home/Data/model/product_model.dart';

class HomeRemoteDataSourceIm implements HomeRemoteDataSource {
  ApiClient apiClient;
  HomeRemoteDataSourceIm({required this.apiClient});
  @override
  Future<List<HomeCategoryModel>> getCategories() async {
    final response = await apiClient.dio.get(ApiEndPoints.categories);
    List data = response.data;
    List<HomeCategoryModel> categories = data
        .map((e) => HomeCategoryModel.fromJson(e))
        .toList();
    categories.insert(0, HomeCategoryModel(id: -1, name: 'All'));
    return categories;
  }

  @override
  Future<List<HomeProductModel>> getProducts(int categoryId, int offSet) async {
    List data;
    final Response<dynamic> response;
    if (categoryId == -1) {
      response = await apiClient.dio.get(
        "${ApiEndPoints.products}?limit=10&offset=$offSet",
      );
      data = response.data;
    } else {
      response = await apiClient.dio.get(
        "${ApiEndPoints.categories}/$categoryId/${ApiEndPoints.products}",
        queryParameters: {"limit": 10, "offset": offSet},
      );
    }
    data = response.data;
    List<HomeProductModel> products = data
        .map((e) => HomeProductModel.fromJson(e))
        .toList();
    return products;
  }
}
