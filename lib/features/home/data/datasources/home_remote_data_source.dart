import 'package:ecommerce_app_huma_volve/features/home/data/models/category_model.dart';
import 'package:ecommerce_app_huma_volve/features/home/data/models/home_service.dart';
import 'package:ecommerce_app_huma_volve/features/home/data/models/product_model.dart';

class HomeRemoteDataSource {
  final HomeService homeService;

  HomeRemoteDataSource(this.homeService);

  Future<List<CategoryModel>> getCategories() async {
    final categories = await homeService.getCategories();
    return categories;
  }

  Future<List<ProductModel>> getProducts({
    int? categoryId,
    required int limit,
    required int offset,
  }) async {
    final products = await homeService.getCategoryById(
      id: categoryId,
      limit: limit,
      offset: offset,
    );
    return products;
  }
}
