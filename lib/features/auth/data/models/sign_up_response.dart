import 'package:json_annotation/json_annotation.dart';

part 'sign_up_response.g.dart';

@JsonSerializable()
class SignUpResponse {
  final int id;
  final String email;
  final String name;
  final String role;
  final String avatar;
  final String? password; // returned by this API, don't use or store it
  final DateTime? creationAt;
  final DateTime? updatedAt;

  const SignUpResponse({
    required this.id,
    required this.email,
    required this.name,
    required this.role,
    required this.avatar,
    this.password,
    this.creationAt,
    this.updatedAt,
  });

  factory SignUpResponse.fromJson(Map<String, dynamic> json) =>
      _$SignUpResponseFromJson(json);

  Map<String, dynamic> toJson() => _$SignUpResponseToJson(this);
}