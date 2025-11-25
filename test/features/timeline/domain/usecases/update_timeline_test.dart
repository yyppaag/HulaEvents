import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:hula_events/core/error/failures.dart';
import 'package:hula_events/features/timeline/domain/usecases/update_timeline.dart';
import '../../../../fixtures/test_fixtures.dart';
import '../../../../helpers/test_helpers.dart';

void main() {
  late UpdateTimeline usecase;
  late MockTimelineRepository mockRepository;

  setUpAll(() {
    registerFallbackValues();
  });

  setUp(() {
    mockRepository = MockTimelineRepository();
    usecase = UpdateTimeline(mockRepository);
  });

  final tTimeline = TestFixtures.testTimeline1;

  group('UpdateTimeline', () {
    test('should update timeline through the repository', () async {
      // arrange
      final updatedTimeline = tTimeline.copyWith(name: 'Updated Name');
      when(() => mockRepository.updateTimeline(updatedTimeline))
          .thenAnswer((_) async => Right(updatedTimeline));

      // act
      final result = await usecase(UpdateTimelineParams(timeline: updatedTimeline));

      // assert
      expect(result, Right(updatedTimeline));
      verify(() => mockRepository.updateTimeline(updatedTimeline)).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return NotFoundFailure when timeline does not exist', () async {
      // arrange
      when(() => mockRepository.updateTimeline(tTimeline))
          .thenAnswer((_) async => const Left(NotFoundFailure('Timeline not found')));

      // act
      final result = await usecase(UpdateTimelineParams(timeline: tTimeline));

      // assert
      expect(result, const Left(NotFoundFailure('Timeline not found')));
    });

    test('should return CacheFailure when update fails', () async {
      // arrange
      when(() => mockRepository.updateTimeline(tTimeline))
          .thenAnswer((_) async => const Left(CacheFailure('Update failed')));

      // act
      final result = await usecase(UpdateTimelineParams(timeline: tTimeline));

      // assert
      expect(result, const Left(CacheFailure('Update failed')));
    });

    test('should update timeline with new events', () async {
      // arrange
      final timelineWithNewEvents = tTimeline.copyWith(
        events: [...tTimeline.events, TestFixtures.testEvent3],
      );
      when(() => mockRepository.updateTimeline(timelineWithNewEvents))
          .thenAnswer((_) async => Right(timelineWithNewEvents));

      // act
      final result = await usecase(UpdateTimelineParams(timeline: timelineWithNewEvents));

      // assert
      expect(result, Right(timelineWithNewEvents));
    });
  });

  group('UpdateTimelineParams', () {
    test('should create params with timeline', () {
      final params = UpdateTimelineParams(timeline: tTimeline);
      expect(params.timeline, tTimeline);
    });
  });
}
