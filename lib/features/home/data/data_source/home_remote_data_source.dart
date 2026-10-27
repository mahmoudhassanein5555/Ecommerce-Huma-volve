
import 'package:ecommerce_app_huma_volve/features/home/data/service/models/category_model%20.dart';
import 'package:ecommerce_app_huma_volve/features/home/data/service/models/prodduct_model.dart';

abstract class HomeRemoteDataSource {
  Future<List<ProductModel>> getproducts(int? categoryid);
   Future< List<CategoryModel>> getCategories();


}