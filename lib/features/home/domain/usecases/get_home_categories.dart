import '../entities/home_category.dart';
import '../repositories/home_repository.dart';

class GetHomeCategories {
  const GetHomeCategories(this._repository);

  final HomeRepository _repository;

  Future<List<HomeCategory>> call() => _repository.fetchCategories();
}
