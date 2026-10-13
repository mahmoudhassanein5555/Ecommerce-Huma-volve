import '../entities/product_entity.dart';
import '../repositories/home_repository.dart';

class GetProductsUseCase {
  final HomeRepository repository;

  GetProductsUseCase(this.repository);

  Future<List<ProductEntity>> call(int categoryId) {
    return repository.getProducts(categoryId);
  }
}
