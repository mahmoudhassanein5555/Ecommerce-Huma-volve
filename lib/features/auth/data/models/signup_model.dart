import 'package:ecommerce_app_huma_volve/features/auth/domain/entities/signup_entity.dart';

class SignupModel extends SignupEntity {
  const SignupModel({
    super.id,
    super.email,
    super.name,
    super.role,
    super.avatar,
    super.createdAt,
    super.updatedAt,
  });

  factory SignupModel.fromJson(Map<String, dynamic> json) {
    return SignupModel(
      id: json['id'] as int?,
      email: json['email'] as String?,
      name: json['name'] as String?,
      role: json['role'] as String?,
      avatar: json['avatar'] as String?,
      createdAt: json['creationAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
    );
  }
}
