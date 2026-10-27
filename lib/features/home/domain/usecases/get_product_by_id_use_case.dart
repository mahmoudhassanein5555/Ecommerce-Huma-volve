import '../entities/product_entity.dart';
import '../repositories/home_repository.dart';

class GetProductByIdUseCase {
  const GetProductByIdUseCase(this._repository);

  final HomeRepository _repository;

  Future<ProductEntity> call(int productId) =>
      _repository.getProductById(productId);
}
