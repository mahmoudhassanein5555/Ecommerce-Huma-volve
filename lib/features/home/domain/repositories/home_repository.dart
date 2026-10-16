import '../entities/product_entity.dart';

abstract class HomeRepository {
  Future<List<ProductEntity>> getProducts({
    required int offset,
    required int limit,
  });
}