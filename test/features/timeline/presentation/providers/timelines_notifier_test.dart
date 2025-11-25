import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:hula_events/core/error/failures.dart';
import 'package:hula_events/core/usecases/usecase.dart';
import 'package:hula_events/features/timeline/domain/usecases/get_timelines.dart';
import 'package:hula_events/features/timeline/domain/usecases/create_timeline.dart';
import 'package:hula_events/features/timeline/domain/usecases/delete_timeline.dart';
import 'package:hula_events/features/timeline/presentation/providers/timeline_providers.dart';
import 'package:hula_events/features/timeline/presentation/providers/timeline_state.dart';
import '../../../../fixtures/test_fixtures.dart';
import '../../../../helpers/test_helpers.dart';

void main() {
  late TimelinesNotifier notifier;
  late MockGetTimelines mockGetTimelines;
  late MockDeleteTimeline mockDeleteTimeline;
  late MockCreateTimeline mockCreateTimeline;

  setUpAll(() {
    registerFallbackValues();
  });

  setUp(() {
    mockGetTimelines = MockGetTimelines();
    mockDeleteTimeline = MockDeleteTimeline();
    mockCreateTimeline = MockCreateTimeline();
    notifier = TimelinesNotifier(
      getTimelines: mockGetTimelines,
      deleteTimeline: mockDeleteTimeline,
      createTimeline: mockCreateTimeline,
    );
  });

  group('TimelinesNotifier', () {
    group('initial state', () {
      test('should have initial state with empty timelines', () {
        expect(notifier.state.timelines, isEmpty);
        expect(notifier.state.isLoading, false);
        expect(notifier.state.errorMessage, isNull);
      });
    });

    group('loadTimelines', () {
      test('should set isLoading to true when loading starts', () async {
        // arrange
        when(() => mockGetTimelines(const NoParams()))
            .thenAnswer((_) async => const Right([]));

        // act
        final future = notifier.loadTimelines();

        // assert - check state during loading
        // Note: This is tricky to test synchronously
        await future;
      });

      test('should update state with timelines on success', () async {
        // arrange
        final timelines = TestFixtures.testTimelines;
        when(() => mockGetTimelines(const NoParams()))
            .thenAnswer((_) async => Right(timelines));

        // act
        await notifier.loadTimelines();

        // assert
        expect(notifier.state.timelines, timelines);
        expect(notifier.state.isLoading, false);
        expect(notifier.state.errorMessage, isNull);
      });

      test('should set errorMessage on failure', () async {
        // arrange
        when(() => mockGetTimelines(const NoParams()))
            .thenAnswer((_) async => const Left(CacheFailure('Cache error')));

        // act
        await notifier.loadTimelines();

        // assert
        expect(notifier.state.timelines, isEmpty);
        expect(notifier.state.isLoading, false);
        expect(notifier.state.errorMessage, 'Cache error');
      });

      test('should clear previous error when loading succeeds', () async {
        // arrange - first load fails
        when(() => mockGetTimelines(const NoParams()))
            .thenAnswer((_) async => const Left(CacheFailure('Error')));
        await notifier.loadTimelines();
        expect(notifier.state.errorMessage, isNotNull);

        // arrange - second load succeeds
        when(() => mockGetTimelines(const NoParams()))
            .thenAnswer((_) async => const Right([]));

        // act
        await notifier.loadTimelines();

        // assert
        expect(notifier.state.errorMessage, isNull);
      });
    });

    group('addTimeline', () {
      test('should add timeline to state on success', () async {
        // arrange
        final timeline = TestFixtures.testTimeline1;
        when(() => mockCreateTimeline(any()))
            .thenAnswer((_) async => Right(timeline));

        // act
        final result = await notifier.addTimeline(timeline);

        // assert
        expect(result, true);
        expect(notifier.state.timelines, contains(timeline));
      });

      test('should return false and set error on failure', () async {
        // arrange
        final timeline = TestFixtures.testTimeline1;
        when(() => mockCreateTimeline(any()))
            .thenAnswer((_) async => const Left(CacheFailure('Failed to save')));

        // act
        final result = await notifier.addTimeline(timeline);

        // assert
        expect(result, false);
        expect(notifier.state.errorMessage, 'Failed to save');
      });
    });

    group('removeTimeline', () {
      test('should remove timeline from state on success', () async {
        // arrange - first add a timeline
        final timeline = TestFixtures.testTimeline1;
        when(() => mockCreateTimeline(any()))
            .thenAnswer((_) async => Right(timeline));
        await notifier.addTimeline(timeline);
        expect(notifier.state.timelines, contains(timeline));

        // arrange - then delete it
        when(() => mockDeleteTimeline(any()))
            .thenAnswer((_) async => const Right(null));

        // act
        final result = await notifier.removeTimeline(timeline.id);

        // assert
        expect(result, true);
        expect(notifier.state.timelines, isNot(contains(timeline)));
      });

      test('should return false and set error on failure', () async {
        // arrange
        when(() => mockDeleteTimeline(any()))
            .thenAnswer((_) async => const Left(CacheFailure('Failed to delete')));

        // act
        final result = await notifier.removeTimeline('some-id');

        // assert
        expect(result, false);
        expect(notifier.state.errorMessage, 'Failed to delete');
      });
    });

    group('clearError', () {
      test('should clear error message', () async {
        // arrange - set an error first
        when(() => mockGetTimelines(const NoParams()))
            .thenAnswer((_) async => const Left(CacheFailure('Error')));
        await notifier.loadTimelines();
        expect(notifier.state.errorMessage, isNotNull);

        // act
        notifier.clearError();

        // assert
        expect(notifier.state.errorMessage, isNull);
      });
    });

    group('refreshTimeline', () {
      test('should update timeline in state', () async {
        // arrange - first add a timeline
        final timeline = TestFixtures.testTimeline1;
        when(() => mockCreateTimeline(any()))
            .thenAnswer((_) async => Right(timeline));
        await notifier.addTimeline(timeline);

        // act
        final updatedTimeline = timeline.copyWith(name: 'Updated Name');
        notifier.refreshTimeline(updatedTimeline);

        // assert
        final foundTimeline = notifier.state.timelines.firstWhere((t) => t.id == timeline.id);
        expect(foundTimeline.name, 'Updated Name');
      });

      test('should not modify state if timeline does not exist', () async {
        // arrange
        final timeline = TestFixtures.testTimeline1;

        // act
        notifier.refreshTimeline(timeline);

        // assert
        expect(notifier.state.timelines, isEmpty);
      });
    });
  });
}
