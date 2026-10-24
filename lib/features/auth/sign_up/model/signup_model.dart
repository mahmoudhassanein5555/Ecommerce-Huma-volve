class SignupModel {

  int? id;
  String? email;
  String? password;
  String? name;
  String? role;
  String? avatar;
  String? creationAt;
  String? updatedAt;

  SignupModel({
      this.id, 
      this.email, 
      this.password, 
      this.name, 
      this.role, 
      this.avatar, 
      this.creationAt, 
      this.updatedAt,});

  SignupModel.fromJson(Map<String,dynamic> json) {
    id = json['id'];
    email = json['email'];
    password = json['password'];
    name = json['name'];
    role = json['role'];
    avatar = json['avatar'];
    creationAt = json['creationAt'];
    updatedAt = json['updatedAt'];
  }

}