
import '../../domain/entities/home_category_entity.dart';
import '../../domain/entities/home_product_entity.dart';
import '../../domain/repositories/home_repository.dart';
import '../datasources/home_remote_data_source.dart';

class HomeRepositoryImpl implements HomeRepository {
  final HomeRemoteDataSource remoteDataSource;

  HomeRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<HomeCategoryEntity>> getCategories() {
    return remoteDataSource.getCategories();
  }

  @override
  Future<List<HomeProductEntity>> getProducts({
    required int categoryId,
    required int limit,
    required int offset,
  }) {
    return remoteDataSource.getProducts(
      categoryId: categoryId,
      limit: limit,
      offset: offset,
    );
  }
}
