class AuthException implements Exception {
  final String _message;

  const AuthException(this._message);
  String get message => _message;
}