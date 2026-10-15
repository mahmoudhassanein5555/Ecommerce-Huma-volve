import 'package:ecommerce_app_huma_volve/features/auth/domain/entities/signup_req_entity.dart';

class SignupReqModel extends SignupReqEntity {
  SignupReqModel({
    required super.email,
    required super.name,
    required super.password,
  });

  factory SignupReqModel.fromJson(Map<String, dynamic> json) => SignupReqModel(
    email: json["email"] ?? "",
    name: json["name"] ?? "",
    password: json["password"] ?? "",
  );

  //from entity
  factory SignupReqModel.fromEntity(SignupReqEntity entity) => SignupReqModel(
    email: entity.email,
    name: entity.name,
    password: entity.password,
  );
}
