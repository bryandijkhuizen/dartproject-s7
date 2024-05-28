class DartGameException implements Exception {
  final String message;
  DartGameException(this.message);

  @override
  String toString() => 'DartGameException: $message';
}