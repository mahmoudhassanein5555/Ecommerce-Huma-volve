import 'package:dio/dio.dart';
import 'package:ecommerce_app_huma_volve/core/network/api_client.dart';
import 'package:ecommerce_app_huma_volve/features/auth/data/datasources/login_datasource.dart';
import 'package:ecommerce_app_huma_volve/features/auth/data/datasources/login_datasource_imp.dart';
import 'package:ecommerce_app_huma_volve/features/auth/data/datasources/signup_datasource.dart';
import 'package:ecommerce_app_huma_volve/features/auth/data/datasources/signup_datasource_imp.dart';
import 'package:ecommerce_app_huma_volve/features/auth/data/repositories/login_repo_imp.dart';
import 'package:ecommerce_app_huma_volve/features/auth/data/repositories/signup_repo_imp.dart';
import 'package:ecommerce_app_huma_volve/features/auth/domain/repositories/login_repo.dart';
import 'package:ecommerce_app_huma_volve/features/auth/domain/repositories/signup_repo.dart';
import 'package:ecommerce_app_huma_volve/features/auth/domain/use_cases/login_usecase.dart';
import 'package:ecommerce_app_huma_volve/features/auth/domain/use_cases/signup_usecase.dart';
import 'package:ecommerce_app_huma_volve/features/auth/presentation/view_model/cubit/login_cubit.dart';
import 'package:ecommerce_app_huma_volve/features/auth/presentation/view_model/cubit/signup_cubit.dart';
import 'package:ecommerce_app_huma_volve/features/home/data/data_source/home_remote_datasource.dart';
import 'package:ecommerce_app_huma_volve/features/home/data/data_source/home_remote_datasource_imp.dart';
import 'package:ecommerce_app_huma_volve/features/home/data/repositories/home_repository_imp.dart';
import 'package:ecommerce_app_huma_volve/features/home/domain/repositories/home_repository.dart';
import 'package:ecommerce_app_huma_volve/features/home/domain/use_cases/home_category_usecase.dart';
import 'package:ecommerce_app_huma_volve/features/home/domain/use_cases/home_product_usecase.dart';
import 'package:ecommerce_app_huma_volve/features/home/presentation/view_model/cubit/home_cubit.dart';
import 'package:ecommerce_app_huma_volve/features/main_navigation/screens/main_navigation_screen.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;
Future<void> setupGetIt() async {
  // Dio
  getIt.registerLazySingleton<Dio>(() => Dio());

  getIt.registerLazySingleton<ApiClient>(() => ApiClient());

  // login
  getIt.registerLazySingleton<LoginDatasource>(
    () => LoginDatasourceImp(getIt()),
  );
  getIt.registerLazySingleton<LoginRepo>(() => LoginRepoImp(getIt()));
  getIt.registerLazySingleton<LoginUsecase>(() => LoginUsecase(getIt()));
  getIt.registerFactory<LoginCubit>(() => LoginCubit(getIt()));

  // signup
  getIt.registerLazySingleton<SignupDatasource>(
    () => SignupDatasourceImp(getIt()),
  );
  getIt.registerLazySingleton<SignupRepo>(() => SignupRepoImp(getIt()));
  getIt.registerLazySingleton<SignupUsecase>(() => SignupUsecase(getIt()));
  getIt.registerFactory<SignupCubit>(() => SignupCubit(getIt()));

  // main navigation
  getIt.registerLazySingleton<MainNavigationScreen>(
    () => MainNavigationScreen(),
  );

  //home
  getIt.registerLazySingleton<HomeRemoteDatasource>(
    () => HomeRemoteDatasourceImp(getIt()),
  );
  getIt.registerLazySingleton<HomeRepository>(() => HomeRepositoryImp(getIt()));
  getIt.registerLazySingleton<HomeCategoryUsecase>(
    () => HomeCategoryUsecase(getIt()),
  );
  getIt.registerLazySingleton<HomeProductUsecase>(
    () => HomeProductUsecase(getIt()),
  );
  getIt.registerFactory<HomeCubit>(() => HomeCubit(getIt(), getIt()));
}
