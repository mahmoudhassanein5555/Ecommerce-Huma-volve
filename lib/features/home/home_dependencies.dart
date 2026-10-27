import '../../core/network/api_client.dart';
import 'api/home_api_service.dart';
import 'data/datasources/home_remote_data_source.dart';
import 'data/repositories/home_repository_impl.dart';
import 'domain/usecases/get_products_by_category_use_case.dart';
import 'domain/usecases/get_products_use_case.dart';
import 'presentation/cubit/home_cubit.dart';

class HomeDependencies {
  HomeDependencies._();

  static HomeCubit buildHomeCubit() {
    final apiService = HomeApiService(ApiClient());
    final remoteDataSource = HomeRemoteDataSourceImpl(apiService);
    final repository = HomeRepositoryImpl(remoteDataSource);
    return HomeCubit(
      getProductsUseCase: GetProductsUseCase(repository),
      getProductsByCategoryUseCase: GetProductsByCategoryUseCase(repository),
    );
  }
}
