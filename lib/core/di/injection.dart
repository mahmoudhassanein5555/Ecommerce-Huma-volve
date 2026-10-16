import 'package:dio/dio.dart';
import 'package:ecommerce_app_huma_volve/core/networking/api_service.dart';
import 'package:ecommerce_app_huma_volve/core/networking/dio_factory.dart';
import 'package:ecommerce_app_huma_volve/features/auth/data/data_sources/auth_remote_data_source.dart';
import 'package:ecommerce_app_huma_volve/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:ecommerce_app_huma_volve/features/auth/domain/repositories/auth_repository.dart';
import 'package:ecommerce_app_huma_volve/features/auth/domain/use_cases/login_use_case.dart';
import 'package:ecommerce_app_huma_volve/features/auth/domain/use_cases/sign_up_use_case.dart';
import 'package:ecommerce_app_huma_volve/features/auth/login/logic/cubit/login_cubit.dart';
import 'package:ecommerce_app_huma_volve/features/auth/sign_up/logic/cubit/sign_up_cubit.dart';
import 'package:ecommerce_app_huma_volve/features/home/data/data_sources/home_remote_data_source.dart';
import 'package:ecommerce_app_huma_volve/features/home/data/repositories/home_repository_impl.dart';
import 'package:ecommerce_app_huma_volve/features/home/domain/repositories/home_repository.dart';
import 'package:ecommerce_app_huma_volve/features/home/domain/use_cases/get_all_categories.dart';
import 'package:ecommerce_app_huma_volve/features/home/domain/use_cases/get_all_products.dart';
import 'package:ecommerce_app_huma_volve/features/home/domain/use_cases/get_categories_products.dart';
import 'package:ecommerce_app_huma_volve/features/home/logic/all_categories/cubit/all_categories_cubit.dart';
import 'package:ecommerce_app_huma_volve/features/home/logic/all_products/cubit/all_products_cubit.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

Future<void> setupGetIt() async {
  Dio dio = await DioFactory.getDio();
  //Api Service

  getIt.registerLazySingleton<ApiServices>(() => ApiServices(dio));

  // --------------------------- Auth Feature (Clean Architecture) ----------------------------------

  // Data Layer
  getIt.registerLazySingleton<AuthRemoteDataSource>(() => AuthRemoteDataSource(getIt()));
  getIt.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(getIt()));

  // Domain Layer
  getIt.registerFactory<LoginUseCase>(() => LoginUseCase(getIt()));
  getIt.registerFactory<SignUpUseCase>(() => SignUpUseCase(getIt()));

  // Presentation Layer
  getIt.registerFactory<LoginCubit>(() => LoginCubit(getIt()));
  getIt.registerFactory<SignUpCubit>(() => SignUpCubit(getIt()));

  // --------------------------- Home Feature (Clean Architecture) ----------------------------------

  // Data Layer
  getIt.registerLazySingleton<HomeRemoteDataSource>(() => HomeRemoteDataSource(getIt()));
  getIt.registerLazySingleton<HomeRepository>(() => HomeRepositoryImpl(getIt()));

  // Domain Layer
  getIt.registerFactory<GetAllProducts>(() => GetAllProducts(getIt()));
  getIt.registerFactory<GetCategoriesProducts>(() => GetCategoriesProducts(getIt()));
  getIt.registerFactory<GetAllCategories>(() => GetAllCategories(getIt()));

  // Presentation Layer
  getIt.registerFactory<AllProductsCubit>(() => AllProductsCubit(getIt(), getIt()));
  getIt.registerFactory<AllCategoriesCubit>(() => AllCategoriesCubit(getIt()));
}
