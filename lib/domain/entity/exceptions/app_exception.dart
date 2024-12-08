class AppException implements Exception {
  final String errorText;

  const AppException({
    required this.errorText,
  });
}
