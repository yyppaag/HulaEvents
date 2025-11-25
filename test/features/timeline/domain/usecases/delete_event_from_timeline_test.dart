import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:hula_events/core/error/failures.dart';
import 'package:hula_events/features/timeline/domain/usecases/delete_event_from_timeline.dart';
import '../../../../fixtures/test_fixtures.dart';
import '../../../../helpers/test_helpers.dart';

void main() {
  late DeleteEventFromTimeline usecase;
  late MockTimelineRepository mockRepository;

  setUp(() {
    mockRepository = MockTimelineRepository();
    usecase = DeleteEventFromTimeline(mockRepository);
  });

  final tTimeline = TestFixtures.testTimeline1;
  const tTimelineId = 'timeline-1';
  const tEventId = 'event-1';

  group('DeleteEventFromTimeline', () {
    test('should delete event from timeline through the repository', () async {
      // arrange
      final updatedTimeline = tTimeline.copyWith(
        events: tTimeline.events.where((e) => e.id != tEventId).toList(),
      );
      when(() => mockRepository.deleteEventFromTimeline(tTimelineId, tEventId))
          .thenAnswer((_) async => Right(updatedTimeline));

      // act
      final result = await usecase(const DeleteEventFromTimelineParams(
        timelineId: tTimelineId,
        eventId: tEventId,
      ));

      // assert
      expect(result, Right(updatedTimeline));
      verify(() => mockRepository.deleteEventFromTimeline(tTimelineId, tEventId)).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return NotFoundFailure when timeline does not exist', () async {
      // arrange
      when(() => mockRepository.deleteEventFromTimeline(tTimelineId, tEventId))
          .thenAnswer((_) async => const Left(NotFoundFailure('Timeline not found')));

      // act
      final result = await usecase(const DeleteEventFromTimelineParams(
        timelineId: tTimelineId,
        eventId: tEventId,
      ));

      // assert
      expect(result, const Left(NotFoundFailure('Timeline not found')));
    });

    test('should return CacheFailure when deletion fails', () async {
      // arrange
      when(() => mockRepository.deleteEventFromTimeline(tTimelineId, tEventId))
          .thenAnswer((_) async => const Left(CacheFailure('Failed to delete')));

      // act
      final result = await usecase(const DeleteEventFromTimelineParams(
        timelineId: tTimelineId,
        eventId: tEventId,
      ));

      // assert
      expect(result, const Left(CacheFailure('Failed to delete')));
    });

    test('should succeed even if event does not exist in timeline', () async {
      // arrange
      const nonExistentEventId = 'non-existent-event';
      when(() => mockRepository.deleteEventFromTimeline(tTimelineId, nonExistentEventId))
          .thenAnswer((_) async => Right(tTimeline));

      // act
      final result = await usecase(const DeleteEventFromTimelineParams(
        timelineId: tTimelineId,
        eventId: nonExistentEventId,
      ));

      // assert
      expect(result.isRight(), true);
    });

    test('should pass correct ids to repository', () async {
      // arrange
      const differentTimelineId = 'different-timeline-id';
      const differentEventId = 'different-event-id';
      when(() => mockRepository.deleteEventFromTimeline(differentTimelineId, differentEventId))
          .thenAnswer((_) async => Right(tTimeline));

      // act
      await usecase(const DeleteEventFromTimelineParams(
        timelineId: differentTimelineId,
        eventId: differentEventId,
      ));

      // assert
      verify(() => mockRepository.deleteEventFromTimeline(differentTimelineId, differentEventId)).called(1);
    });
  });

  group('DeleteEventFromTimelineParams', () {
    test('should create params with timelineId and eventId', () {
      const params = DeleteEventFromTimelineParams(
        timelineId: 'timeline-id',
        eventId: 'event-id',
      );
      expect(params.timelineId, 'timeline-id');
      expect(params.eventId, 'event-id');
    });
  });
}
