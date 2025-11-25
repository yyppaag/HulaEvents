import 'package:flutter_test/flutter_test.dart';
import 'package:hula_events/features/timeline/data/models/timeline_event_model.dart';
import 'package:hula_events/features/timeline/domain/entities/event_type.dart';
import 'package:hula_events/features/timeline/domain/entities/timeline_event.dart';
import '../../../../fixtures/test_fixtures.dart';

void main() {
  group('TimelineEventModel', () {
    late TimelineEventModel model;

    setUp(() {
      model = TimelineEventModel(
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
      test('should create TimelineEventModel with all properties', () {
        expect(model.id, 'test-id');
        expect(model.title, 'Test Title');
        expect(model.description, 'Test Description');
        expect(model.timestamp, DateTime(2023, 6, 15, 10, 30));
        expect(model.type, EventType.history);
        expect(model.tags, ['tag1', 'tag2']);
        expect(model.imageUrl, 'https://example.com/image.jpg');
        expect(model.videoUrl, 'https://example.com/video.mp4');
        expect(model.metadata, {'key': 'value'});
        expect(model.color, 0xFF0000);
        expect(model.isImportant, true);
      });

      test('should create TimelineEventModel with default values', () {
        final minimalModel = TimelineEventModel(
          id: 'id',
          title: 'Title',
          description: 'Description',
          timestamp: DateTime(2023, 1, 1),
          type: EventType.custom,
        );

        expect(minimalModel.tags, isEmpty);
        expect(minimalModel.imageUrl, isNull);
        expect(minimalModel.videoUrl, isNull);
        expect(minimalModel.metadata, isNull);
        expect(minimalModel.color, isNull);
        expect(minimalModel.isImportant, false);
      });
    });

    group('fromEntity', () {
      test('should create model from entity', () {
        final entity = TestFixtures.testEvent1;
        final model = TimelineEventModel.fromEntity(entity);

        expect(model.id, entity.id);
        expect(model.title, entity.title);
        expect(model.description, entity.description);
        expect(model.timestamp, entity.timestamp);
        expect(model.type, entity.type);
        expect(model.tags, entity.tags);
        expect(model.isImportant, entity.isImportant);
      });

      test('should preserve all optional fields from entity', () {
        final entity = TimelineEvent(
          id: 'id',
          title: 'Title',
          description: 'Description',
          timestamp: DateTime(2023, 1, 1),
          type: EventType.history,
          imageUrl: 'image.jpg',
          videoUrl: 'video.mp4',
          metadata: {'meta': 'data'},
          color: 123456,
          isImportant: true,
        );

        final model = TimelineEventModel.fromEntity(entity);

        expect(model.imageUrl, 'image.jpg');
        expect(model.videoUrl, 'video.mp4');
        expect(model.metadata, {'meta': 'data'});
        expect(model.color, 123456);
      });
    });

    group('toEntity', () {
      test('should convert model to entity', () {
        final entity = model.toEntity();

        expect(entity, isA<TimelineEvent>());
        expect(entity.id, model.id);
        expect(entity.title, model.title);
        expect(entity.description, model.description);
        expect(entity.timestamp, model.timestamp);
        expect(entity.type, model.type);
        expect(entity.tags, model.tags);
        expect(entity.isImportant, model.isImportant);
      });

      test('should preserve optional fields when converting to entity', () {
        final entity = model.toEntity();

        expect(entity.imageUrl, model.imageUrl);
        expect(entity.videoUrl, model.videoUrl);
        expect(entity.metadata, model.metadata);
        expect(entity.color, model.color);
      });
    });

    group('round trip conversion', () {
      test('should maintain data integrity through entity -> model -> entity', () {
        final originalEntity = TestFixtures.testEvent1;
        final model = TimelineEventModel.fromEntity(originalEntity);
        final convertedEntity = model.toEntity();

        expect(convertedEntity.id, originalEntity.id);
        expect(convertedEntity.title, originalEntity.title);
        expect(convertedEntity.description, originalEntity.description);
        expect(convertedEntity.timestamp, originalEntity.timestamp);
        expect(convertedEntity.type, originalEntity.type);
        expect(convertedEntity.tags, originalEntity.tags);
        expect(convertedEntity.isImportant, originalEntity.isImportant);
      });
    });

    group('inheritance', () {
      test('should be a TimelineEvent', () {
        expect(model, isA<TimelineEvent>());
      });

      test('should be equatable', () {
        final model1 = TimelineEventModel(
          id: 'id',
          title: 'Title',
          description: 'Description',
          timestamp: DateTime(2023, 1, 1),
          type: EventType.history,
        );

        final model2 = TimelineEventModel(
          id: 'id',
          title: 'Title',
          description: 'Description',
          timestamp: DateTime(2023, 1, 1),
          type: EventType.history,
        );

        expect(model1, equals(model2));
      });
    });
  });
}
