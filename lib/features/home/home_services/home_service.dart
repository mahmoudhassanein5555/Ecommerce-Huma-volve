import 'package:ecommerce_app_huma_volve/core/constants/api_endpoints.dart';

import '../../../core/network/api_manager.dart';
import 'models/category_model.dart';
import 'models/product_model.dart';

class HomeService {
  ApiManager apiManager;
  HomeService(this.apiManager);

  Future<List<CategoryModel>> getCategories() async {
    final response = await ApiManager().dio.get(
      ApiEndpoints.categoriesEndpoint,
    );
    final List jsonData = response.data;
    final List<CategoryModel> dartData = jsonData
        .map((e) => CategoryModel.fromJson(e))
        .toList();
    return dartData;
  }

  Future<List<ProductModel>> getProducts(int? categoryId) async {
    final response = await ApiManager().dio.get(
      "${ApiEndpoints.categoriesEndpoint}/$categoryId/${ApiEndpoints.productsEndpoint}",
    );
    final List jsonData = response.data;
    final List<ProductModel> dartData = jsonData
        .map((e) => ProductModel.fromJson(e))
        .toList();
    return dartData;
  }
}
