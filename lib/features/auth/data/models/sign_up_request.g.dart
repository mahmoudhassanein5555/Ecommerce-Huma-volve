// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sign_up_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SignUpRequest _$SignUpRequestFromJson(Map<String, dynamic> json) =>
    SignUpRequest(
      email: json['email'] as String,
      name: json['name'] as String,
      password: json['password'] as String,
      role: json['role'] as String? ?? 'customer',
      avatar: json['avatar'] as String? ?? 'https://picsum.photos/800',
    );

Map<String, dynamic> _$SignUpRequestToJson(SignUpRequest instance) =>
    <String, dynamic>{
      'email': instance.email,
      'name': instance.name,
      'password': instance.password,
      'role': instance.role,
      'avatar': instance.avatar,
    };
