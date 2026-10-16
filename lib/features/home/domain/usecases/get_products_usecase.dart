import '../entities/product_entity.dart';
import '../repositories/home_repository.dart';

class GetProductsUseCase {
  final HomeRepository repository;

  GetProductsUseCase(this.repository);

  Future<List<ProductEntity>> call(
    int categoryId, {
    int offset = 0,
    int limit = 10,
  }) {
    return repository.getProducts(
      categoryId,
      offset: offset,
      limit: limit,
    );
  }
}