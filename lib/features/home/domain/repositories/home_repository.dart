import '../entities/home_data.dart';
import '../entities/product.dart';

abstract interface class HomeRepository {
  Future<HomeData> fetchHomeData({
    required int limit,
    required int offset,
    String? categoryId,
  });

  Future<List<Product>> fetchProducts({
    required int limit,
    required int offset,
    String? categoryId,
  });
}
