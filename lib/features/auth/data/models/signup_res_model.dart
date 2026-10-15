import 'package:ecommerce_app_huma_volve/features/auth/domain/entities/signup_res_entity.dart';

class SignupResModel extends SignupResEntity {
  SignupResModel({
    required super.id,
    required super.email,
    required super.password,
    required super.name,
    required super.role,
    required super.avatar,
    required super.creationAt,
    required super.updatedAt,
  });

  factory SignupResModel.fromJson(Map<String, dynamic> json) => SignupResModel(
    id: json["id"] ?? 0,
    email: json["email"] ?? "",
    password: json["password"] ?? "",
    name: json["name"] ?? "",
    role: json["role"] ?? "",
    avatar: json["avatar"] ?? "",
    creationAt: json["creationAt"] ?? "",
    updatedAt: json["updatedAt"] ?? "",
  );

  //toEntity
  SignupResEntity toEntity() => SignupResEntity(
    id: id,
    email: email,
    password: password,
    name: name,
    role: role,
    avatar: avatar,
    creationAt: creationAt,
    updatedAt: updatedAt,
  );
}
