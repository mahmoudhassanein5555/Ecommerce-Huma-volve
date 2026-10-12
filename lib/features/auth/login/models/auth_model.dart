import 'package:ecommerce_app_huma_volve/features/auth/login/models/user_model.dart';

class AuthModel {
  final bool isSuccess;
  final String? message;
  final String? token;
  final UserModel? user;

  AuthModel({required this.isSuccess, this.message, this.token, this.user});

  factory AuthModel.fromJson(Map<String, dynamic> json) {
    // قراءة البيانات بشكل آمن لمنع الأخطاء أثناء اختلاف الـ Keys من السيرفر
    final data = json['data'] is Map<String, dynamic> ? json['data'] : null;

    return AuthModel(
      isSuccess: json['status'] == true || json['status'] == 'success',
      message: json['message']?.toString(),
      token: data != null
          ? data['token']?.toString()
          : json['token']?.toString(),
      user: data != null && data['user'] is Map<String, dynamic>
          ? UserModel.fromJson(data['user'])
          : null,
    );
  }
}
