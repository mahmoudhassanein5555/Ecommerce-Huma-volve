import '../../../../core/Network/api_manager.dart';
import '../../../../core/constants/api_endpoints.dart';
import '../../models/category_model.dart';
import '../../models/products_model.dart';
import 'home_remote_data_source.dart';

class HomeRemoteDataSourceImp implements HomeRemoteDataSource {
  final ApiManager apiManager;
  HomeRemoteDataSourceImp(this.apiManager);

  @override
  Future<List<HomeCategoryModel>> getCategories() async {
    final response = await apiManager.dio.get(ApiEndpoints.categoriesEndPoint);
    final List<dynamic> jsonData = response.data;
    final List<HomeCategoryModel> categories =
        jsonData.map((e) => HomeCategoryModel.fromJson(e)).toList();
    return categories;
  }

  @override
  Future<List<HomeProductsModel>> getProducts(num? categoryId) async {
    final response = await apiManager.dio.get(
      "${ApiEndpoints.categoriesEndPoint}/$categoryId/${ApiEndpoints.productsEndPoint}",
    );
    final List<dynamic> jsonData = response.data;
    final List<HomeProductsModel> products =
        jsonData.map((e) => HomeProductsModel.fromJson(e)).toList();
    return products;
  }
}
