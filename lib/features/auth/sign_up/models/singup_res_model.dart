
class SingupResModel {
  int? id;
  String? email;
  String? name;
  String? password;
  String? role;
  String? avatar;
  String? updatedAt;
  String? creationAt;

  SingupResModel({
    this.id,
    this.email,
    this.name,
    this.password,
    this.role,
    this.avatar,
    this.updatedAt,
    this.creationAt,
  });

  SingupResModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    email = json['email'];
    name = json['name'];
    password = json['password'];
    role = json['role'];
    avatar = json['avatar'];
    updatedAt = json['updatedAt'];
    creationAt = json['creationAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['email'] = email;
    data['name'] = name;
    data['password'] = password;
    data['role'] = role;
    data['avatar'] = avatar;
    data['updatedAt'] = updatedAt;
    data['creationAt'] = creationAt;

    return data;
  }
}
