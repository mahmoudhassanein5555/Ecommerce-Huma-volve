import '../models/category_model.dart';
import '../models/product_model.dart';

abstract class HomeRemoteDataSource {
Future<List<CategoryModel>> getCategories();
Future<List<ProductModel>> getProducts(int? categoryId);
}