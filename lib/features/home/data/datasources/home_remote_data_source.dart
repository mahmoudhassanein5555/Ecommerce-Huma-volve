import 'package:dio/dio.dart';

import '../../../../core/error/app_exception.dart';
import '../../../../core/network/dio_exception_mapper.dart';
import '../../api/home_api_service.dart';
import '../models/product_model.dart';

abstract class HomeRemoteDataSource {
  Future<List<ProductModel>> getProducts({
    required int limit,
    required int offset,
  });

  Future<List<ProductModel>> getProductsByCategory({
    required int categoryId,
    required int limit,
    required int offset,
  });

  Future<ProductModel> getProductById(int id);
}

class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  const HomeRemoteDataSourceImpl(this._apiService);

  final HomeApiService _apiService;

  @override
  Future<List<ProductModel>> getProducts({
    required int limit,
    required int offset,
  }) async {
    try {
      final response = await _apiService.getProducts(
        limit: limit,
        offset: offset,
      );
      return _parseProducts(response.data);
    } on DioException catch (e) {
      throw mapDioException(e);
    }
  }

  @override
  Future<List<ProductModel>> getProductsByCategory({
    required int categoryId,
    required int limit,
    required int offset,
  }) async {
    try {
      final response = await _apiService.getProductsByCategory(
        categoryId: categoryId,
        limit: limit,
        offset: offset,
      );
      return _parseProducts(response.data);
    } on DioException catch (e) {
      throw mapDioException(e);
    }
  }

  @override
  Future<ProductModel> getProductById(int id) async {
    try {
      final response = await _apiService.getProductById(id);
      final data = response.data;
      if (data is! Map<String, dynamic>) {
        throw const AppException(
          'Unexpected response from server. Please try again.',
        );
      }
      return ProductModel.fromJson(data);
    } on DioException catch (e) {
      throw mapDioException(e);
    }
  }

  List<ProductModel> _parseProducts(dynamic data) {
    if (data is! List) {
      throw const AppException(
        'Unexpected response from server. Please try again.',
      );
    }
    return data
        .whereType<Map<String, dynamic>>()
        .map(ProductModel.fromJson)
        .toList();
  }
}
