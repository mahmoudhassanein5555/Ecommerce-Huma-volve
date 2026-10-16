// import 'dart:math';
//
// import 'package:ecommerce_app_huma_volve/core/constants/api_endpoints.dart';
// import 'package:ecommerce_app_huma_volve/core/network/api_client.dart';
//
// import '../data/models/categoriesModels.dart';
// import '../data/models/productsModels.dart';
//
//
// class HomeServices {
//  final ApiClient apiClient;
//   HomeServices(this.apiClient);
//    Future <List<categoriesModels>> getCategories()async{
// final response= await apiClient.dio.get(ApiEndpoints.categoriesEndpoints);
// final List jsonData=response.data;
// final List<categoriesModels> dartData=jsonData.map((e)=>categoriesModels.fromJson(e)).toList();
// return dartData;
//   }
//
//   Future <List<productsModels>> getProducts(int? categoryId)async{
//     final response= await apiClient.dio.get
//       ("${ApiEndpoints.categoriesEndpoints}/${ApiEndpoints.productsEndpoints}");
//     final List jsonData=response.data;
//     final List<productsModels> products=jsonData.map((e)=>productsModels.fromJson(e)).toList();
//     return products;
//
//   }
// }