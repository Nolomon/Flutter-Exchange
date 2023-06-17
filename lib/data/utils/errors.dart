class ParsingException implements Exception {
  final String? message;
  final String? stack;

  ParsingException({this.message = 'can not parse response', this.stack});
}

class ServerException<T> implements Exception {
  final String? message;
  final T? originalRequest;
  ServerException({this.message, this.originalRequest});
}

class NoInternetConnectionException<T> implements Exception {
  final String message;
  final T? originalRequest;

  NoInternetConnectionException(
      {this.message = 'No Internet Connection', this.originalRequest});
}

class UnknownException<T> implements Exception {
  final String message;
  final T? originalRequest;

  UnknownException({this.message = 'Weak network connection', this.originalRequest});
}