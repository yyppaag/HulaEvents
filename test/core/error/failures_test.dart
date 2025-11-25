import 'package:flutter_test/flutter_test.dart';
import 'package:hula_events/core/error/failures.dart';

void main() {
  group('Failure', () {
    group('CacheFailure', () {
      test('should have correct properties', () {
        const failure = CacheFailure('Cache operation failed');

        expect(failure.message, 'Cache operation failed');
        expect(failure.code, 'CACHE_FAILURE');
      });

      test('should have default message', () {
        const failure = CacheFailure();

        expect(failure.message, 'Cache operation failed');
      });

      test('should be equatable', () {
        const failure1 = CacheFailure('Error');
        const failure2 = CacheFailure('Error');
        const failure3 = CacheFailure('Different error');

        expect(failure1, equals(failure2));
        expect(failure1, isNot(equals(failure3)));
      });

      test('props should include message and code', () {
        const failure = CacheFailure('Error');

        expect(failure.props, ['Error', 'CACHE_FAILURE']);
      });
    });

    group('NotFoundFailure', () {
      test('should have correct properties', () {
        const failure = NotFoundFailure('Data not found');

        expect(failure.message, 'Data not found');
        expect(failure.code, 'NOT_FOUND');
      });

      test('should have default message', () {
        const failure = NotFoundFailure();

        expect(failure.message, 'Data not found');
      });

      test('should be equatable', () {
        const failure1 = NotFoundFailure('Not found');
        const failure2 = NotFoundFailure('Not found');

        expect(failure1, equals(failure2));
      });
    });

    group('ValidationFailure', () {
      test('should have correct properties', () {
        const failure = ValidationFailure('Validation failed');

        expect(failure.message, 'Validation failed');
        expect(failure.code, 'VALIDATION_FAILURE');
      });

      test('should have default message', () {
        const failure = ValidationFailure();

        expect(failure.message, 'Validation failed');
      });
    });

    group('StorageFailure', () {
      test('should have correct properties', () {
        const failure = StorageFailure('Storage operation failed');

        expect(failure.message, 'Storage operation failed');
        expect(failure.code, 'STORAGE_FAILURE');
      });

      test('should have default message', () {
        const failure = StorageFailure();

        expect(failure.message, 'Storage operation failed');
      });
    });

    group('UnexpectedFailure', () {
      test('should have correct properties', () {
        const failure = UnexpectedFailure('Unexpected error');

        expect(failure.message, 'Unexpected error');
        expect(failure.code, 'UNEXPECTED_FAILURE');
      });

      test('should have default message', () {
        const failure = UnexpectedFailure();

        expect(failure.message, 'An unexpected error occurred');
      });
    });
  });

  group('Failure inheritance', () {
    test('All failures should extend Failure', () {
      expect(const CacheFailure(), isA<Failure>());
      expect(const NotFoundFailure(), isA<Failure>());
      expect(const ValidationFailure(), isA<Failure>());
      expect(const StorageFailure(), isA<Failure>());
      expect(const UnexpectedFailure(), isA<Failure>());
    });
  });

  group('Failure equality', () {
    test('different failure types should not be equal', () {
      const cacheFailure = CacheFailure('Error');
      const notFoundFailure = NotFoundFailure('Error');

      expect(cacheFailure, isNot(equals(notFoundFailure)));
    });

    test('same failure type with same message should be equal', () {
      const failure1 = CacheFailure('Same error');
      const failure2 = CacheFailure('Same error');

      expect(failure1, equals(failure2));
      expect(failure1.hashCode, equals(failure2.hashCode));
    });

    test('same failure type with different message should not be equal', () {
      const failure1 = CacheFailure('Error 1');
      const failure2 = CacheFailure('Error 2');

      expect(failure1, isNot(equals(failure2)));
    });
  });

  group('Failure in collections', () {
    test('should work correctly in Set', () {
      final failures = <Failure>{
        const CacheFailure('Error 1'),
        const CacheFailure('Error 1'), // duplicate
        const CacheFailure('Error 2'),
        const NotFoundFailure('Not found'),
      };

      expect(failures.length, 3); // duplicates removed
    });

    test('should work correctly as Map key', () {
      final failureMap = <Failure, String>{
        const CacheFailure('Error'): 'Cache',
        const NotFoundFailure('Not found'): 'NotFound',
      };

      expect(failureMap[const CacheFailure('Error')], 'Cache');
      expect(failureMap[const NotFoundFailure('Not found')], 'NotFound');
    });
  });
}
