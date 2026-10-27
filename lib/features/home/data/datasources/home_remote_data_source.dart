import 'package:dio/dio.dart';
import '../models/product_model.dart';

abstract class HomeRemoteDataSource {
  Future<List<ProductModel>> getProducts({
    required int offset,
    required int limit,
  });
}

class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  final Dio dio;

  HomeRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<ProductModel>> getProducts({
    required int offset,
    required int limit,
  }) async {
    try {
      final response = await dio.get(
        'https://api.escuelajs.co/api/v1/products',
        queryParameters: {'offset': offset, 'limit': limit},
      );

      final List data = response.data;
      return data.map((json) => ProductModel.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to load products: ${e.toString()}');
    }
  }
}
