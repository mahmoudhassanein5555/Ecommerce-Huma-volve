import 'package:dio/dio.dart';
import 'package:ecommerce_app_huma_volve/core/consts/api_consts.dart';
import 'package:ecommerce_app_huma_volve/core/errors/remote_exption.dart';
import 'package:ecommerce_app_huma_volve/features/home/data/data_source/remote/product_remote_data_source.dart';
import 'package:ecommerce_app_huma_volve/features/home/data/models/product_model.dart';
import 'package:injectable/injectable.dart';

@Singleton(as: ProductRemoteDataSource)
class ProductApiDataSource implements ProductRemoteDataSource {
  final Dio _dio;

  ProductApiDataSource(this._dio);

  @override
  Future<List<ProductModel>> getProducts({
    int? categoryId,
    required int offset,
  }) async {
    try {
      final endpoint = categoryId == null
          ? ApiConsts.productsEndPoint
          : '${ApiConsts.categoriesEndPoint}/$categoryId/products';
      final response = await _dio.get(
        endpoint,
        queryParameters: {'limit': ApiConsts.productsLimit, 'offset': offset},
      );
      final data = response.data;

      if (data is! List) {
        throw RemoteExptions('Invalid products response');
      }

      return data.map((item) {
        if (item is! Map || item.keys.any((key) => key is! String)) {
          throw RemoteExptions('Invalid product response');
        }
        return ProductModel.fromJson(Map<String, dynamic>.from(item));
      }).toList();
    } catch (error) {
      throw RemoteExptions(error.toString());
    }
  }
}
