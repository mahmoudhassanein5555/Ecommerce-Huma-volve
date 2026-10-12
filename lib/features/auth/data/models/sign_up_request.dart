import 'package:json_annotation/json_annotation.dart';

part 'sign_up_request.g.dart';

@JsonSerializable()
class SignUpRequest {
  final String email;
  final String name;
  final String password;
  final String role;
  final String avatar;

  // The API requires role and avatar, so the form only asks for email/name/password
  const SignUpRequest({
    required this.email,
    required this.name,
    required this.password,
    this.role = 'customer',
    this.avatar = 'https://picsum.photos/800',
  });

  factory SignUpRequest.fromJson(Map<String, dynamic> json) =>
      _$SignUpRequestFromJson(json);

  Map<String, dynamic> toJson() => _$SignUpRequestToJson(this);
}