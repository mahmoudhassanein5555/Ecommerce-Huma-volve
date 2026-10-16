import 'package:json_annotation/json_annotation.dart';

part 'auth_data_response_model.g.dart';

@JsonSerializable()
class AuthDataResponseModel {
  final int id;
  final String email;

  // Never store or return the password from an authentication response
  // unless your API explicitly requires it.
  final String name;
  final String role;
  final String avatar;
  final DateTime creationAt;
  final DateTime updatedAt;

  const AuthDataResponseModel({
    required this.id,
    required this.email,
    required this.name,
    required this.role,
    required this.avatar,
    required this.creationAt,
    required this.updatedAt,
  });

  factory AuthDataResponseModel.fromJson(Map<String, dynamic> json) =>
      _$AuthDataResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$AuthDataResponseModelToJson(this);
}
