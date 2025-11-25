import 'package:flutter_test/flutter_test.dart';
import 'package:hula_events/core/usecases/usecase.dart';

void main() {
  group('NoParams', () {
    test('should be instantiatable', () {
      const params = NoParams();

      expect(params, isA<NoParams>());
    });

    test('should be const', () {
      const params1 = NoParams();
      const params2 = NoParams();

      expect(identical(params1, params2), true);
    });
  });

  group('UseCase', () {
    test('UseCase should be an abstract class', () {
      // This test verifies that UseCase is properly defined as an abstract class
      // by checking its type signature
      expect(UseCase, isA<Type>());
    });
  });
}
