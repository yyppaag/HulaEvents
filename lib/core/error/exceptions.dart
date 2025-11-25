/// Base exception class for all app exceptions
abstract class AppException implements Exception {
  final String message;
  final String? code;

  const AppException(this.message, {this.code});

  @override
  String toString() => 'AppException: $message';
}

/// Exception thrown when cache operations fail
class CacheException extends AppException {
  const CacheException([String message = 'Cache operation failed'])
      : super(message, code: 'CACHE_ERROR');
}

/// Exception thrown when data is not found
class NotFoundException extends AppException {
  const NotFoundException([String message = 'Data not found'])
      : super(message, code: 'NOT_FOUND');
}

/// Exception thrown when validation fails
class ValidationException extends AppException {
  const ValidationException([String message = 'Validation failed'])
      : super(message, code: 'VALIDATION_ERROR');
}

/// Exception thrown when storage is full or unavailable
class StorageException extends AppException {
  const StorageException([String message = 'Storage operation failed'])
      : super(message, code: 'STORAGE_ERROR');
}

/// Exception thrown for unexpected errors
class UnexpectedException extends AppException {
  const UnexpectedException([String message = 'An unexpected error occurred'])
      : super(message, code: 'UNEXPECTED_ERROR');
}
