class SignUpResponse {
  final int? id;
  final String? email;
  final String? password;
  final String? name;
  final String? role;
  final String? avatar;
  final DateTime? creationAt;
  final DateTime? updatedAt;

  const SignUpResponse({
    this.id,
    this.email,
    this.password,
    this.name,
    this.role,
    this.avatar,
    this.creationAt,
    this.updatedAt,
  });

  factory SignUpResponse.fromJson(Map<String, dynamic> json) {
    return SignUpResponse(
      id: json['id'] is int
          ? json['id'] as int
          : int.tryParse('${json['id']}'),
      email: json['email'] as String?,
      password: json['password'] as String?,
      name: json['name'] as String?,
      role: json['role'] as String?,
      avatar: json['avatar'] as String?,
      creationAt: DateTime.tryParse('${json['creationAt'] ?? ''}'),
      updatedAt: DateTime.tryParse('${json['updatedAt'] ?? ''}'),
    );
  }
}
