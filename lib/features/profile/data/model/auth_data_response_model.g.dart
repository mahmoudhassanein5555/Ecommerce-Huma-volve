// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_data_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuthDataResponseModel _$AuthDataResponseModelFromJson(
  Map<String, dynamic> json,
) => AuthDataResponseModel(
  id: (json['id'] as num).toInt(),
  email: json['email'] as String,
  name: json['name'] as String,
  role: json['role'] as String,
  avatar: json['avatar'] as String,
  creationAt: DateTime.parse(json['creationAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$AuthDataResponseModelToJson(
  AuthDataResponseModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'email': instance.email,
  'name': instance.name,
  'role': instance.role,
  'avatar': instance.avatar,
  'creationAt': instance.creationAt.toIso8601String(),
  'updatedAt': instance.updatedAt.toIso8601String(),
};
