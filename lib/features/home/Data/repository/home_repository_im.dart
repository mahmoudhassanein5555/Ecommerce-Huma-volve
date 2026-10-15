import 'package:dartz/dartz.dart';
import 'package:ecommerce_app_huma_volve/core/Failure/Failure.dart';
import 'package:ecommerce_app_huma_volve/core/error/error_handling.dart';
import 'package:ecommerce_app_huma_volve/features/home/Data/data_source/home_remote_data_source.dart';
import 'package:ecommerce_app_huma_volve/features/home/Data/model/category_model.dart';
import 'package:ecommerce_app_huma_volve/features/home/Data/model/product_model.dart';
import 'package:ecommerce_app_huma_volve/features/home/Domian/entites/home_category_entity.dart';
import 'package:ecommerce_app_huma_volve/features/home/Domian/entites/home_product_entity.dart';
import 'package:ecommerce_app_huma_volve/features/home/Domian/repository/home_repository.dart';

class HomeRepositoryIm implements HomeRepository {
  final HomeRemoteDataSource homeRemoteDataSource;
  HomeRepositoryIm(this.homeRemoteDataSource);
  @override
  Future<Either<Failure, List<HomeCategoryEntity>>> getCategories() async {
    try {
      final categories = await homeRemoteDataSource.getCategories();
      final categoriesEntity = _ModelToEntityCategory(categories);

      return Right(categoriesEntity);
    } catch (e) {
      return Left(ErrorHandling.handleError(e));
    }
  }

  @override
  Future<Either<Failure, List<HomeProductEntity>>> getProducts(
    int categoryId,
    int offSet,
  ) async {
    try {
      final products = await homeRemoteDataSource.getProducts(
        categoryId,
        offSet,
      );
      final productsEntity = _ModelToEntityProduct(products);
      return Right(productsEntity);
    } catch (e) {
      return Left(ErrorHandling.handleError(e));
    }
  }
}

List<HomeCategoryEntity> _ModelToEntityCategory(
  List<HomeCategoryModel> homeCategoryEntity,
) {
  final List<HomeCategoryEntity> categoriesEntity = homeCategoryEntity
      .map((e) => HomeCategoryEntity(id: e.id, name: e.name))
      .toList();
  return categoriesEntity;
}

List<HomeProductEntity> _ModelToEntityProduct(
  List<HomeProductModel> homeProductModel,
) {
  return homeProductModel
      .map(
        (e) => HomeProductEntity(
          id: e.id,
          title: e.title,
          slug: e.slug,
          price: e.price,
          description: e.description,
          category: e.category == null
              ? null
              : HomeCategoryEntity(id: e.category!.id, name: e.category!.name),
          images: e.images,
        ),
      )
      .toList();
}
