// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sign_up_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SignUpResponseModel _$SignUpResponseModelFromJson(Map<String, dynamic> json) =>
    SignUpResponseModel(
      id: (json['id'] as num).toInt(),
      email: json['email'] as String,
      name: json['name'] as String,
      role: json['role'] as String,
      avatar: json['avatar'] as String,
      password: json['password'] as String?,
      creationAt:
          json['creationAt'] == null
              ? null
              : DateTime.parse(json['creationAt'] as String),
      updatedAt:
          json['updatedAt'] == null
              ? null
              : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$SignUpResponseModelToJson(
  SignUpResponseModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'email': instance.email,
  'name': instance.name,
  'role': instance.role,
  'avatar': instance.avatar,
  'password': instance.password,
  'creationAt': instance.creationAt?.toIso8601String(),
  'updatedAt': instance.updatedAt?.toIso8601String(),
};
