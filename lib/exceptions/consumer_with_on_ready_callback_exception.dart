class ConsumerWithOnReadyCallbackException implements Exception {
  String cause;

  ConsumerWithOnReadyCallbackException({required this.cause});
}
