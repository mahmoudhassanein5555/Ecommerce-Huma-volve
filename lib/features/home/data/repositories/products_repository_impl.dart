import '../../../../core/services/api_service.dart';
import '../../domain/repositories/products_repository.dart';

class ProductsRepositoryImpl implements ProductsRepository {
  ProductsRepositoryImpl(this._apiService);

  final ApiService _apiService;

  @override
  Future<List<dynamic>> getProducts() {
    return _apiService.getProducts();
  }
}
