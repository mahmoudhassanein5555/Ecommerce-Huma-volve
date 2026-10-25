class AuthSessionEntity {
  final String? accessToken;
  final String? refreshToken;

  const AuthSessionEntity({
    required this.accessToken,
    required this.refreshToken,
  });
}
