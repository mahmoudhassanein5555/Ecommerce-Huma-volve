
import 'package:ecommerce_app_huma_volve/core/Network/api_clint.dart';
import 'package:ecommerce_app_huma_volve/core/constants/api_endpoints.dart';
import 'package:ecommerce_app_huma_volve/features/home/data/service/models/category_model%20.dart';
import 'package:ecommerce_app_huma_volve/features/home/data/service/models/prodduct_model.dart';

class HomeService {
  final Apiclient apiclient;
  HomeService(this.apiclient);

 Future< List<CategoryModel>> getCategares() async {
 final response = await apiclient.dio.get(ApiEndpoints.categoriesEndpoint);
 final List jsonData = response.data;
 final List<CategoryModel> Categories= jsonData.map((e)=>CategoryModel.fromJson(e)).toList();

 return Categories;

}
Future<List<ProductModel>> getproducts(int? categoryid)async{
final Response = await apiclient.dio.get("${ApiEndpoints.categoriesEndpoint}/$categoryid/${ApiEndpoints.productsEndpoint}");
final List jsonData = Response.data;
final List<ProductModel> product = jsonData.map((e)=>ProductModel.fromJson(e)).toList();
return product;
}
}