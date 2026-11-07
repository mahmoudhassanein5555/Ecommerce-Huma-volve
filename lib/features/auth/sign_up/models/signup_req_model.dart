class SignupReqModel {
  String? name;
  String? email;
  String? role;
  String? password;

  SignupReqModel({this.name, this.email,this.role, this.password});

  SignupReqModel.fromJson(Map<String, dynamic> json) {
    name= json['access_token'] ;
    email = json['refresh_token'];
    password = json['refresh_token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['access_token'] = this.name;
    data['refresh_token'] = this.email;
    data['refresh_token'] = this.password;
    return data;
  }
}