enum HomeFailureKind { network, server, invalidResponse, unknown }

class HomeFailure implements Exception {
  const HomeFailure(this.message, this.kind);

  final String message;
  final HomeFailureKind kind;

  @override
  String toString() => message;
}
