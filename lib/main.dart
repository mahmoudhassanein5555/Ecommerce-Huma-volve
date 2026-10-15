import 'package:ecommerce_app_huma_volve/core/constant/api_constant.dart';
import 'package:ecommerce_app_huma_volve/core/netWork/api_client.dart';
import 'package:ecommerce_app_huma_volve/core/theme.dart';
import 'package:ecommerce_app_huma_volve/features/auth/Data/data_source/auth_remote_data_source.dart';
import 'package:ecommerce_app_huma_volve/features/auth/Data/data_source/auth_remote_data_source_im.dart';
import 'package:ecommerce_app_huma_volve/features/auth/Data/repository/auth_repository_im.dart';
import 'package:ecommerce_app_huma_volve/features/auth/Domain/repository/auth_repository.dart';
import 'package:ecommerce_app_huma_volve/features/auth/Domain/use_case/post_login_use_case.dart';
import 'package:ecommerce_app_huma_volve/features/auth/Domain/use_case/post_sign_up_use_case.dart';
import 'package:ecommerce_app_huma_volve/features/auth/Presentation/view/login_screen.dart';
import 'package:ecommerce_app_huma_volve/features/auth/Presentation/view/sign_up_screen.dart';
import 'package:ecommerce_app_huma_volve/features/auth/Presentation/view_model/auth_cubit.dart';
import 'package:ecommerce_app_huma_volve/features/home/Data/data_source/home_remote_data_source.dart';
import 'package:ecommerce_app_huma_volve/features/home/Data/data_source/home_remote_data_source_im.dart';
import 'package:ecommerce_app_huma_volve/features/home/Data/repository/home_repository_im.dart';
import 'package:ecommerce_app_huma_volve/features/home/Domian/repository/home_repository.dart';
import 'package:ecommerce_app_huma_volve/features/home/Domian/use_case/get_catergory_use_case.dart';
import 'package:ecommerce_app_huma_volve/features/home/Domian/use_case/get_product_use_case.dart';
import 'package:ecommerce_app_huma_volve/features/home/presentation/view/home_screen.dart';
import 'package:ecommerce_app_huma_volve/features/home/presentation/view_model/home_cubit.dart';
import 'package:ecommerce_app_huma_volve/features/splash/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  late TextEditingController emailController;
  late TextEditingController passwordController;
  late AuthCubit _authCubit;
  late PostLoginUseCase _postLoginUseCase;
  late PostSignUpUseCase _postSignUpUseCase;
  late AuthRepository _authRepository;
  late AuthRemoteDataSource _authRemoteDataSource;
  late ApiClient _apiClient;
  late HomeCubit _homeCubit;
  late GetProductUseCase getProductsUseCase;
  late GetCatergoryUseCase getCategoriesUseCase;
  late HomeRepository homeRepository;
  late HomeRemoteDataSource homeRemoteDataSource;

  MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    _apiClient = ApiClient(ApiConstants.baseUrl);
    _authRemoteDataSource = AuthRemoteDataSourceIm(apiClient: _apiClient);
    _authRepository = AuthRepositoryIm(_authRemoteDataSource);
    _postLoginUseCase = PostLoginUseCase(_authRepository);
    _postSignUpUseCase = PostSignUpUseCase(_authRepository);
    _authCubit = AuthCubit(
      postLoginUseCase: _postLoginUseCase,
      postSignUpUseCase: _postSignUpUseCase,
    );
    homeRemoteDataSource = HomeRemoteDataSourceIm(apiClient: _apiClient);
    homeRepository = HomeRepositoryIm(homeRemoteDataSource);
    getCategoriesUseCase = GetCatergoryUseCase(homeRepository);
    getProductsUseCase = GetProductUseCase(homeRepository);

    _homeCubit = HomeCubit(
      getCategoriesUseCase: getCategoriesUseCase,
      getProductsUseCase: getProductsUseCase,
    );
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => _authCubit, child: SignUpScreen()),
        BlocProvider(create: (context) => _authCubit, child: LoginScreen()),
        BlocProvider(create: (context) => _homeCubit, child: HomeScreen()),
      ],
      child: MaterialApp(
        title: 'E-Commerce App',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: const SplashScreen(),
      ),
    );
  }
}
