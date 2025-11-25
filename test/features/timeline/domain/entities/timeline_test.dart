import 'package:flutter_test/flutter_test.dart';
import 'package:hula_events/features/timeline/domain/entities/event_type.dart';
import 'package:hula_events/features/timeline/domain/entities/timeline.dart';
import 'package:hula_events/features/timeline/domain/entities/timeline_event.dart';

void main() {
  group('Timeline', () {
    late Timeline timeline;
    late List<TimelineEvent> events;

    setUp(() {
      events = [
        TimelineEvent(
          id: 'event-1',
          title: 'Event 1',
          description: 'First event',
          timestamp: DateTime(2023, 6, 15),
          type: EventType.history,
        ),
        TimelineEvent(
          id: 'event-2',
          title: 'Event 2',
          description: 'Second event',
          timestamp: DateTime(2023, 1, 1),
          type: EventType.history,
        ),
        TimelineEvent(
          id: 'event-3',
          title: 'Event 3',
          description: 'Third event',
          timestamp: DateTime(2023, 12, 31),
          type: EventType.history,
        ),
      ];

      timeline = Timeline(
        id: 'timeline-id',
        name: 'Test Timeline',
        description: 'Test Description',
        category: EventType.history,
        events: events,
        createdAt: DateTime(2023, 1, 1),
        updatedAt: DateTime(2023, 6, 1),
        coverImageUrl: 'https://example.com/cover.jpg',
        themeColor: 0xFF0000,
      );
    });

    group('constructor', () {
      test('should create Timeline with all properties', () {
        expect(timeline.id, 'timeline-id');
        expect(timeline.name, 'Test Timeline');
        expect(timeline.description, 'Test Description');
        expect(timeline.category, EventType.history);
        expect(timeline.events.length, 3);
        expect(timeline.createdAt, DateTime(2023, 1, 1));
        expect(timeline.updatedAt, DateTime(2023, 6, 1));
        expect(timeline.coverImageUrl, 'https://example.com/cover.jpg');
        expect(timeline.themeColor, 0xFF0000);
      });

      test('should create Timeline with default optional values', () {
        final minimalTimeline = Timeline(
          id: 'id',
          name: 'Name',
          description: 'Description',
          category: EventType.custom,
          events: [],
          createdAt: DateTime(2023, 1, 1),
          updatedAt: DateTime(2023, 1, 1),
        );

        expect(minimalTimeline.coverImageUrl, isNull);
        expect(minimalTimeline.themeColor, isNull);
      });
    });

    group('copyWith', () {
      test('should copy with new id', () {
        final copied = timeline.copyWith(id: 'new-id');
        expect(copied.id, 'new-id');
        expect(copied.name, timeline.name);
      });

      test('should copy with new name', () {
        final copied = timeline.copyWith(name: 'New Name');
        expect(copied.name, 'New Name');
        expect(copied.id, timeline.id);
      });

      test('should copy with new events', () {
        final newEvents = <TimelineEvent>[];
        final copied = timeline.copyWith(events: newEvents);
        expect(copied.events, isEmpty);
      });

      test('should copy with new category', () {
        final copied = timeline.copyWith(category: EventType.movie);
        expect(copied.category, EventType.movie);
      });

      test('should return same values when no parameters provided', () {
        final copied = timeline.copyWith();
        expect(copied.id, timeline.id);
        expect(copied.name, timeline.name);
        expect(copied.description, timeline.description);
        expect(copied.category, timeline.category);
        expect(copied.events.length, timeline.events.length);
      });
    });

    group('sortedEvents', () {
      test('should return events sorted by timestamp', () {
        final sorted = timeline.sortedEvents;

        expect(sorted.length, 3);
        expect(sorted[0].id, 'event-2'); // Jan 1
        expect(sorted[1].id, 'event-1'); // Jun 15
        expect(sorted[2].id, 'event-3'); // Dec 31
      });

      test('should return empty list for timeline with no events', () {
        final emptyTimeline = timeline.copyWith(events: []);
        expect(emptyTimeline.sortedEvents, isEmpty);
      });

      test('should not modify original events list', () {
        final originalOrder = timeline.events.map((e) => e.id).toList();
        timeline.sortedEvents;
        final afterOrder = timeline.events.map((e) => e.id).toList();
        expect(originalOrder, afterOrder);
      });
    });

    group('eventCount', () {
      test('should return correct count of events', () {
        expect(timeline.eventCount, 3);
      });

      test('should return 0 for empty timeline', () {
        final emptyTimeline = timeline.copyWith(events: []);
        expect(emptyTimeline.eventCount, 0);
      });
    });

    group('durationInDays', () {
      test('should return correct duration in days', () {
        // From Jan 1 to Dec 31 = 364 days
        expect(timeline.durationInDays, 364);
      });

      test('should return 0 for timeline with no events', () {
        final emptyTimeline = timeline.copyWith(events: []);
        expect(emptyTimeline.durationInDays, 0);
      });

      test('should return 0 for timeline with single event', () {
        final singleEventTimeline = timeline.copyWith(events: [events[0]]);
        expect(singleEventTimeline.durationInDays, 0);
      });
    });

    group('earliestEventTime', () {
      test('should return earliest event timestamp', () {
        expect(timeline.earliestEventTime, DateTime(2023, 1, 1));
      });

      test('should return null for empty timeline', () {
        final emptyTimeline = timeline.copyWith(events: []);
        expect(emptyTimeline.earliestEventTime, isNull);
      });
    });

    group('latestEventTime', () {
      test('should return latest event timestamp', () {
        expect(timeline.latestEventTime, DateTime(2023, 12, 31));
      });

      test('should return null for empty timeline', () {
        final emptyTimeline = timeline.copyWith(events: []);
        expect(emptyTimeline.latestEventTime, isNull);
      });
    });

    group('equality', () {
      test('should be equal when all properties are the same', () {
        final timeline1 = Timeline(
          id: 'id',
          name: 'Name',
          description: 'Description',
          category: EventType.history,
          events: [],
          createdAt: DateTime(2023, 1, 1),
          updatedAt: DateTime(2023, 1, 1),
        );

        final timeline2 = Timeline(
          id: 'id',
          name: 'Name',
          description: 'Description',
          category: EventType.history,
          events: [],
          createdAt: DateTime(2023, 1, 1),
          updatedAt: DateTime(2023, 1, 1),
        );

        expect(timeline1, equals(timeline2));
      });

      test('should not be equal when id is different', () {
        final timeline1 = Timeline(
          id: 'id1',
          name: 'Name',
          description: 'Description',
          category: EventType.history,
          events: [],
          createdAt: DateTime(2023, 1, 1),
          updatedAt: DateTime(2023, 1, 1),
        );

        final timeline2 = Timeline(
          id: 'id2',
          name: 'Name',
          description: 'Description',
          category: EventType.history,
          events: [],
          createdAt: DateTime(2023, 1, 1),
          updatedAt: DateTime(2023, 1, 1),
        );

        expect(timeline1, isNot(equals(timeline2)));
      });
    });

    group('props', () {
      test('should include all properties in props', () {
        final minimalTimeline = Timeline(
          id: 'id',
          name: 'Name',
          description: 'Description',
          category: EventType.history,
          events: [],
          createdAt: DateTime(2023, 1, 1),
          updatedAt: DateTime(2023, 1, 1),
        );

        expect(minimalTimeline.props.length, 9);
      });
    });

    group('toString', () {
      test('should return formatted string', () {
        final result = timeline.toString();
        expect(result, contains('Timeline'));
        expect(result, contains('timeline-id'));
        expect(result, contains('Test Timeline'));
        expect(result, contains('history'));
        expect(result, contains('3'));
      });
    });
  });
}
