import 'package:flutter_test/flutter_test.dart';
import 'package:hula_events/core/error/exceptions.dart';

void main() {
  group('AppException', () {
    test('CacheException should have correct properties', () {
      const exception = CacheException('Cache operation failed');

      expect(exception.message, 'Cache operation failed');
      expect(exception.code, 'CACHE_ERROR');
    });

    test('CacheException should have default message', () {
      const exception = CacheException();

      expect(exception.message, 'Cache operation failed');
    });

    test('NotFoundException should have correct properties', () {
      const exception = NotFoundException('Data not found');

      expect(exception.message, 'Data not found');
      expect(exception.code, 'NOT_FOUND');
    });

    test('NotFoundException should have default message', () {
      const exception = NotFoundException();

      expect(exception.message, 'Data not found');
    });

    test('ValidationException should have correct properties', () {
      const exception = ValidationException('Validation failed');

      expect(exception.message, 'Validation failed');
      expect(exception.code, 'VALIDATION_ERROR');
    });

    test('ValidationException should have default message', () {
      const exception = ValidationException();

      expect(exception.message, 'Validation failed');
    });

    test('StorageException should have correct properties', () {
      const exception = StorageException('Storage operation failed');

      expect(exception.message, 'Storage operation failed');
      expect(exception.code, 'STORAGE_ERROR');
    });

    test('StorageException should have default message', () {
      const exception = StorageException();

      expect(exception.message, 'Storage operation failed');
    });

    test('UnexpectedException should have correct properties', () {
      const exception = UnexpectedException('Unexpected error');

      expect(exception.message, 'Unexpected error');
      expect(exception.code, 'UNEXPECTED_ERROR');
    });

    test('UnexpectedException should have default message', () {
      const exception = UnexpectedException();

      expect(exception.message, 'An unexpected error occurred');
    });
  });

  group('Exception toString', () {
    test('CacheException toString should include message', () {
      const exception = CacheException('Test message');

      expect(exception.toString(), contains('Test message'));
    });

    test('NotFoundException toString should include message', () {
      const exception = NotFoundException('Test message');

      expect(exception.toString(), contains('Test message'));
    });
  });

  group('Exception is Exception', () {
    test('CacheException should implement Exception', () {
      const exception = CacheException();

      expect(exception, isA<Exception>());
    });

    test('NotFoundException should implement Exception', () {
      const exception = NotFoundException();

      expect(exception, isA<Exception>());
    });

    test('ValidationException should implement Exception', () {
      const exception = ValidationException();

      expect(exception, isA<Exception>());
    });

    test('StorageException should implement Exception', () {
      const exception = StorageException();

      expect(exception, isA<Exception>());
    });

    test('UnexpectedException should implement Exception', () {
      const exception = UnexpectedException();

      expect(exception, isA<Exception>());
    });
  });

  group('Exception inheritance', () {
    test('All exceptions should be AppException', () {
      expect(const CacheException(), isA<AppException>());
      expect(const NotFoundException(), isA<AppException>());
      expect(const ValidationException(), isA<AppException>());
      expect(const StorageException(), isA<AppException>());
      expect(const UnexpectedException(), isA<AppException>());
    });
  });
}
