class SignupResModel {
  int? id;
  String? email;
  String? password;
  String? name;
  String? role;
  String? avatar;
  String? creationAt;
  String? updateAt;

  SignupResModel({
    this.id,
    this.email,
    this.password,
    this.name,
    this.role,
    this.avatar,
    this.creationAt,
    this.updateAt
});
  SignupResModel.fromJson(Map<String,dynamic> json) {
    id = json['id'];
    email = json['email'];
    password = json['password'];
    name = json['name'];
    role = json['role'];
    avatar = json['avatar'];
    creationAt = json['creationAt'];
    updateAt = json['updateAt'];
  }

  Map<String,dynamic> toJson() {
    final Map<String,dynamic> data = new Map<String,dynamic>();
    data['id'] = id;
    data['email'] = email;
    data['password'] = password;
    data['name'] = name;
    data['role'] = role;
    data['avatar'] = avatar;
    data['creationAt'] = creationAt;
    data['updateAt'] = updateAt;
    return data;
  }
}