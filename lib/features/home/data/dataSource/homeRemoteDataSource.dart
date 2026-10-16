import '../models/categoriesModels.dart';
import '../models/productsModels.dart';

abstract class homeRemoteDataSource{
  Future <List<categoriesModels>> getCategories();
  Future <List<productsModels>> getProducts(int? categoryId, {required int limit,required int offset});
}