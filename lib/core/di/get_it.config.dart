// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'package:dio/dio.dart' as _i361;
import 'package:ecommerce_app_huma_volve/core/di/register_moduls.dart' as _i380;
import 'package:ecommerce_app_huma_volve/features/auth/data/data_source/local/auth_local_data_source.dart'
    as _i201;
import 'package:ecommerce_app_huma_volve/features/auth/data/data_source/local/auth_secure_storage_data_source.dart'
    as _i706;
import 'package:ecommerce_app_huma_volve/features/auth/data/data_source/remote/auth_api_data_source.dart'
    as _i893;
import 'package:ecommerce_app_huma_volve/features/auth/data/data_source/remote/auth_remote_data_source.dart'
    as _i877;
import 'package:ecommerce_app_huma_volve/features/auth/data/repo/auth_repo_impl.dart'
    as _i486;
import 'package:ecommerce_app_huma_volve/features/auth/domain/repo/auth_repo.dart'
    as _i566;
import 'package:ecommerce_app_huma_volve/features/auth/domain/use_cases/login.dart'
    as _i491;
import 'package:ecommerce_app_huma_volve/features/auth/domain/use_cases/register.dart'
    as _i18;
import 'package:ecommerce_app_huma_volve/features/auth/presentation/cubit/auth_cubit.dart'
    as _i79;
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as _i558;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final registerModuls = _$RegisterModuls();
    gh.singleton<_i361.Dio>(() => registerModuls.dio);
    gh.singleton<_i558.FlutterSecureStorage>(
      () => registerModuls.secureStorage,
    );
    gh.singleton<_i877.AuthRemoteDataSource>(
      () => _i893.AuthApiDataSource(gh<_i361.Dio>()),
    );
    gh.singleton<_i201.AuthLocalDataSource>(
      () => _i706.AuthSecureStorageDataSource(gh<_i558.FlutterSecureStorage>()),
    );
    gh.singleton<_i566.AuthRepo>(
      () => _i486.AuthRepoImpl(
        gh<_i877.AuthRemoteDataSource>(),
        gh<_i201.AuthLocalDataSource>(),
      ),
    );
    gh.singleton<_i491.Login>(() => _i491.Login(gh<_i566.AuthRepo>()));
    gh.singleton<_i18.Register>(() => _i18.Register(gh<_i566.AuthRepo>()));
    gh.factory<_i79.AuthCubit>(
      () => _i79.AuthCubit(gh<_i491.Login>(), gh<_i18.Register>()),
    );
    return this;
  }
}

class _$RegisterModuls extends _i380.RegisterModuls {}
