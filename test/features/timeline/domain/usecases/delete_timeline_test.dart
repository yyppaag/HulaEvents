import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:hula_events/core/error/failures.dart';
import 'package:hula_events/features/timeline/domain/usecases/delete_timeline.dart';
import '../../../../helpers/test_helpers.dart';

void main() {
  late DeleteTimeline usecase;
  late MockTimelineRepository mockRepository;

  setUp(() {
    mockRepository = MockTimelineRepository();
    usecase = DeleteTimeline(mockRepository);
  });

  const tId = 'timeline-1';

  group('DeleteTimeline', () {
    test('should delete timeline through the repository', () async {
      // arrange
      when(() => mockRepository.deleteTimeline(tId))
          .thenAnswer((_) async => const Right(null));

      // act
      final result = await usecase(const DeleteTimelineParams(id: tId));

      // assert
      expect(result, const Right(null));
      verify(() => mockRepository.deleteTimeline(tId)).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return NotFoundFailure when timeline does not exist', () async {
      // arrange
      when(() => mockRepository.deleteTimeline(tId))
          .thenAnswer((_) async => const Left(NotFoundFailure('Timeline not found')));

      // act
      final result = await usecase(const DeleteTimelineParams(id: tId));

      // assert
      expect(result, const Left(NotFoundFailure('Timeline not found')));
    });

    test('should return CacheFailure when deletion fails', () async {
      // arrange
      when(() => mockRepository.deleteTimeline(tId))
          .thenAnswer((_) async => const Left(CacheFailure('Deletion failed')));

      // act
      final result = await usecase(const DeleteTimelineParams(id: tId));

      // assert
      expect(result, const Left(CacheFailure('Deletion failed')));
    });

    test('should pass correct id to repository', () async {
      // arrange
      const differentId = 'different-id';
      when(() => mockRepository.deleteTimeline(differentId))
          .thenAnswer((_) async => const Right(null));

      // act
      await usecase(const DeleteTimelineParams(id: differentId));

      // assert
      verify(() => mockRepository.deleteTimeline(differentId)).called(1);
    });
  });

  group('DeleteTimelineParams', () {
    test('should create params with id', () {
      const params = DeleteTimelineParams(id: 'test-id');
      expect(params.id, 'test-id');
    });
  });
}
