import '../../../../core/domain/entities/product.dart';
import '../entities/home_category.dart';

abstract interface class HomeRepository {
  Future<List<Product>> fetchProducts({int? categoryId, String? title});

  Future<List<HomeCategory>> fetchCategories();
}
