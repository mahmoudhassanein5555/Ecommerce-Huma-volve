import 'package:dio/src/response.dart';
import 'package:ecommerce_app_huma_volve/core/constant/api_EndPoint.dart';
import 'package:ecommerce_app_huma_volve/core/netWork/api_client.dart';
import 'package:ecommerce_app_huma_volve/features/home/services/model/category_model.dart';
import 'package:ecommerce_app_huma_volve/features/home/services/model/product_model.dart';

class HomeServices {
  ApiClient apiClient;
  HomeServices({required this.apiClient});

  Future<List<CategoryModel>> getCategories() async {
    final response = await apiClient.dio.get(ApiEndPoints.categories);
    List data = response.data;
    List<CategoryModel> categories = data
        .map((e) => CategoryModel.fromJson(e))
        .toList();
    categories.insert(0, CategoryModel(id: -1, name: 'All'));
    return categories;
  }

  Future<List<ProductModel>> getProducts(int categoryId) async {
    List data;
    final Response<dynamic> response;
    if (categoryId == -1) {
      response = await apiClient.dio.get(ApiEndPoints.products);
      data = response.data;
    } else {
      response = await apiClient.dio.get(
        "${ApiEndPoints.categories}/$categoryId/${ApiEndPoints.products}",
      );
    }
    data = response.data;
    List<ProductModel> products = data
        .map((e) => ProductModel.fromJson(e))
        .toList();
    return products;
  }
}
