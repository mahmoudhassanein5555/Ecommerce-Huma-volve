import 'package:json_annotation/json_annotation.dart';

part 'sign_up_request_model.g.dart';

@JsonSerializable()
class SignUpRequestModel {
  final String email;
  final String name;
  final String password;
  final String role;
  final String avatar;

  // The API requires role and avatar, so the form only asks for email/name/password
  const SignUpRequestModel({
    required this.email,
    required this.name,
    required this.password,
    this.role = 'customer',
    this.avatar = 'https://picsum.photos/800',
  });

  factory SignUpRequestModel.fromJson(Map<String, dynamic> json) =>
      _$SignUpRequestModelFromJson(json);

  Map<String, dynamic> toJson() => _$SignUpRequestModelToJson(this);
}
