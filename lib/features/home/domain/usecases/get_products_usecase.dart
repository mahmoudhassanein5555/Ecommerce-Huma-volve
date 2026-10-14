import '../repositories/products_repository.dart';

class GetProductsUseCase {
  GetProductsUseCase(this._repository);

  final ProductsRepository _repository;

  Future<List<dynamic>> call() {
    return _repository.getProducts();
  }
}
