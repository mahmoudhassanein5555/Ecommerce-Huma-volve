import '../entities/home_category_entity.dart';
import '../repositories/home_repository.dart';

class GetHomeCategoriesUseCase {
  final HomeRepository repository;

  GetHomeCategoriesUseCase(this.repository);

  Future<List<HomeCategoryEntity>> call() {
    return repository.getCategories();
  }
}