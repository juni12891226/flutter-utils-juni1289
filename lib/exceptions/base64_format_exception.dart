class Base64FormatException implements Exception {
  String cause;

  Base64FormatException({required this.cause});
}
