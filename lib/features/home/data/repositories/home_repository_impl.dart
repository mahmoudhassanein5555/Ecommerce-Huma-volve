import '../../domain/entities/product_entity.dart';
import '../../domain/repositories/home_repository.dart';
import '../datasources/home_remote_data_source.dart';

class HomeRepositoryImpl implements HomeRepository {
  final HomeRemoteDataSource remoteDataSource;

  HomeRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<ProductEntity>> getProducts({
    required int offset,
    required int limit,
  }) async {
    final products = await remoteDataSource.getProducts(
      offset: offset,
      limit: limit,
    );

    return products;
  }
}