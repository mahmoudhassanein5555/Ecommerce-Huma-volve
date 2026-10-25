import '../entities/home_product_entity.dart';
import '../repository/home_repository.dart';

class GetProductsUseCase {
  final HomeRepository homeRepository;
  GetProductsUseCase(this.homeRepository);

  Future<List<HomeProductEntity>> invoke(
    num? categoryId, {
    required int? limit,
    required int? offset,
  }) => homeRepository.getProducts(categoryId, limit: limit, offset: offset);

  late final products = homeRepository.getProducts;
}
