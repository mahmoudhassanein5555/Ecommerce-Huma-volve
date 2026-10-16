import '../entities/product_entity.dart';
import '../repositories/home_repository.dart';

class GetProductsUseCase {
  final HomeRepository repository;

  GetProductsUseCase(this.repository);

  Future<List<ProductEntity>> call({
    required int offset,
    required int limit,
  }) async {
    return repository.getProducts(
      offset: offset,
      limit: limit,
    );
  }
}