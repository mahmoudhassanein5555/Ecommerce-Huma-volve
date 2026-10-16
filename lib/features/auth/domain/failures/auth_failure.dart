enum AuthFailureKind { network, invalidCredentials, unauthorized, invalidResponse, server, unknown }

class AuthFailure implements Exception {
  const AuthFailure(this.message, this.kind);

  final String message;
  final AuthFailureKind kind;

  @override
  String toString() => message;
}
