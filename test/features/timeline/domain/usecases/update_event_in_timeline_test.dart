import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:hula_events/core/error/failures.dart';
import 'package:hula_events/features/timeline/domain/usecases/update_event_in_timeline.dart';
import '../../../../fixtures/test_fixtures.dart';
import '../../../../helpers/test_helpers.dart';

void main() {
  late UpdateEventInTimeline usecase;
  late MockTimelineRepository mockRepository;

  setUpAll(() {
    registerFallbackValues();
  });

  setUp(() {
    mockRepository = MockTimelineRepository();
    usecase = UpdateEventInTimeline(mockRepository);
  });

  final tTimeline = TestFixtures.testTimeline1;
  final tEvent = TestFixtures.testEvent1;
  const tTimelineId = 'timeline-1';

  group('UpdateEventInTimeline', () {
    test('should update event in timeline through the repository', () async {
      // arrange
      final updatedEvent = tEvent.copyWith(title: 'Updated Title');
      when(() => mockRepository.updateEventInTimeline(tTimelineId, updatedEvent))
          .thenAnswer((_) async => Right(tTimeline));

      // act
      final result = await usecase(UpdateEventInTimelineParams(
        timelineId: tTimelineId,
        event: updatedEvent,
      ));

      // assert
      expect(result, Right(tTimeline));
      verify(() => mockRepository.updateEventInTimeline(tTimelineId, updatedEvent)).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return NotFoundFailure when timeline does not exist', () async {
      // arrange
      when(() => mockRepository.updateEventInTimeline(tTimelineId, tEvent))
          .thenAnswer((_) async => const Left(NotFoundFailure('Timeline not found')));

      // act
      final result = await usecase(UpdateEventInTimelineParams(
        timelineId: tTimelineId,
        event: tEvent,
      ));

      // assert
      expect(result, const Left(NotFoundFailure('Timeline not found')));
    });

    test('should return CacheFailure when update fails', () async {
      // arrange
      when(() => mockRepository.updateEventInTimeline(tTimelineId, tEvent))
          .thenAnswer((_) async => const Left(CacheFailure('Failed to update')));

      // act
      final result = await usecase(UpdateEventInTimelineParams(
        timelineId: tTimelineId,
        event: tEvent,
      ));

      // assert
      expect(result, const Left(CacheFailure('Failed to update')));
    });

    test('should update event importance flag', () async {
      // arrange
      final eventWithImportanceChanged = tEvent.copyWith(isImportant: !tEvent.isImportant);
      when(() => mockRepository.updateEventInTimeline(tTimelineId, eventWithImportanceChanged))
          .thenAnswer((_) async => Right(tTimeline));

      // act
      final result = await usecase(UpdateEventInTimelineParams(
        timelineId: tTimelineId,
        event: eventWithImportanceChanged,
      ));

      // assert
      expect(result.isRight(), true);
    });

    test('should update event tags', () async {
      // arrange
      final eventWithNewTags = tEvent.copyWith(tags: ['newTag1', 'newTag2']);
      when(() => mockRepository.updateEventInTimeline(tTimelineId, eventWithNewTags))
          .thenAnswer((_) async => Right(tTimeline));

      // act
      final result = await usecase(UpdateEventInTimelineParams(
        timelineId: tTimelineId,
        event: eventWithNewTags,
      ));

      // assert
      expect(result.isRight(), true);
    });
  });

  group('UpdateEventInTimelineParams', () {
    test('should create params with timelineId and event', () {
      final params = UpdateEventInTimelineParams(
        timelineId: 'id',
        event: tEvent,
      );
      expect(params.timelineId, 'id');
      expect(params.event, tEvent);
    });
  });
}
