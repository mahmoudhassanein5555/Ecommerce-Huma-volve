import 'package:dio/dio.dart';

import '../../../core/network/api_client.dart';
import 'home_api_constants.dart';

class HomeApiService {
  const HomeApiService(this._apiClient);

  final ApiClient _apiClient;

  Future<Response<dynamic>> getProducts({
    required int limit,
    required int offset,
  }) {
    return _apiClient.dio.get(
      HomeApiConstants.productsEndpoint,
      queryParameters: {'limit': limit, 'offset': offset},
    );
  }

  Future<Response<dynamic>> getProductById(int id) {
    return _apiClient.dio.get(HomeApiConstants.productByIdEndpoint(id));
  }

  Future<Response<dynamic>> getProductsByCategory({
    required int categoryId,
    required int limit,
    required int offset,
  }) {
    return _apiClient.dio.get(
      HomeApiConstants.categoryProductsEndpoint(categoryId),
      queryParameters: {'limit': limit, 'offset': offset},
    );
  }
}
