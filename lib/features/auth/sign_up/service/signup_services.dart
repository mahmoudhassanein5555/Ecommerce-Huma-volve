import 'package:dio/dio.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/network/dio_helper.dart';
import '../models/user_model.dart';

class SignupService {
  // دالة تسجيل الدخول القائمة
  // ... (login code)

  // دالة إنشاء حساب جديد
  Future<UserModel> register({
    required String name,
    required String email,
    required String password,
    String avatar =
        'https://picsum.photos/800', // رابط صورة افتراضي متوافق مع الـ API
  }) async {
    try {
      final response = await DioHelper.postData(
        url: 'users/', // Endpoint الخاص بإنشاء المستخدم
        data: {
          'name': name,
          'email': email,
          'password': password,
          'avatar': avatar,
        },
      );

      if (response.data is Map<String, dynamic>) {
        return UserModel.fromJson(response.data);
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
