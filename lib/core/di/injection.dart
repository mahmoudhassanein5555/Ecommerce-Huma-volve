import 'package:dio/dio.dart';
import 'package:ecommerce_app_huma_volve/core/networking/api_service.dart';
import 'package:ecommerce_app_huma_volve/core/networking/dio_factory.dart';
import 'package:ecommerce_app_huma_volve/features/auth/data/repo/auth_repo.dart';
import 'package:ecommerce_app_huma_volve/features/auth/login/logic/cubit/login_cubit.dart';
import 'package:ecommerce_app_huma_volve/features/auth/sign_up/logic/cubit/sign_up_cubit.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

Future<void> setupGetIt() async {
  Dio dio = await DioFactory.getDio();
  //Api Service

  getIt.registerLazySingleton<ApiServices>(() => ApiServices(dio));

  // --------------------------- login / Auth ----------------------------------

  getIt.registerLazySingleton<AuthRepo>(() => AuthRepo(getIt()));

  getIt.registerFactory<LoginCubit>(() => LoginCubit(getIt()));
  getIt.registerFactory<SignUpCubit>(() => SignUpCubit(getIt()));
}
