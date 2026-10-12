class SignUpModel {
  int? id;
  String email;
  String password;
  String name;
  String? role;
  String? avatar;
  String? creationAt;
  String? updatedAt;

  SignUpModel({
    this.id,
    required this.email,
    required this.password,
    required this.name,
    this.role,
    this.avatar,
    this.creationAt,
    this.updatedAt,
  });

  SignUpModel.fromJson(Map<String, dynamic> json)
      : id = json['id'] as int?,
        email = json['email']?.toString() ?? '',
        password = json['password']?.toString() ?? '',
        name = json['name']?.toString() ?? '',
        role = json['role']?.toString(),
        avatar = json['avatar']?.toString(),
        creationAt = json['creationAt']?.toString(),
        updatedAt = json['updatedAt']?.toString();

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['email'] = email;
    data['password'] = password;
    data['name'] = name;
    data['role'] = role;
    data['avatar'] = avatar;
    data['creationAt'] = creationAt;
    data['updatedAt'] = updatedAt;
    return data;
  }
}
