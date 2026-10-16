
import '../entities/home_product_entity.dart';
import '../repositories/home_repository.dart';

class GetHomeProductsUseCase {
  final HomeRepository repository;

  GetHomeProductsUseCase(this.repository);

  Future<List<HomeProductEntity>> call({
    required int categoryId,
    required int limit,
    required int offset,
  }) {
    return repository.getProducts(
      categoryId: categoryId,
      limit: limit,
      offset: offset,
    );
  }
}
