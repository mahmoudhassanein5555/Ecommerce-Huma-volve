import '../../domain/entities/category_entity.dart';
import '../../domain/entities/product_entity.dart';
import '../../domain/repositories/home_repository.dart';
import '../../models/category_model.dart';
import '../../models/product_model.dart';
import '../../services/home_service.dart';

class HomeRepositoryImpl implements HomeRepository {
  final HomeService homeService;

  HomeRepositoryImpl({required this.homeService});

  @override
  Future<List<CategoryEntity>> getCategories() async {
    final List<CategoryModel> categories =
        await homeService.getCategories();

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
  Future<List<ProductEntity>> getProducts(int categoryId) async {
    final List<ProductModel> products =
        await homeService.getProducts(categoryId);

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
