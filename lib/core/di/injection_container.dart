import 'package:get_it/get_it.dart';

import '../../features/auth/data/datasources/auth_remote_datasource.dart';
import '../../features/auth/data/repository/auth_repository_impl.dart';
import '../../features/auth/domain/repository/auth_repository.dart';
import '../../features/auth/domain/usecases/has_session_usecase.dart';
import '../../features/auth/domain/usecases/sign_in_usecase.dart';
import '../../features/auth/domain/usecases/sign_out_usecase.dart';
import '../../features/auth/domain/usecases/sign_up_usecase.dart';
import '../../features/auth/presentation/viewmodel/auth_cubit.dart';
import '../../features/home/data/datasources/home_remote_datasource.dart';
import '../../features/home/data/repository/home_repository_impl.dart';
import '../../features/home/domain/repository/home_repository.dart';
import '../../features/home/domain/usecases/get_category_usecase.dart';
import '../../features/home/domain/usecases/get_product_usecase.dart';
import '../../features/home/presentation/viewmodel/cubit/home_cubit.dart';
import '../network/api_client.dart';
import '../storage/token_storage.dart';

final sl = GetIt.instance;

void setupLocator() {
  // Auth Feature

  //-- Cubit
  sl.registerFactory(
    () => AuthCubit(
      hasSessionUsecase: sl(),
      signInUsecase: sl(),
      signUpUsecase: sl(),
      signOutUsecase: sl(),
    ),
  );

  //-- UseCases

  sl.registerLazySingleton(() => HasSessionUsecase(authRepository: sl()));
  sl.registerLazySingleton(() => SignInUsecase(authRepository: sl()));
  sl.registerLazySingleton(() => SignUpUsecase(authRepository: sl()));
  sl.registerLazySingleton(() => SignOutUsecase(authRepository: sl()));

  // Repository

  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(remote: sl(), tokenStorage: sl()),
  );

  // Data Sources
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(apiClient: sl()),
  );

  // Home Feature

  //-- Cubit
  sl.registerFactory(
    () => HomeCubit(getCategoryUsecase: sl(), getProductUsecase: sl()),
  );

  //-- UseCases
  sl.registerLazySingleton(() => GetCategoryUsecase(repository: sl()));
  sl.registerLazySingleton(() => GetProductUsecase(repository: sl()));

  //-- Repository
  sl.registerLazySingleton<HomeRepository>(
    () => HomeRepositoryImpl(remoteDataSource: sl()),
  );

  //-- Data Sources
  sl.registerLazySingleton<HomeRemoteDataSource>(
    () => HomeRemoteDataSourceImpl(apiClient: sl()),
  );

  //____________________________________________________

  //--_ Core Network
  sl.registerLazySingleton(() => ApiClient());

  //--- Core Storage
  sl.registerLazySingleton(() => TokenStorage());
}
