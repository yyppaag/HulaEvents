import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:hula_events/core/error/failures.dart';
import 'package:hula_events/features/timeline/domain/usecases/get_timeline.dart';
import '../../../../fixtures/test_fixtures.dart';
import '../../../../helpers/test_helpers.dart';

void main() {
  late GetTimeline usecase;
  late MockTimelineRepository mockRepository;

  setUp(() {
    mockRepository = MockTimelineRepository();
    usecase = GetTimeline(mockRepository);
  });

  final tTimeline = TestFixtures.testTimeline1;
  const tId = 'timeline-1';

  group('GetTimeline', () {
    test('should get timeline from the repository', () async {
      // arrange
      when(() => mockRepository.getTimeline(tId))
          .thenAnswer((_) async => Right(tTimeline));

      // act
      final result = await usecase(const GetTimelineParams(id: tId));

      // assert
      expect(result, Right(tTimeline));
      verify(() => mockRepository.getTimeline(tId)).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return NotFoundFailure when timeline does not exist', () async {
      // arrange
      when(() => mockRepository.getTimeline(tId))
          .thenAnswer((_) async => const Left(NotFoundFailure('Timeline not found')));

      // act
      final result = await usecase(const GetTimelineParams(id: tId));

      // assert
      expect(result, const Left(NotFoundFailure('Timeline not found')));
      verify(() => mockRepository.getTimeline(tId)).called(1);
    });

    test('should return CacheFailure when cache error occurs', () async {
      // arrange
      when(() => mockRepository.getTimeline(tId))
          .thenAnswer((_) async => const Left(CacheFailure('Cache error')));

      // act
      final result = await usecase(const GetTimelineParams(id: tId));

      // assert
      expect(result, const Left(CacheFailure('Cache error')));
    });

    test('should pass correct id to repository', () async {
      // arrange
      const differentId = 'different-id';
      when(() => mockRepository.getTimeline(differentId))
          .thenAnswer((_) async => const Left(NotFoundFailure()));

      // act
      await usecase(const GetTimelineParams(id: differentId));

      // assert
      verify(() => mockRepository.getTimeline(differentId)).called(1);
    });
  });

  group('GetTimelineParams', () {
    test('should create params with id', () {
      const params = GetTimelineParams(id: 'test-id');
      expect(params.id, 'test-id');
    });
  });
}
