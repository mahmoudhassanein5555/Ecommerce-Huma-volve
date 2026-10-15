
class Failure {
  String msg;
  Failure(this.msg);
}

class ErrorHandler {
  static Failure handle(String exception) {
    return _handleMessage(exception);
  }

  static Failure _handleMessage(String message) {
    final error = message.toLowerCase();

    // Authentication
    if (error.contains('401') ||
        error.contains('unauthorized') ||
        error.contains('unauthenticated')) {
      return Failure('email or password is incorrect');
    }

    // Forbidden
    if (error.contains('403') || error.contains('forbidden')) {
      return Failure('Forbidden');
    }

    // Not found
    if (error.contains('404') || error.contains('not found')) {
      return Failure('Not Found');
    }

    // Validation
    if (error.contains('422') ||
        error.contains('unprocessable content') ||
        error.contains('unprocessable entity')) {
      return Failure('Validation Error');
    }

    // Server errors
    if (error.contains('500') || error.contains('internal server error')) {
      return Failure('Internal Server Error');
    }

    if (error.contains('502') || error.contains('bad gateway')) {
      return Failure('Bad Gateway');
    }

    if (error.contains('503') || error.contains('service unavailable')) {
      return Failure('Service Unavailable');
    }

    if (error.contains('504') || error.contains('gateway timeout')) {
      return Failure('Gateway Timeout');
    }
    // Network errors
    if (error.contains('connectionerror') ||
        error.contains('connection error') ||
        error.contains('socketexception') ||
        error.contains('connection refused') ||
        error.contains('connection failed') ||
        error.contains('network is unreachable') ||
        error.contains('failed host lookup')) {
      return Failure('No Internet Connection');
    }
    // Timeout
    if (error.contains('timeoutexception') ||
        error.contains('connection timeout') ||
        error.contains('receive timeout') ||
        error.contains('send timeout') ||
        error.contains('deadline exceeded')) {
      return Failure('Request Timeout');
    }

    // SSL / Certificate
    if (error.contains('handshakeexception') ||
        error.contains('certificate') ||
        error.contains('ssl')) {
      return Failure('Secure Connection Failed');
    }

    // Data parsing
    if (error.contains('formatexception') ||
        error.contains('typeerror') ||
        error.contains('type ')) {
      return Failure('Invalid Response Format');
    }

    // Cancelled request
    if (error.contains('request cancelled') ||
        error.contains('request canceled')) {
      return Failure('Request Cancelled');
    }

    return Failure('Unexpected Error');
  }
}
