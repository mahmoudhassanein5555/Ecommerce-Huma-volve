
import '../entities/product_entity.dart';
import '../repositories/home_repository.dart';

class GetProductByIdUseCase {
  final HomeRepository repository;

  GetProductByIdUseCase(this.repository);

  Future<ProductEntity> call(int id) {
    return repository.getProductById(id);
  }
}
