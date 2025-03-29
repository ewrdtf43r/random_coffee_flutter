class ServerException implements Exception {
  final String message;
  final int statusCode;

  ServerException({required this.message, required this.statusCode});

  @override
  String toString() => 'ServerException: $message (Status code: $statusCode)';
}

class NetworkException implements Exception {
  final String message;

  NetworkException({this.message = 'Нет подключения к интернету'});

  @override
  String toString() => 'NetworkException: $message';
}
