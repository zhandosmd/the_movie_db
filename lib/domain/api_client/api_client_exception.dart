enum ApiClienExceptionType { network, auth, other, sessionExpired }

class ApiClienException implements Exception {
  final ApiClienExceptionType type;

  ApiClienException(this.type);
}
