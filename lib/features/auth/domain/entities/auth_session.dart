import 'auth_user.dart';

class AuthSession {
  const AuthSession({required this.user, required this.accessToken});

  final AuthUser user;
  final String accessToken;
}
