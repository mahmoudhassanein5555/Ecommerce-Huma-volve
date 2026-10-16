
import '../../models/product_model.dart';
import '../../services/home_service.dart';
import '../../domain/entities/category_entity.dart';
import '../../domain/entities/product_entity.dart';
import '../../domain/repositories/home_repository.dart';

class HomeRepositoryImpl implements HomeRepository {
  final HomeService homeService;

  HomeRepositoryImpl({
    required this.homeService,
  });

  @override
  Future<List<CategoryEntity>> getCategories() async {
    final categories = await homeService.getCategories();

    return categories
        .map(
          (category) => CategoryEntity(
            id: category.id,
            name: category.name,
          ),
        )
        .toList();
  }

  @override
  Future<List<ProductEntity>> getProducts(
    int categoryId, {
    int offset = 0,
    int limit = 10,
  }) async {
    final List<ProductModel> products =
        await homeService.getProducts(
      categoryId,
      offset: offset,
      limit: limit,
    );

    return products
        .map(
          (product) => ProductEntity(
            id: product.id,
            title: product.title,
            price: product.price,
            images: product.images,
          ),
        )
        .toList();
  }
}
