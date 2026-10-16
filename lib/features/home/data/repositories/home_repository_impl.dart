import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:ecommerce_app_huma_volve/core/error/error_handler.dart';
import 'package:ecommerce_app_huma_volve/features/home/data/data_sources/home_remote_data_source.dart';
import 'package:ecommerce_app_huma_volve/features/home/data/models/category_response_model.dart';
import 'package:ecommerce_app_huma_volve/features/home/data/models/product_response_model.dart';
import 'package:ecommerce_app_huma_volve/features/home/domain/entities/category.dart';
import 'package:ecommerce_app_huma_volve/features/home/domain/entities/product.dart';
import 'package:ecommerce_app_huma_volve/features/home/domain/repositories/home_repository.dart';

class HomeRepositoryImpl implements HomeRepository {
  final HomeRemoteDataSource remoteDataSource;

  HomeRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, List<Product>>> getAllProducts({
    required int limit,
    required int offset,
  }) async {
    try {
      final productModels = await remoteDataSource.getAllProducts(
        limit: limit,
        offset: offset,
      );
      final products =
          productModels.map((model) => _toProductEntity(model)).toList();
      return right(products);
    } catch (error) {
      if (error is DioException) {
        return left(ServerFailure.fromDioError(error));
      }
      return left(ServerFailure(localizedKey: "unexpected_error"));
    }
  }

  @override
  Future<Either<Failure, List<Product>>> getCategoriesProducts({
    required int categoryId,
    required int limit,
    required int offset,
  }) async {
    try {
      final productModels = await remoteDataSource.getCategoriesProducts(
        categoryId: categoryId,
        limit: limit,
        offset: offset,
      );
      final products =
          productModels.map((model) => _toProductEntity(model)).toList();
      return right(products);
    } catch (error) {
      if (error is DioException) {
        return left(ServerFailure.fromDioError(error));
      }
      return left(ServerFailure(localizedKey: "unexpected_error"));
    }
  }

  @override
  Future<Either<Failure, List<Category>>> getAllCategories() async {
    try {
      final categoryModels = await remoteDataSource.getAllCategories();
      final categories =
          categoryModels.map((model) => _toCategoryEntity(model)).toList();
      return right(categories);
    } catch (error) {
      if (error is DioException) {
        return left(ServerFailure.fromDioError(error));
      }
      return left(ServerFailure(localizedKey: "unexpected_error"));
    }
  }

  Product _toProductEntity(ProductResponseModel model) {
    return Product(
      id: model.id,
      title: model.title,
      slug: model.slug,
      price: model.price,
      description: model.description,
      category: _toCategoryEntityFromCategoryModel(model.category),
      images: model.images,
      creationAt: model.creationAt,
      updatedAt: model.updatedAt,
    );
  }

  Category _toCategoryEntity(CategoryResponseModel model) {
    return Category(
      id: model.id,
      name: model.name,
      slug: model.slug,
      image: model.image,
      creationAt: model.creationAt,
      updatedAt: model.updatedAt,
    );
  }

  Category _toCategoryEntityFromCategoryModel(CategoryModel model) {
    return Category(
      id: model.id,
      name: model.name,
      slug: model.slug,
      image: model.image,
      creationAt: model.creationAt,
      updatedAt: model.updatedAt,
    );
  }
}
