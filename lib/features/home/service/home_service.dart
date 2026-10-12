import 'package:ecommerce_app_huma_volve/core/constants/api_endpoints.dart';
import 'package:ecommerce_app_huma_volve/core/network/api_client.dart';
import 'package:ecommerce_app_huma_volve/features/home/service/models/category_model.dart';
import 'package:ecommerce_app_huma_volve/features/home/service/models/product_model.dart';

class HomeService{
  ApiClient apiClient;
  HomeService(this.apiClient);
  Future<List<CategoryModel>>getCategories()async{
    final response=await apiClient.dio.get(ApiEndpoints.categoriesEndpoint);
    final List jsonData=response.data;
    final List<CategoryModel> categories=jsonData.map((e)=>CategoryModel.fromJson(e)).toList();
    return categories;
  }
  Future<List<ProductModel>> getProducts([int? categoryId]) async {
    final String endpoint = (categoryId != null && categoryId > 0)
        ? "${ApiEndpoints.categoriesEndpoint}/$categoryId/${ApiEndpoints.productsEndpoint}"
        : ApiEndpoints.productsEndpoint;
    final response = await apiClient.dio.get(endpoint);
    final List jsonData = response.data;
    final List<ProductModel> products =
        jsonData.map((e) => ProductModel.fromJson(e)).toList();
    return products;
  }
}