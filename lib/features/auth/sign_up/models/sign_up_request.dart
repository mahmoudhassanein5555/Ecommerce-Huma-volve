class SignUpRequest {
  final String email;
  final String name;
  final String password;
  final String role;
  final String avatar;

  const SignUpRequest({
    required this.email,
    required this.name,
    required this.password,
    this.role = 'customer',
    this.avatar =
        'https://www.magnific.com/free-vector/user-circles-set_145856997.htm#fromView=keyword&page=1&position=0&uuid=d5f90444-d1bc-42ba-bd54-1f5fd7b1b617&track=ais_hybrid&query=User',
  });

  Map<String, dynamic> toJson() => {
        'email': email,
        'name': name,
        'password': password,
        'role': role,
        'avatar': avatar,
      };
}
