import 'package:dio/dio.dart';
import 'package:ecommerce_app_huma_volve/core/constant/api_constants.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/network/dio_helper.dart';
import '../models/auth_model.dart';

class AuthService {
  Future<AuthModel> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await DioHelper.postData(
        url: ApiConstants.loginEndpoint,
        data: {'email': email, 'password': password},
      );
      // تحليل الاستجابة
      if (response.data is Map<String, dynamic>) {
        return AuthModel.fromJson(response.data);
      } else {
        throw ServerFailure('صيغة البيانات القادمة من السيرفر غير متوقعة');
      }
    } on DioException catch (e) {
      throw ServerFailure.fromDioException(e);
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }
}
