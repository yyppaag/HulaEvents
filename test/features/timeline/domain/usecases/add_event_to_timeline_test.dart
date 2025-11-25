import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:hula_events/core/error/failures.dart';
import 'package:hula_events/features/timeline/domain/usecases/add_event_to_timeline.dart';
import '../../../../fixtures/test_fixtures.dart';
import '../../../../helpers/test_helpers.dart';

void main() {
  late AddEventToTimeline usecase;
  late MockTimelineRepository mockRepository;

  setUpAll(() {
    registerFallbackValues();
  });

  setUp(() {
    mockRepository = MockTimelineRepository();
    usecase = AddEventToTimeline(mockRepository);
  });

  final tTimeline = TestFixtures.testTimeline1;
  final tEvent = TestFixtures.testEvent3;
  const tTimelineId = 'timeline-1';

  group('AddEventToTimeline', () {
    test('should add event to timeline through the repository', () async {
      // arrange
      final updatedTimeline = tTimeline.copyWith(
        events: [...tTimeline.events, tEvent],
      );
      when(() => mockRepository.addEventToTimeline(tTimelineId, tEvent))
          .thenAnswer((_) async => Right(updatedTimeline));

      // act
      final result = await usecase(AddEventToTimelineParams(
        timelineId: tTimelineId,
        event: tEvent,
      ));

      // assert
      expect(result, Right(updatedTimeline));
      verify(() => mockRepository.addEventToTimeline(tTimelineId, tEvent)).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return NotFoundFailure when timeline does not exist', () async {
      // arrange
      when(() => mockRepository.addEventToTimeline(tTimelineId, tEvent))
          .thenAnswer((_) async => const Left(NotFoundFailure('Timeline not found')));

      // act
      final result = await usecase(AddEventToTimelineParams(
        timelineId: tTimelineId,
        event: tEvent,
      ));

      // assert
      expect(result, const Left(NotFoundFailure('Timeline not found')));
    });

    test('should return CacheFailure when adding event fails', () async {
      // arrange
      when(() => mockRepository.addEventToTimeline(tTimelineId, tEvent))
          .thenAnswer((_) async => const Left(CacheFailure('Failed to add event')));

      // act
      final result = await usecase(AddEventToTimelineParams(
        timelineId: tTimelineId,
        event: tEvent,
      ));

      // assert
      expect(result, const Left(CacheFailure('Failed to add event')));
    });

    test('should add important event', () async {
      // arrange
      final importantEvent = tEvent.copyWith(isImportant: true);
      final updatedTimeline = tTimeline.copyWith(
        events: [...tTimeline.events, importantEvent],
      );
      when(() => mockRepository.addEventToTimeline(tTimelineId, importantEvent))
          .thenAnswer((_) async => Right(updatedTimeline));

      // act
      final result = await usecase(AddEventToTimelineParams(
        timelineId: tTimelineId,
        event: importantEvent,
      ));

      // assert
      expect(result.isRight(), true);
    });
  });

  group('AddEventToTimelineParams', () {
    test('should create params with timelineId and event', () {
      final params = AddEventToTimelineParams(
        timelineId: 'id',
        event: tEvent,
      );
      expect(params.timelineId, 'id');
      expect(params.event, tEvent);
    });
  });
}
