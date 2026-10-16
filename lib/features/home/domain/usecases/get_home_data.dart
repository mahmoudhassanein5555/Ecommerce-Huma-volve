import '../entities/home_data.dart';
import '../entities/product.dart';
import '../repositories/home_repository.dart';

class GetHomeData {
  const GetHomeData(this._repository);

  final HomeRepository _repository;

  Future<HomeData> call({int limit = 20, int offset = 0, String? categoryId}) =>
      _repository.fetchHomeData(
        limit: limit,
        offset: offset,
        categoryId: categoryId,
      );

  Future<List<Product>> fetchProducts({
    required int limit,
    required int offset,
    String? categoryId,
  }) => _repository.fetchProducts(
    limit: limit,
    offset: offset,
    categoryId: categoryId,
  );
}
