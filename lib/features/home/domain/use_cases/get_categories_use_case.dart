import '../entities/home_category_entity.dart';
import '../repository/home_repository.dart';

class GetCategoriesUseCase {
  final HomeRepository homeRepository;
  GetCategoriesUseCase(this.homeRepository);

  Future<List<HomeCategoryEntity>> invoke() async {
    try {
      final categories = await homeRepository.getCategories();
      return categories;
    } catch (e) {
      rethrow;
    }
  }
}
