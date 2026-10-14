import 'package:dio/dio.dart';

import '../../domain/entities/home_data.dart';
import '../../domain/failures/home_failure.dart';
import '../../domain/repositories/home_repository.dart';
import '../datasources/home_remote_data_source.dart';
import '../models/category_dto.dart';
import '../models/product_dto.dart';

class HomeRepositoryImpl implements HomeRepository {
  const HomeRepositoryImpl(this._remoteDataSource);

  final HomeRemoteDataSource _remoteDataSource;

  @override
  Future<HomeData> fetchHomeData() async {
    try {
      final results = await Future.wait([
        _remoteDataSource.fetchProducts(),
        _remoteDataSource.fetchCategories(),
      ]);

      final products = results[0] as List<ProductDto>;
      final categories = results[1] as List<CategoryDto>;

      return HomeData(
        products: products.map((item) => item.toEntity()).toList(),
        categories: categories.map((item) => item.toEntity()).toList(),
      );
    } on DioException catch (error) {
      throw _mapDioError(error);
    } on FormatException {
      throw const HomeFailure(
        'The server returned invalid product or category data.',
        HomeFailureKind.invalidResponse,
      );
    }
  }

  HomeFailure _mapDioError(DioException error) {
    if (error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.sendTimeout ||
        error.type == DioExceptionType.receiveTimeout) {
      return const HomeFailure(
        'The request timed out. Please try again.',
        HomeFailureKind.network,
      );
    }
    if (error.type == DioExceptionType.connectionError ||
        error.type == DioExceptionType.unknown) {
      return const HomeFailure(
        'Unable to connect. Check your internet connection and try again.',
        HomeFailureKind.network,
      );
    }
    if (error.response?.statusCode == 429) {
      return const HomeFailure(
        'Too many requests. Please try again later.',
        HomeFailureKind.server,
      );
    }
    if ((error.response?.statusCode ?? 0) >= 500) {
      return const HomeFailure(
        'The server is temporarily unavailable.',
        HomeFailureKind.server,
      );
    }
    return const HomeFailure(
      'Unable to load products. Please try again.',
      HomeFailureKind.unknown,
    );
  }
}
