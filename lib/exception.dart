class InternalServerError implements Exception {
  final String error = 'Internal server error';
}

class TooManyRequests implements Exception {
  final String error = 'Too Many Requests';
}
