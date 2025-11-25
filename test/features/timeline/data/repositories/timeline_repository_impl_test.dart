import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:hula_events/core/error/exceptions.dart';
import 'package:hula_events/core/error/failures.dart';
import 'package:hula_events/features/timeline/data/models/timeline_model.dart';
import 'package:hula_events/features/timeline/data/models/timeline_event_model.dart';
import 'package:hula_events/features/timeline/data/repositories/timeline_repository_impl.dart';
import '../../../../fixtures/test_fixtures.dart';
import '../../../../helpers/test_helpers.dart';

void main() {
  late TimelineRepositoryImpl repository;
  late MockTimelineLocalDataSource mockDataSource;

  setUpAll(() {
    registerFallbackValues();
  });

  setUp(() {
    mockDataSource = MockTimelineLocalDataSource();
    repository = TimelineRepositoryImpl(localDataSource: mockDataSource);
  });

  group('getTimelines', () {
    final tTimelineModels = TestFixtures.testTimelineModels;

    test('should return timelines from data source', () async {
      // arrange
      when(() => mockDataSource.getTimelines()).thenReturn(tTimelineModels);

      // act
      final result = await repository.getTimelines();

      // assert
      expect(result.isRight(), true);
      result.fold(
        (failure) => fail('Should not return failure'),
        (timelines) {
          expect(timelines.length, tTimelineModels.length);
        },
      );
      verify(() => mockDataSource.getTimelines()).called(1);
    });

    test('should return empty list when no timelines exist', () async {
      // arrange
      when(() => mockDataSource.getTimelines()).thenReturn([]);

      // act
      final result = await repository.getTimelines();

      // assert
      expect(result, const Right([]));
    });

    test('should return CacheFailure when data source throws CacheException', () async {
      // arrange
      when(() => mockDataSource.getTimelines()).thenThrow(const CacheException('Cache error'));

      // act
      final result = await repository.getTimelines();

      // assert
      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure, isA<CacheFailure>()),
        (timelines) => fail('Should not return timelines'),
      );
    });

    test('should return UnexpectedFailure when unexpected exception occurs', () async {
      // arrange
      when(() => mockDataSource.getTimelines()).thenThrow(Exception('Unexpected'));

      // act
      final result = await repository.getTimelines();

      // assert
      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure, isA<UnexpectedFailure>()),
        (timelines) => fail('Should not return timelines'),
      );
    });
  });

  group('getTimeline', () {
    final tTimelineModel = TestFixtures.testTimelineModel1;
    const tId = 'timeline-1';

    test('should return timeline from data source', () async {
      // arrange
      when(() => mockDataSource.getTimeline(tId)).thenReturn(tTimelineModel);

      // act
      final result = await repository.getTimeline(tId);

      // assert
      expect(result.isRight(), true);
      result.fold(
        (failure) => fail('Should not return failure'),
        (timeline) {
          expect(timeline.id, tTimelineModel.id);
        },
      );
      verify(() => mockDataSource.getTimeline(tId)).called(1);
    });

    test('should return NotFoundFailure when timeline does not exist', () async {
      // arrange
      when(() => mockDataSource.getTimeline(tId)).thenReturn(null);

      // act
      final result = await repository.getTimeline(tId);

      // assert
      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure, isA<NotFoundFailure>()),
        (timeline) => fail('Should not return timeline'),
      );
    });

    test('should return CacheFailure when data source throws CacheException', () async {
      // arrange
      when(() => mockDataSource.getTimeline(tId)).thenThrow(const CacheException('Cache error'));

      // act
      final result = await repository.getTimeline(tId);

      // assert
      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure, isA<CacheFailure>()),
        (timeline) => fail('Should not return timeline'),
      );
    });
  });

  group('createTimeline', () {
    final tTimeline = TestFixtures.testTimeline1;

    test('should save timeline to data source', () async {
      // arrange
      when(() => mockDataSource.saveTimeline(any())).thenAnswer((_) async {});

      // act
      final result = await repository.createTimeline(tTimeline);

      // assert
      expect(result.isRight(), true);
      result.fold(
        (failure) => fail('Should not return failure'),
        (timeline) {
          expect(timeline.id, tTimeline.id);
        },
      );
      verify(() => mockDataSource.saveTimeline(any())).called(1);
    });

    test('should return CacheFailure when saving fails', () async {
      // arrange
      when(() => mockDataSource.saveTimeline(any())).thenThrow(const CacheException('Save failed'));

      // act
      final result = await repository.createTimeline(tTimeline);

      // assert
      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure, isA<CacheFailure>()),
        (timeline) => fail('Should not return timeline'),
      );
    });
  });

  group('updateTimeline', () {
    final tTimeline = TestFixtures.testTimeline1;

    test('should update timeline in data source', () async {
      // arrange
      when(() => mockDataSource.updateTimeline(any())).thenAnswer((_) async {});

      // act
      final result = await repository.updateTimeline(tTimeline);

      // assert
      expect(result.isRight(), true);
      verify(() => mockDataSource.updateTimeline(any())).called(1);
    });

    test('should return CacheFailure when update fails', () async {
      // arrange
      when(() => mockDataSource.updateTimeline(any())).thenThrow(const CacheException('Update failed'));

      // act
      final result = await repository.updateTimeline(tTimeline);

      // assert
      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure, isA<CacheFailure>()),
        (timeline) => fail('Should not return timeline'),
      );
    });
  });

  group('deleteTimeline', () {
    const tId = 'timeline-1';

    test('should delete timeline from data source', () async {
      // arrange
      when(() => mockDataSource.deleteTimeline(tId)).thenAnswer((_) async {});

      // act
      final result = await repository.deleteTimeline(tId);

      // assert
      expect(result, const Right(null));
      verify(() => mockDataSource.deleteTimeline(tId)).called(1);
    });

    test('should return CacheFailure when deletion fails', () async {
      // arrange
      when(() => mockDataSource.deleteTimeline(tId)).thenThrow(const CacheException('Delete failed'));

      // act
      final result = await repository.deleteTimeline(tId);

      // assert
      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure, isA<CacheFailure>()),
        (_) => fail('Should not return success'),
      );
    });
  });

  group('addEventToTimeline', () {
    final tTimelineModel = TestFixtures.testTimelineModel1;
    final tEvent = TestFixtures.testEvent3;
    const tTimelineId = 'timeline-1';

    test('should add event to timeline', () async {
      // arrange
      when(() => mockDataSource.getTimeline(tTimelineId)).thenReturn(tTimelineModel);
      when(() => mockDataSource.saveTimeline(any())).thenAnswer((_) async {});

      // act
      final result = await repository.addEventToTimeline(tTimelineId, tEvent);

      // assert
      expect(result.isRight(), true);
      verify(() => mockDataSource.getTimeline(tTimelineId)).called(1);
      verify(() => mockDataSource.saveTimeline(any())).called(1);
    });

    test('should return NotFoundFailure when timeline does not exist', () async {
      // arrange
      when(() => mockDataSource.getTimeline(tTimelineId)).thenReturn(null);

      // act
      final result = await repository.addEventToTimeline(tTimelineId, tEvent);

      // assert
      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure, isA<NotFoundFailure>()),
        (timeline) => fail('Should not return timeline'),
      );
    });
  });

  group('updateEventInTimeline', () {
    final tTimelineModel = TestFixtures.testTimelineModel1;
    final tEvent = TestFixtures.testEvent1.copyWith(title: 'Updated');
    const tTimelineId = 'timeline-1';

    test('should update event in timeline', () async {
      // arrange
      when(() => mockDataSource.getTimeline(tTimelineId)).thenReturn(tTimelineModel);
      when(() => mockDataSource.saveTimeline(any())).thenAnswer((_) async {});

      // act
      final result = await repository.updateEventInTimeline(tTimelineId, tEvent);

      // assert
      expect(result.isRight(), true);
      verify(() => mockDataSource.getTimeline(tTimelineId)).called(1);
      verify(() => mockDataSource.saveTimeline(any())).called(1);
    });

    test('should return NotFoundFailure when timeline does not exist', () async {
      // arrange
      when(() => mockDataSource.getTimeline(tTimelineId)).thenReturn(null);

      // act
      final result = await repository.updateEventInTimeline(tTimelineId, tEvent);

      // assert
      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure, isA<NotFoundFailure>()),
        (timeline) => fail('Should not return timeline'),
      );
    });
  });

  group('deleteEventFromTimeline', () {
    final tTimelineModel = TestFixtures.testTimelineModel1;
    const tTimelineId = 'timeline-1';
    const tEventId = 'event-1';

    test('should delete event from timeline', () async {
      // arrange
      when(() => mockDataSource.getTimeline(tTimelineId)).thenReturn(tTimelineModel);
      when(() => mockDataSource.saveTimeline(any())).thenAnswer((_) async {});

      // act
      final result = await repository.deleteEventFromTimeline(tTimelineId, tEventId);

      // assert
      expect(result.isRight(), true);
      verify(() => mockDataSource.getTimeline(tTimelineId)).called(1);
      verify(() => mockDataSource.saveTimeline(any())).called(1);
    });

    test('should return NotFoundFailure when timeline does not exist', () async {
      // arrange
      when(() => mockDataSource.getTimeline(tTimelineId)).thenReturn(null);

      // act
      final result = await repository.deleteEventFromTimeline(tTimelineId, tEventId);

      // assert
      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure, isA<NotFoundFailure>()),
        (timeline) => fail('Should not return timeline'),
      );
    });
  });
}
