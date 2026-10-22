import '../entities/product_entity.dart';
import '../repositories/home_repository.dart';

class GetProductsUseCase {
  const GetProductsUseCase(this._repository);

  final HomeRepository _repository;

  Future<List<ProductEntity>> call({int limit = 30, int offset = 0}) {
    return _repository.getProducts(limit: limit, offset: offset);
  }
}
