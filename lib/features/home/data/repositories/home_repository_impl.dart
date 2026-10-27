import '../../domain/entities/product_entity.dart';
import '../../domain/repositories/home_repository.dart';
import '../datasources/home_remote_data_source.dart';

class HomeRepositoryImpl implements HomeRepository {
  const HomeRepositoryImpl(this._remoteDataSource);

  final HomeRemoteDataSource _remoteDataSource;

  @override
  Future<List<ProductEntity>> getProducts({
    required int limit,
    required int offset,
  }) async {
    final models = await _remoteDataSource.getProducts(
      limit: limit,
      offset: offset,
    );
    return models.map((model) => model.toEntity()).toList();
  }

  @override
  Future<List<ProductEntity>> getProductsByCategory({
    required int categoryId,
    required int limit,
    required int offset,
  }) async {
    final models = await _remoteDataSource.getProductsByCategory(
      categoryId: categoryId,
      limit: limit,
      offset: offset,
    );
    return models.map((model) => model.toEntity()).toList();
  }

  @override
  Future<ProductEntity> getProductById(int id) async {
    final model = await _remoteDataSource.getProductById(id);
    return model.toEntity();
  }
}
