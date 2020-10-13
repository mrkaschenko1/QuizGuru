class BaseException {
  final String _message;

  const BaseException(this._message);
  String get message => _message;
}