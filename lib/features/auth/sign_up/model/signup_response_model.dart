/// id : 124
/// email : "john@mail.com"
/// password : "changeme"
/// name : "Jhon"
/// role : "customer"
/// avatar : "https://i.imgur.com/LDOO4Qs.jpg"
/// creationAt : "2026-10-21T15:03:59.000Z"
/// updatedAt : "2026-10-21T15:03:59.000Z"

class SignupResponseModel {
  SignupResponseModel({
    this.id,
    this.email,
    this.password,
    this.name,
    this.role,
    this.avatar,
    this.creationAt,
    this.updatedAt,
  });

  SignupResponseModel.fromJson(dynamic json) {
    id = json['id'];
    email = json['email'];
    password = json['password'];
    name = json['name'];
    role = json['role'];
    avatar = json['avatar'];
    creationAt = json['creationAt'];
    updatedAt = json['updatedAt'];
  }

  num? id;
  String? email;
  String? password;
  String? name;
  String? role;
  String? avatar;
  String? creationAt;
  String? updatedAt;
}
