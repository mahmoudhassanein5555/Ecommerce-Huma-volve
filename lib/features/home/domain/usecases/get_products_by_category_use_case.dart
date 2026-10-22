import '../entities/product_entity.dart';
import '../repositories/home_repository.dart';

class GetProductsByCategoryUseCase {
  const GetProductsByCategoryUseCase(this._repository);

  final HomeRepository _repository;

  Future<List<ProductEntity>> call({
    required int categoryId,
    int limit = 30,
    int offset = 0,
  }) {
    return _repository.getProductsByCategory(
      categoryId: categoryId,
      limit: limit,
      offset: offset,
    );
  }
}
