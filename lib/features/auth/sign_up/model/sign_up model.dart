class SignUpModel {
  final String? message;
  final String? token;
  final UserData? userData;

  SignUpModel({
    this.message,
    this.token,
    this.userData,
  });

  factory SignUpModel.fromJson(Map<String, dynamic> json) {
    return SignUpModel(
      message: json['message'] as String?,
      token: json['token'] as String?,
      userData: json['user'] != null
          ? UserData.fromJson(json['user'] as Map<String, dynamic>)
          : null,
    );
  }
}

class UserData {
  final int? id;
  final String? name;
  final String? email;
  final String? password;

  UserData({
    this.id,
    this.name,
    this.email,
    this.password,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      id: json['id'] as int?,
      name: json['name'] as String?,
      email: json['email'] as String?,
      password: json['password'] as String?,
    );
  }
}
