import 'package:flutter_test/flutter_test.dart';
import 'package:hula_events/features/timeline/data/models/timeline_model.dart';
import 'package:hula_events/features/timeline/data/models/timeline_event_model.dart';
import 'package:hula_events/features/timeline/domain/entities/event_type.dart';
import 'package:hula_events/features/timeline/domain/entities/timeline.dart';
import '../../../../fixtures/test_fixtures.dart';

void main() {
  group('TimelineModel', () {
    late TimelineModel model;
    late List<TimelineEventModel> eventModels;

    setUp(() {
      eventModels = [
        TestFixtures.testEventModel1,
        TestFixtures.testEventModel2,
      ];

      model = TimelineModel(
        id: 'timeline-id',
        name: 'Test Timeline',
        description: 'Test Description',
        category: EventType.history,
        eventModels: eventModels,
        createdAt: DateTime(2023, 1, 1),
        updatedAt: DateTime(2023, 6, 1),
        coverImageUrl: 'https://example.com/cover.jpg',
        themeColor: 0xFF0000,
      );
    });

    group('constructor', () {
      test('should create TimelineModel with all properties', () {
        expect(model.id, 'timeline-id');
        expect(model.name, 'Test Timeline');
        expect(model.description, 'Test Description');
        expect(model.category, EventType.history);
        expect(model.eventModels.length, 2);
        expect(model.createdAt, DateTime(2023, 1, 1));
        expect(model.updatedAt, DateTime(2023, 6, 1));
        expect(model.coverImageUrl, 'https://example.com/cover.jpg');
        expect(model.themeColor, 0xFF0000);
      });

      test('should create TimelineModel with default optional values', () {
        final minimalModel = TimelineModel(
          id: 'id',
          name: 'Name',
          description: 'Description',
          category: EventType.custom,
          eventModels: [],
          createdAt: DateTime(2023, 1, 1),
          updatedAt: DateTime(2023, 1, 1),
        );

        expect(minimalModel.coverImageUrl, isNull);
        expect(minimalModel.themeColor, isNull);
      });
    });

    group('fromEntity', () {
      test('should create model from entity', () {
        final entity = TestFixtures.testTimeline1;
        final model = TimelineModel.fromEntity(entity);

        expect(model.id, entity.id);
        expect(model.name, entity.name);
        expect(model.description, entity.description);
        expect(model.category, entity.category);
        expect(model.eventModels.length, entity.events.length);
        expect(model.createdAt, entity.createdAt);
        expect(model.updatedAt, entity.updatedAt);
      });

      test('should convert events to event models', () {
        final entity = TestFixtures.testTimeline1;
        final model = TimelineModel.fromEntity(entity);

        expect(model.eventModels, everyElement(isA<TimelineEventModel>()));
        expect(model.eventModels.length, entity.events.length);
      });

      test('should preserve optional fields from entity', () {
        final entity = Timeline(
          id: 'id',
          name: 'Name',
          description: 'Description',
          category: EventType.history,
          events: [],
          createdAt: DateTime(2023, 1, 1),
          updatedAt: DateTime(2023, 1, 1),
          coverImageUrl: 'cover.jpg',
          themeColor: 123456,
        );

        final model = TimelineModel.fromEntity(entity);

        expect(model.coverImageUrl, 'cover.jpg');
        expect(model.themeColor, 123456);
      });
    });

    group('toEntity', () {
      test('should convert model to entity', () {
        final entity = model.toEntity();

        expect(entity, isA<Timeline>());
        expect(entity.id, model.id);
        expect(entity.name, model.name);
        expect(entity.description, model.description);
        expect(entity.category, model.category);
        expect(entity.events.length, model.eventModels.length);
        expect(entity.createdAt, model.createdAt);
        expect(entity.updatedAt, model.updatedAt);
      });

      test('should convert event models to events', () {
        final entity = model.toEntity();

        expect(entity.events.length, model.eventModels.length);
        for (int i = 0; i < entity.events.length; i++) {
          expect(entity.events[i].id, model.eventModels[i].id);
        }
      });

      test('should preserve optional fields when converting to entity', () {
        final entity = model.toEntity();

        expect(entity.coverImageUrl, model.coverImageUrl);
        expect(entity.themeColor, model.themeColor);
      });
    });

    group('copyWithModel', () {
      test('should copy with new id', () {
        final copied = model.copyWithModel(id: 'new-id');
        expect(copied.id, 'new-id');
        expect(copied.name, model.name);
      });

      test('should copy with new name', () {
        final copied = model.copyWithModel(name: 'New Name');
        expect(copied.name, 'New Name');
        expect(copied.id, model.id);
      });

      test('should copy with new eventModels', () {
        final newEvents = <TimelineEventModel>[];
        final copied = model.copyWithModel(eventModels: newEvents);
        expect(copied.eventModels, isEmpty);
      });

      test('should copy with new updatedAt', () {
        final newDate = DateTime(2024, 1, 1);
        final copied = model.copyWithModel(updatedAt: newDate);
        expect(copied.updatedAt, newDate);
      });

      test('should return same values when no parameters provided', () {
        final copied = model.copyWithModel();
        expect(copied.id, model.id);
        expect(copied.name, model.name);
        expect(copied.description, model.description);
        expect(copied.category, model.category);
        expect(copied.eventModels.length, model.eventModels.length);
      });
    });

    group('round trip conversion', () {
      test('should maintain data integrity through entity -> model -> entity', () {
        final originalEntity = TestFixtures.testTimeline1;
        final model = TimelineModel.fromEntity(originalEntity);
        final convertedEntity = model.toEntity();

        expect(convertedEntity.id, originalEntity.id);
        expect(convertedEntity.name, originalEntity.name);
        expect(convertedEntity.description, originalEntity.description);
        expect(convertedEntity.category, originalEntity.category);
        expect(convertedEntity.events.length, originalEntity.events.length);
        expect(convertedEntity.createdAt, originalEntity.createdAt);
        expect(convertedEntity.updatedAt, originalEntity.updatedAt);
      });
    });

    group('inheritance', () {
      test('should be a Timeline', () {
        expect(model, isA<Timeline>());
      });

      test('should have access to Timeline computed properties', () {
        expect(model.eventCount, 2);
        expect(model.sortedEvents, isNotEmpty);
      });
    });

    group('events property', () {
      test('should provide events from eventModels converted to entities', () {
        expect(model.events.length, model.eventModels.length);
      });
    });
  });
}
