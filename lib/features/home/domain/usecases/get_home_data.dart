import '../entities/home_data.dart';
import '../repositories/home_repository.dart';

class GetHomeData {
  const GetHomeData(this._repository);

  final HomeRepository _repository;

  Future<HomeData> call() => _repository.fetchHomeData();
}
