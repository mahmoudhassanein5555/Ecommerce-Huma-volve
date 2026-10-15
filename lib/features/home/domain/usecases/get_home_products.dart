import '../../../../core/domain/entities/product.dart';
import '../repositories/home_repository.dart';

class GetHomeProducts {
  const GetHomeProducts(this._repository);

  final HomeRepository _repository;

  Future<List<Product>> call({int? categoryId, String? title}) {
    return _repository.fetchProducts(categoryId: categoryId, title: title);
  }
}
