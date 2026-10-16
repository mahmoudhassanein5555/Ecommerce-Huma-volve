// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sign_up_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SignUpRequestModel _$SignUpRequestModelFromJson(Map<String, dynamic> json) =>
    SignUpRequestModel(
      email: json['email'] as String,
      name: json['name'] as String,
      password: json['password'] as String,
      role: json['role'] as String? ?? 'customer',
      avatar: json['avatar'] as String? ?? 'https://picsum.photos/800',
    );

Map<String, dynamic> _$SignUpRequestModelToJson(SignUpRequestModel instance) =>
    <String, dynamic>{
      'email': instance.email,
      'name': instance.name,
      'password': instance.password,
      'role': instance.role,
      'avatar': instance.avatar,
    };
