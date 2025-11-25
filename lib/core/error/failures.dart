import 'package:equatable/equatable.dart';

/// Base failure class for all app failures
/// Failures are used in the domain layer to represent errors
abstract class Failure extends Equatable {
  final String message;
  final String? code;

  const Failure(this.message, {this.code});

  @override
  List<Object?> get props => [message, code];
}

/// Failure for cache-related errors
class CacheFailure extends Failure {
  const CacheFailure([String message = 'Cache operation failed'])
      : super(message, code: 'CACHE_FAILURE');
}

/// Failure when data is not found
class NotFoundFailure extends Failure {
  const NotFoundFailure([String message = 'Data not found'])
      : super(message, code: 'NOT_FOUND');
}

/// Failure for validation errors
class ValidationFailure extends Failure {
  const ValidationFailure([String message = 'Validation failed'])
      : super(message, code: 'VALIDATION_FAILURE');
}

/// Failure for storage errors
class StorageFailure extends Failure {
  const StorageFailure([String message = 'Storage operation failed'])
      : super(message, code: 'STORAGE_FAILURE');
}

/// Failure for unexpected errors
class UnexpectedFailure extends Failure {
  const UnexpectedFailure([String message = 'An unexpected error occurred'])
      : super(message, code: 'UNEXPECTED_FAILURE');
}
