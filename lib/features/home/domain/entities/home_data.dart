import 'category.dart';
import 'product.dart';

class HomeData {
  const HomeData({required this.products, required this.categories});

  final List<Product> products;
  final List<Category> categories;
}
