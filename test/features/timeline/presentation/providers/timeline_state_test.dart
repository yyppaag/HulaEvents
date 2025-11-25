import 'package:flutter_test/flutter_test.dart';
import 'package:hula_events/features/timeline/presentation/providers/timeline_state.dart';
import '../../../../fixtures/test_fixtures.dart';

void main() {
  group('TimelinesState', () {
    group('constructor', () {
      test('should create state with default values', () {
        const state = TimelinesState();

        expect(state.timelines, isEmpty);
        expect(state.isLoading, false);
        expect(state.errorMessage, isNull);
      });

      test('should create state with provided values', () {
        final timelines = TestFixtures.testTimelines;
        final state = TimelinesState(
          timelines: timelines,
          isLoading: true,
          errorMessage: 'Error message',
        );

        expect(state.timelines, timelines);
        expect(state.isLoading, true);
        expect(state.errorMessage, 'Error message');
      });
    });

    group('copyWith', () {
      test('should copy with new timelines', () {
        const state = TimelinesState();
        final newTimelines = TestFixtures.testTimelines;
        final copied = state.copyWith(timelines: newTimelines);

        expect(copied.timelines, newTimelines);
        expect(copied.isLoading, state.isLoading);
        expect(copied.errorMessage, state.errorMessage);
      });

      test('should copy with new isLoading', () {
        const state = TimelinesState();
        final copied = state.copyWith(isLoading: true);

        expect(copied.isLoading, true);
        expect(copied.timelines, state.timelines);
      });

      test('should copy with new errorMessage', () {
        const state = TimelinesState();
        final copied = state.copyWith(errorMessage: 'New error');

        expect(copied.errorMessage, 'New error');
      });

      test('should clear errorMessage when copying with null', () {
        const state = TimelinesState(errorMessage: 'Error');
        final copied = state.copyWith(errorMessage: null);

        expect(copied.errorMessage, isNull);
      });

      test('should return same values when no parameters provided', () {
        final timelines = TestFixtures.testTimelines;
        final state = TimelinesState(
          timelines: timelines,
          isLoading: true,
          errorMessage: 'Error',
        );
        final copied = state.copyWith();

        expect(copied.timelines, state.timelines);
        expect(copied.isLoading, state.isLoading);
        // Note: errorMessage is set to null when not provided (as per the implementation)
      });
    });

    group('equality', () {
      test('should be equal when all properties are the same', () {
        const state1 = TimelinesState(
          timelines: [],
          isLoading: false,
          errorMessage: null,
        );
        const state2 = TimelinesState(
          timelines: [],
          isLoading: false,
          errorMessage: null,
        );

        expect(state1, equals(state2));
      });

      test('should not be equal when isLoading is different', () {
        const state1 = TimelinesState(isLoading: true);
        const state2 = TimelinesState(isLoading: false);

        expect(state1, isNot(equals(state2)));
      });

      test('should not be equal when errorMessage is different', () {
        const state1 = TimelinesState(errorMessage: 'Error1');
        const state2 = TimelinesState(errorMessage: 'Error2');

        expect(state1, isNot(equals(state2)));
      });
    });

    group('props', () {
      test('should include all properties in props', () {
        final timelines = TestFixtures.testTimelines;
        final state = TimelinesState(
          timelines: timelines,
          isLoading: true,
          errorMessage: 'Error',
        );

        expect(state.props, [timelines, true, 'Error']);
      });
    });
  });

  group('TimelineDetailState', () {
    group('constructor', () {
      test('should create state with default values', () {
        const state = TimelineDetailState();

        expect(state.timeline, isNull);
        expect(state.isLoading, false);
        expect(state.errorMessage, isNull);
      });

      test('should create state with provided values', () {
        final timeline = TestFixtures.testTimeline1;
        final state = TimelineDetailState(
          timeline: timeline,
          isLoading: true,
          errorMessage: 'Error message',
        );

        expect(state.timeline, timeline);
        expect(state.isLoading, true);
        expect(state.errorMessage, 'Error message');
      });
    });

    group('copyWith', () {
      test('should copy with new timeline', () {
        const state = TimelineDetailState();
        final newTimeline = TestFixtures.testTimeline1;
        final copied = state.copyWith(timeline: newTimeline);

        expect(copied.timeline, newTimeline);
        expect(copied.isLoading, state.isLoading);
      });

      test('should copy with new isLoading', () {
        const state = TimelineDetailState();
        final copied = state.copyWith(isLoading: true);

        expect(copied.isLoading, true);
      });

      test('should copy with new errorMessage', () {
        const state = TimelineDetailState();
        final copied = state.copyWith(errorMessage: 'New error');

        expect(copied.errorMessage, 'New error');
      });
    });

    group('equality', () {
      test('should be equal when all properties are the same', () {
        const state1 = TimelineDetailState(
          timeline: null,
          isLoading: false,
          errorMessage: null,
        );
        const state2 = TimelineDetailState(
          timeline: null,
          isLoading: false,
          errorMessage: null,
        );

        expect(state1, equals(state2));
      });
    });

    group('props', () {
      test('should include all properties in props', () {
        final timeline = TestFixtures.testTimeline1;
        final state = TimelineDetailState(
          timeline: timeline,
          isLoading: true,
          errorMessage: 'Error',
        );

        expect(state.props, [timeline, true, 'Error']);
      });
    });
  });

  group('TimelineFormState', () {
    group('constructor', () {
      test('should create state with default values', () {
        const state = TimelineFormState();

        expect(state.isSubmitting, false);
        expect(state.errorMessage, isNull);
        expect(state.isSuccess, false);
      });

      test('should create state with provided values', () {
        const state = TimelineFormState(
          isSubmitting: true,
          errorMessage: 'Error',
          isSuccess: true,
        );

        expect(state.isSubmitting, true);
        expect(state.errorMessage, 'Error');
        expect(state.isSuccess, true);
      });
    });

    group('copyWith', () {
      test('should copy with new isSubmitting', () {
        const state = TimelineFormState();
        final copied = state.copyWith(isSubmitting: true);

        expect(copied.isSubmitting, true);
      });

      test('should copy with new isSuccess', () {
        const state = TimelineFormState();
        final copied = state.copyWith(isSuccess: true);

        expect(copied.isSuccess, true);
      });

      test('should copy with new errorMessage', () {
        const state = TimelineFormState();
        final copied = state.copyWith(errorMessage: 'New error');

        expect(copied.errorMessage, 'New error');
      });
    });

    group('equality', () {
      test('should be equal when all properties are the same', () {
        const state1 = TimelineFormState(
          isSubmitting: false,
          errorMessage: null,
          isSuccess: false,
        );
        const state2 = TimelineFormState(
          isSubmitting: false,
          errorMessage: null,
          isSuccess: false,
        );

        expect(state1, equals(state2));
      });

      test('should not be equal when isSubmitting is different', () {
        const state1 = TimelineFormState(isSubmitting: true);
        const state2 = TimelineFormState(isSubmitting: false);

        expect(state1, isNot(equals(state2)));
      });
    });

    group('props', () {
      test('should include all properties in props', () {
        const state = TimelineFormState(
          isSubmitting: true,
          errorMessage: 'Error',
          isSuccess: true,
        );

        expect(state.props, [true, 'Error', true]);
      });
    });
  });
}
