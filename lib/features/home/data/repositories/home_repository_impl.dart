import '../../../../core/domain/entities/product.dart';
import '../../domain/entities/home_category.dart';
import '../../domain/repositories/home_repository.dart';
import '../datasources/home_remote_data_source.dart';
import '../models/home_category_model.dart';
import '../models/product_model.dart';

class HomeRepositoryImpl implements HomeRepository {
  HomeRepositoryImpl(this._remoteDataSource);

  final HomeRemoteDataSource _remoteDataSource;

  @override
  Future<List<Product>> fetchProducts({int? categoryId, String? title}) async {
    final response = await _remoteDataSource.fetchProducts(
      categoryId: categoryId,
      title: title,
    );
    return response.map((item) {
      if (item is! Map<String, dynamic>) {
        throw const FormatException('Invalid product response from store.');
      }
      return ProductModel.fromJson(item);
    }).toList();
  }

  @override
  Future<List<HomeCategory>> fetchCategories() async {
    final response = await _remoteDataSource.fetchCategories();
    return response.map((item) {
      if (item is! Map<String, dynamic>) {
        throw const FormatException('Invalid category response from store.');
      }
      return HomeCategoryModel.fromJson(item);
    }).toList();
  }
}
