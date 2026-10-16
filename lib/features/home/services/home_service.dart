
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
        .map((item) => CategoryModel.fromJson(
              Map<String, dynamic>.from(item),
            ))
        .toList();
  }

  Future<List<ProductModel>> getProducts(int categoryId) async {
    final response = await dio.get(
      ApiEndpoints.products,
      queryParameters: {'categoryId': categoryId},
    );

    final List<dynamic> data = response.data;

    return data
        .map((item) => ProductModel.fromJson(
              Map<String, dynamic>.from(item),
            ))
        .toList();
  }
}

