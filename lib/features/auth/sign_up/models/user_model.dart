class UserModel {
  final int? id;
  final String? name;
  final String? email;
  final String? avatar;
  final String? role;

  UserModel({this.id, this.name, this.email, this.avatar, this.role});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] is int
          ? json['id']
          : int.tryParse(json['id']?.toString() ?? ''),
      name: json['name']?.toString(),
      email: json['email']?.toString(),
      avatar: json['avatar']?.toString(),
      role: json['role']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {'name': name, 'email': email, 'avatar': avatar, 'role': role};
  }
}
