import 'package:dartz/dartz.dart';
import 'package:ecommerce_app_huma_volve/core/errors/app_exptions.dart';
import 'package:ecommerce_app_huma_volve/core/errors/failer.dart';
import 'package:ecommerce_app_huma_volve/features/home/data/data_source/remote/category_remote_data_source.dart';
import 'package:ecommerce_app_huma_volve/features/home/domain/entities/category.dart';
import 'package:ecommerce_app_huma_volve/features/home/domain/repo/category_repo.dart';
import 'package:injectable/injectable.dart';

@Singleton(as: CategoryRepo)
class CategoryRepoImpl implements CategoryRepo {
  final CategoryRemoteDataSource _remoteDataSource;

  CategoryRepoImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, List<Category>>> getCategories() async {
    try {
      final categories = await _remoteDataSource.getCategories();
      return Right(categories);
    } on AppExceptions catch (e) {
      return Left(ErrorHandler.handle(e.message));
    }
  }
}
