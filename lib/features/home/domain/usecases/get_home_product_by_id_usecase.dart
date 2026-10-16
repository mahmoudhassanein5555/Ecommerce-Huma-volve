
import '../entities/home_product_entity.dart';
import '../repositories/home_repository.dart';

class GetHomeProductByIdUseCase {
  final HomeRepository repository;

  GetHomeProductByIdUseCase(this.repository);

  Future<HomeProductEntity> call({
    required int productId,
  }) {
    return repository.getProductById(
      productId: productId,
    );
  }
}
