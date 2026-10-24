import 'package:ecommerce_app_huma_volve/core/network/api_manager.dart';
import 'package:ecommerce_app_huma_volve/features/home/data/models/category_response_model.dart';
import 'package:ecommerce_app_huma_volve/features/home/data/models/products_response_model.dart';

import '../../../../core/constants/api_endpoints.dart';
import 'home_remote_data_source.dart';

class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  final ApiManager apiManager;

  HomeRemoteDataSourceImpl(this.apiManager);

  @override
  Future<List<CategoryResponseModel>> getCategoryList() async {
    final catResponse = await apiManager.dio.get(ApiEndPoints.categoryEndpoint);

    // from json

    final List listData = catResponse.data;

    // to dart

    final List<CategoryResponseModel> categoriesList = listData
        .map((e) => CategoryResponseModel.fromJson(e))
        .toList();
    return categoriesList;
  }

  @override
  Future<List<ProductsResponseModel>> getProductByCategoryId(
    int? categoryId,
  ) async {
    final productResponse = await apiManager.dio.get(
      "${ApiEndPoints.categoryEndpoint}/$categoryId/${ApiEndPoints.productsEndpoint}",
    );

    // from json
    final List jsonData = productResponse.data;
    final List<ProductsResponseModel> productList = jsonData
        .map((e) => ProductsResponseModel.fromJson(e))
        .toList();
    return productList;
  }
}
