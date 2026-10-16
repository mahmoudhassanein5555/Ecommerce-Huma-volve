import 'package:json_annotation/json_annotation.dart';

part 'sign_up_response_model.g.dart';

@JsonSerializable()
class SignUpResponseModel {
  final int id;
  final String email;
  final String name;
  final String role;
  final String avatar;
  final String? password; // returned by this API, don't use or store it
  final DateTime? creationAt;
  final DateTime? updatedAt;

  const SignUpResponseModel({
    required this.id,
    required this.email,
    required this.name,
    required this.role,
    required this.avatar,
    this.password,
    this.creationAt,
    this.updatedAt,
  });

  factory SignUpResponseModel.fromJson(Map<String, dynamic> json) =>
      _$SignUpResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$SignUpResponseModelToJson(this);
}
