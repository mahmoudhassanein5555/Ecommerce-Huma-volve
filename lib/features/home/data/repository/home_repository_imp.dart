import '../../domain/entities/home_category_entity.dart';
import '../../domain/entities/home_product_entity.dart';
import '../../domain/repository/home_repository.dart';
import '../data/home_remote_data_source.dart';

class HomeRepositoryImp implements HomeRepository {
  final HomeRemoteDataSource homeRemoteDataSource;
  HomeRepositoryImp(this.homeRemoteDataSource);

  @override
  Future<List<HomeCategoryEntity>> getCategories() async {
    try {
      final categories = await homeRemoteDataSource.getCategories();
      return categories;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<HomeProductEntity>> getProducts(
    num? categoryId, {
    required int? limit,
    required int? offset,
  }) async {
    try {
      final products = await homeRemoteDataSource.getProducts(
        categoryId,
        limit: limit,
        offset: offset,
      );
      return products;
    } catch (e) {
      rethrow;
    }
  }
}
