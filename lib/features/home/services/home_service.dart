
import 'package:dio/dio.dart';
import 'package:ecommerce_app_huma_volve/core/constants/api_endpoints.dart';

import '../models/category_model.dart';
import '../models/product_model.dart';

class HomeService {
  final Dio dio;

  HomeService({Dio? dio}) : dio = dio ?? Dio();

  Future<List<CategoryModel>> getCategories() async {
    final response = await dio.get(ApiEndpoints.categories);

    final List<dynamic> data = response.data;

    return data
        .map(
          (item) => CategoryModel.fromJson(
            Map<String, dynamic>.from(item),
          ),
        )
        .toList();
  }

  Future<List<ProductModel>> getProducts(
    int categoryId, {
    int offset = 0,
    int limit = 10,
  }) async {
    final response = await dio.get(
      ApiEndpoints.products,
      queryParameters: {
        'categoryId': categoryId,
        'offset': offset,
        'limit': limit,
      },
    );

    final List<dynamic> data = response.data;

    return data
        .map(
          (item) => ProductModel.fromJson(
            Map<String, dynamic>.from(item),
          ),
        )
        .toList();
  }
  Future<ProductModel> getProductById(int id) async {
    final response = await dio.get(
      ApiEndpoints.productDetails(id),
    );

    return ProductModel.fromJson(
      Map<String, dynamic>.from(response.data),
    );
  }
}
