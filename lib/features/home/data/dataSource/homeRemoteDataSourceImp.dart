import 'package:ecommerce_app_huma_volve/core/network/api_client.dart';
import 'package:ecommerce_app_huma_volve/features/home/data/dataSource/homeRemoteDataSource.dart';
import 'package:ecommerce_app_huma_volve/features/home/data/models/categoriesModels.dart';
import 'package:ecommerce_app_huma_volve/features/home/data/models/productsModels.dart';

import '../../../../core/constants/api_endpoints.dart';

 class homeRemoteDataSourceImpl implements homeRemoteDataSource{
   final ApiClient apiClient;
   homeRemoteDataSourceImpl(this.apiClient);
  @override
  Future<List<categoriesModels>> getCategories()async {
    final response= await apiClient.dio.get(ApiEndpoints.categoriesEndpoints);
    final List jsonData=response.data;
    final List<categoriesModels> dartData=jsonData.map((e)=>categoriesModels.fromJson(e)).toList();
    return dartData;

  }

  @override
  Future<List<productsModels>>  getProducts(int? categoryId, {required int limit,required int offset}) async {
    final response= await apiClient.dio.get
      ("${ApiEndpoints.categoriesEndpoints}/$categoryId/${ApiEndpoints.productsEndpoints}",
    queryParameters: {
        "limit":limit,
        "offset":offset
        },
    );
    final List jsonData=response.data;
    final List<productsModels> products=jsonData.map((e)=>productsModels.fromJson(e)).toList();
    return products;

  }

}