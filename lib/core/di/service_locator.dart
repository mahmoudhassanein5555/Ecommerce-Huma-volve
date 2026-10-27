import 'package:get_it/get_it.dart';

import '../network/api_client.dart';
import '../../features/auth/data/datasources/auth_remote_data_source.dart';
import '../../features/auth/data/repos/auth_repo_impl.dart';
import '../../features/auth/data/services/login_service.dart';
import '../../features/auth/data/services/sign_up_service.dart';
import '../../features/auth/domain/repos/auth_repo.dart';
import '../../features/auth/domain/usecases/login_use_case.dart';
import '../../features/auth/domain/usecases/sign_up_use_case.dart';
import '../../features/auth/presentation/cubit/auth_cubit.dart';
import '../../features/home/data/datasources/home_remote_data_source.dart';
import '../../features/home/data/models/home_service.dart';
import '../../features/home/data/repos/home_repo_impl.dart';
import '../../features/home/domain/repos/home_repo.dart';
import '../../features/home/domain/usecases/home_category_use_case.dart';
import '../../features/home/domain/usecases/home_products_use_case.dart';
import '../../features/home/presentation/cubit/home_cubit.dart';
import '../../features/details/data/datasources/product_details_remote_data_source.dart';
import '../../features/details/data/repos/product_details_repo_impl.dart';
import '../../features/details/domain/repos/product_details_repo.dart';
import '../../features/details/domain/usecases/get_product_details_use_case.dart';
import '../../features/details/presentation/cubit/product_details_cubit.dart';

final GetIt getIt = GetIt.instance;

Future<void> setupServiceLocator() async {
  if (getIt.isRegistered<ApiClient>()) return;

  getIt.registerLazySingleton<ApiClient>(ApiClient.new);

  getIt.registerLazySingleton(() => LoginService(getIt<ApiClient>()));
  getIt.registerLazySingleton(() => SignUpService(getIt<ApiClient>()));
  getIt.registerLazySingleton(() => HomeService(getIt<ApiClient>()));

  getIt.registerLazySingleton(
    () => AuthRemoteDataSource(
      loginService: getIt<LoginService>(),
      signUpService: getIt<SignUpService>(),
    ),
  );
  getIt.registerLazySingleton(() => HomeRemoteDataSource(getIt<HomeService>()));
  getIt.registerLazySingleton(
    () => ProductDetailsRemoteDataSource(getIt<ApiClient>()),
  );

  getIt.registerLazySingleton<AuthRepo>(
    () => AuthRepoImpl(getIt<AuthRemoteDataSource>()),
  );
  getIt.registerLazySingleton<HomeRepo>(
    () => HomeRepoImpl(getIt<HomeRemoteDataSource>()),
  );
  getIt.registerLazySingleton<ProductDetailsRepo>(
    () => ProductDetailsRepoImpl(getIt<ProductDetailsRemoteDataSource>()),
  );

  getIt.registerLazySingleton(() => LoginUseCase(getIt<AuthRepo>()));
  getIt.registerLazySingleton(() => SignUpUseCase(getIt<AuthRepo>()));
  getIt.registerFactory(() => HomeProductsUseCase(getIt()));
  getIt.registerLazySingleton(
    () => HomeCategoryUseCase(getIt(), getIt<HomeProductsUseCase>()),
  );
  getIt.registerLazySingleton(
    () => GetProductDetailsUseCase(getIt<ProductDetailsRepo>()),
  );

  getIt.registerFactory(
    () => AuthCubit(
      loginUseCase: getIt<LoginUseCase>(),
      signUpUseCase: getIt<SignUpUseCase>(),
    ),
  );
  getIt.registerFactory(
    () => HomeCubit(
      homeCategoryUseCase: getIt<HomeCategoryUseCase>(),
      homeProductsUseCase: getIt<HomeProductsUseCase>(),
    ),
  );
  getIt.registerFactory(
    () => ProductDetailsCubit(getIt<GetProductDetailsUseCase>()),
  );
}
