import 'package:dio/dio.dart';
import 'package:ecommerce_app_huma_volve/core/constants/api_endpoints.dart';
import 'package:ecommerce_app_huma_volve/core/network/api_client.dart';
import 'package:ecommerce_app_huma_volve/features/home/models/category_model.dart';
import 'package:ecommerce_app_huma_volve/features/home/models/product_model.dart';

class HomeService {
  static Future<List<CategoryModel>> getCategories() async {
    try {
      final response = await ApiClient.instance.get(ApiEndpoints.categories);
      List jsonData = response.data;
      List<CategoryModel> categoriesData = jsonData
          .map((category) => CategoryModel.fromJson(category))
          .toList();
      return categoriesData;
    } on DioException catch (e) {
      throw Exception(e.message);
    }
  }

 static  Future<List<ProductModel>> getCategoryById({int? id}) async {
    final response = await ApiClient.instance.get(
      '${ApiEndpoints.categories}/$id/${ApiEndpoints.products}',
    );
    final List jsonData = response.data;
    List<ProductModel> products = jsonData
        .map((product) => ProductModel.fromJson(product))
        .toList();
    return products;
  }
}
