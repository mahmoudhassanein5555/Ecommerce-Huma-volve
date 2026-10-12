import 'package:ecommerce_app_huma_volve/core/constant/api_end_point.dart';
import 'package:ecommerce_app_huma_volve/core/network_service/network_services.dart';
import 'package:ecommerce_app_huma_volve/features/home/models/Categories_model.dart';

import '../models/Products_model.dart';

class HomeService {
  NetworkServices networkServices;

  HomeService({required this.networkServices});

  Future<List<CategoriesModel>> getCategories() async {
    final response = await networkServices.dio.get("${ApiEndPoint.categories}");
    final List jsonData = response.data;
    final List<CategoriesModel> categories = jsonData
        .map((e) => CategoriesModel.fromJson(e))
        .toList();
    return categories;
  }

  Future<List<ProductsModel>> getProducts(num? categoryId) async {
    final response = await networkServices.dio.get(
      "${ApiEndPoint.categories}/$categoryId/${ApiEndPoint.products}",
    );
    final List jsonData = response.data;
    final List<ProductsModel> products = jsonData
        .map((e) => ProductsModel.fromJson(e))
        .toList();
    return products;
  }
}
