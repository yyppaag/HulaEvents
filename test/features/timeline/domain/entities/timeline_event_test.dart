import 'package:flutter_test/flutter_test.dart';
import 'package:hula_events/features/timeline/domain/entities/event_type.dart';
import 'package:hula_events/features/timeline/domain/entities/timeline_event.dart';

void main() {
  group('TimelineEvent', () {
    late TimelineEvent event;

    setUp(() {
      event = TimelineEvent(
        id: 'test-id',
        title: 'Test Title',
        description: 'Test Description',
        timestamp: DateTime(2023, 6, 15, 10, 30),
        type: EventType.history,
        tags: ['tag1', 'tag2'],
        imageUrl: 'https://example.com/image.jpg',
        videoUrl: 'https://example.com/video.mp4',
        metadata: {'key': 'value'},
        color: 0xFF0000,
        isImportant: true,
      );
    });

    group('constructor', () {
      test('should create TimelineEvent with all properties', () {
        expect(event.id, 'test-id');
        expect(event.title, 'Test Title');
        expect(event.description, 'Test Description');
        expect(event.timestamp, DateTime(2023, 6, 15, 10, 30));
        expect(event.type, EventType.history);
        expect(event.tags, ['tag1', 'tag2']);
        expect(event.imageUrl, 'https://example.com/image.jpg');
        expect(event.videoUrl, 'https://example.com/video.mp4');
        expect(event.metadata, {'key': 'value'});
        expect(event.color, 0xFF0000);
        expect(event.isImportant, true);
      });

      test('should create TimelineEvent with default values', () {
        final minimalEvent = TimelineEvent(
          id: 'id',
          title: 'Title',
          description: 'Description',
          timestamp: DateTime(2023, 1, 1),
          type: EventType.custom,
        );

        expect(minimalEvent.tags, isEmpty);
        expect(minimalEvent.imageUrl, isNull);
        expect(minimalEvent.videoUrl, isNull);
        expect(minimalEvent.metadata, isNull);
        expect(minimalEvent.color, isNull);
        expect(minimalEvent.isImportant, false);
      });
    });

    group('copyWith', () {
      test('should copy with new id', () {
        final copied = event.copyWith(id: 'new-id');
        expect(copied.id, 'new-id');
        expect(copied.title, event.title);
      });

      test('should copy with new title', () {
        final copied = event.copyWith(title: 'New Title');
        expect(copied.title, 'New Title');
        expect(copied.id, event.id);
      });

      test('should copy with new description', () {
        final copied = event.copyWith(description: 'New Description');
        expect(copied.description, 'New Description');
      });

      test('should copy with new timestamp', () {
        final newTimestamp = DateTime(2024, 1, 1);
        final copied = event.copyWith(timestamp: newTimestamp);
        expect(copied.timestamp, newTimestamp);
      });

      test('should copy with new type', () {
        final copied = event.copyWith(type: EventType.movie);
        expect(copied.type, EventType.movie);
      });

      test('should copy with new tags', () {
        final copied = event.copyWith(tags: ['newTag']);
        expect(copied.tags, ['newTag']);
      });

      test('should copy with new isImportant', () {
        final copied = event.copyWith(isImportant: false);
        expect(copied.isImportant, false);
      });

      test('should return same values when no parameters provided', () {
        final copied = event.copyWith();
        expect(copied.id, event.id);
        expect(copied.title, event.title);
        expect(copied.description, event.description);
        expect(copied.timestamp, event.timestamp);
        expect(copied.type, event.type);
        expect(copied.tags, event.tags);
        expect(copied.isImportant, event.isImportant);
      });
    });

    group('equality', () {
      test('should be equal when all properties are the same', () {
        final event1 = TimelineEvent(
          id: 'id',
          title: 'Title',
          description: 'Description',
          timestamp: DateTime(2023, 1, 1),
          type: EventType.history,
        );

        final event2 = TimelineEvent(
          id: 'id',
          title: 'Title',
          description: 'Description',
          timestamp: DateTime(2023, 1, 1),
          type: EventType.history,
        );

        expect(event1, equals(event2));
      });

      test('should not be equal when id is different', () {
        final event1 = TimelineEvent(
          id: 'id1',
          title: 'Title',
          description: 'Description',
          timestamp: DateTime(2023, 1, 1),
          type: EventType.history,
        );

        final event2 = TimelineEvent(
          id: 'id2',
          title: 'Title',
          description: 'Description',
          timestamp: DateTime(2023, 1, 1),
          type: EventType.history,
        );

        expect(event1, isNot(equals(event2)));
      });

      test('should not be equal when title is different', () {
        final event1 = TimelineEvent(
          id: 'id',
          title: 'Title1',
          description: 'Description',
          timestamp: DateTime(2023, 1, 1),
          type: EventType.history,
        );

        final event2 = TimelineEvent(
          id: 'id',
          title: 'Title2',
          description: 'Description',
          timestamp: DateTime(2023, 1, 1),
          type: EventType.history,
        );

        expect(event1, isNot(equals(event2)));
      });
    });

    group('props', () {
      test('should include all properties in props', () {
        expect(event.props, [
          'test-id',
          'Test Title',
          'Test Description',
          DateTime(2023, 6, 15, 10, 30),
          EventType.history,
          ['tag1', 'tag2'],
          'https://example.com/image.jpg',
          'https://example.com/video.mp4',
          {'key': 'value'},
          0xFF0000,
          true,
        ]);
      });
    });

    group('toString', () {
      test('should return formatted string', () {
        final result = event.toString();
        expect(result, contains('TimelineEvent'));
        expect(result, contains('test-id'));
        expect(result, contains('Test Title'));
        expect(result, contains('history'));
      });
    });
  });
}
