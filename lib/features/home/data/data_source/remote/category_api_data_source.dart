import 'package:dio/dio.dart';
import 'package:ecommerce_app_huma_volve/core/consts/api_consts.dart';
import 'package:ecommerce_app_huma_volve/core/errors/remote_exption.dart';
import 'package:ecommerce_app_huma_volve/features/home/data/data_source/remote/category_remote_data_source.dart';
import 'package:ecommerce_app_huma_volve/features/home/data/models/category_model.dart';
import 'package:injectable/injectable.dart';

@Singleton(as: CategoryRemoteDataSource)
class CategoryApiDataSource implements CategoryRemoteDataSource {
  final Dio _dio;

  CategoryApiDataSource(this._dio);

  @override
  Future<List<CategoryModel>> getCategories() async {
    try {
      final response = await _dio.get(
        ApiConsts.categoriesEndPoint,
        queryParameters: {'limit': ApiConsts.categoriesLimit},
      );
      final data = response.data;

      if (data is! List) {
        throw RemoteExptions('Invalid categories response');
      }

      return data.map((item) {
        if (item is! Map || item.keys.any((key) => key is! String)) {
          throw RemoteExptions('Invalid category response');
        }
        return CategoryModel.fromJson(Map<String, dynamic>.from(item));
      }).toList();
    } catch (error) {
      throw RemoteExptions(error.toString());
    }
  }
}
