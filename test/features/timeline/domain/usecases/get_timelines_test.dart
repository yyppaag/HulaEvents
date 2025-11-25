import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:hula_events/core/error/failures.dart';
import 'package:hula_events/core/usecases/usecase.dart';
import 'package:hula_events/features/timeline/domain/usecases/get_timelines.dart';
import '../../../../fixtures/test_fixtures.dart';
import '../../../../helpers/test_helpers.dart';

void main() {
  late GetTimelines usecase;
  late MockTimelineRepository mockRepository;

  setUp(() {
    mockRepository = MockTimelineRepository();
    usecase = GetTimelines(mockRepository);
  });

  final tTimelines = TestFixtures.testTimelines;

  group('GetTimelines', () {
    test('should get timelines from the repository', () async {
      // arrange
      when(() => mockRepository.getTimelines())
          .thenAnswer((_) async => Right(tTimelines));

      // act
      final result = await usecase(const NoParams());

      // assert
      expect(result, Right(tTimelines));
      verify(() => mockRepository.getTimelines()).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return empty list when no timelines exist', () async {
      // arrange
      when(() => mockRepository.getTimelines())
          .thenAnswer((_) async => const Right([]));

      // act
      final result = await usecase(const NoParams());

      // assert
      expect(result, const Right([]));
      verify(() => mockRepository.getTimelines()).called(1);
    });

    test('should return CacheFailure when repository fails', () async {
      // arrange
      when(() => mockRepository.getTimelines())
          .thenAnswer((_) async => const Left(CacheFailure('Cache error')));

      // act
      final result = await usecase(const NoParams());

      // assert
      expect(result, const Left(CacheFailure('Cache error')));
      verify(() => mockRepository.getTimelines()).called(1);
    });

    test('should return UnexpectedFailure when unexpected error occurs', () async {
      // arrange
      when(() => mockRepository.getTimelines())
          .thenAnswer((_) async => const Left(UnexpectedFailure('Unexpected error')));

      // act
      final result = await usecase(const NoParams());

      // assert
      expect(result, const Left(UnexpectedFailure('Unexpected error')));
    });
  });
}
