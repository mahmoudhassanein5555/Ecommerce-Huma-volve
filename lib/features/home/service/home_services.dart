import '../../../core/Network/api_manager.dart';
import '../../../core/constants/api_endpoints.dart';
import '../models/category_model.dart';
import '../models/products_model.dart';

class HomeServices {
  final ApiManager apiManager;
  HomeServices(this.apiManager);

  Future<List<CategoryModel>> getCategories() async {
    final response = await apiManager.dio.get(ApiEndpoints.categoriesEndPoint);
    final List<dynamic> jsonData = response.data;
    final List<CategoryModel> categories =
        jsonData.map((e) => CategoryModel.fromJson(e)).toList();
    return categories;
  }

  Future<List<ProductsModel>> getProducts(num? categoryId) async {
    final response = await apiManager.dio.get(
      "${ApiEndpoints.categoriesEndPoint}/$categoryId/${ApiEndpoints.productsEndPoint}",
    );
    final List<dynamic> jsonData = response.data;
    final List<ProductsModel> products =
        jsonData.map((e) => ProductsModel.fromJson(e)).toList();
    return products;
  }
}
