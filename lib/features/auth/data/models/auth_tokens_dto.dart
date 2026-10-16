class AuthTokensDto {
  const AuthTokensDto({required this.accessToken, required this.refreshToken});

  final String accessToken;
  final String refreshToken;

  factory AuthTokensDto.fromJson(Map<String, dynamic> json) {
    final accessToken = json['access_token'];
    final refreshToken = json['refresh_token'];
    if (accessToken is! String ||
        accessToken.isEmpty ||
        refreshToken is! String ||
        refreshToken.isEmpty) {
      throw const FormatException('The authentication response is incomplete.');
    }
    return AuthTokensDto(
      accessToken: accessToken,
      refreshToken: refreshToken,
    );
  }
}
