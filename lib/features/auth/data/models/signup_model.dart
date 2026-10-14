import '../../domain/entities/signup_entity.dart';

class SignupModel extends SignupEntity {
  const SignupModel({
    super.id,
    super.name,
    super.email,
    super.role,
    super.avatar,
  });

  factory SignupModel.fromJson(Map<String, dynamic> json) {
    return SignupModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      role: json['role'] ?? '',
      avatar: json['avatar'] ?? '',
    );
  }
}
