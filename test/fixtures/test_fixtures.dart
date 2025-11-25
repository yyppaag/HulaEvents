import 'package:hula_events/features/timeline/domain/entities/event_type.dart';
import 'package:hula_events/features/timeline/domain/entities/timeline.dart';
import 'package:hula_events/features/timeline/domain/entities/timeline_event.dart';
import 'package:hula_events/features/timeline/data/models/timeline_model.dart';
import 'package:hula_events/features/timeline/data/models/timeline_event_model.dart';

/// Test fixtures for unit tests
class TestFixtures {
  // ============================================================================
  // Timeline Event Fixtures
  // ============================================================================

  static TimelineEvent get testEvent1 => TimelineEvent(
        id: 'event-1',
        title: 'Test Event 1',
        description: 'Description for test event 1',
        timestamp: DateTime(2023, 1, 15),
        type: EventType.history,
        tags: ['tag1', 'tag2'],
        isImportant: true,
      );

  static TimelineEvent get testEvent2 => TimelineEvent(
        id: 'event-2',
        title: 'Test Event 2',
        description: 'Description for test event 2',
        timestamp: DateTime(2023, 6, 20),
        type: EventType.biography,
        tags: ['tag3'],
        isImportant: false,
      );

  static TimelineEvent get testEvent3 => TimelineEvent(
        id: 'event-3',
        title: 'Test Event 3',
        description: 'Description for test event 3',
        timestamp: DateTime(2023, 12, 25),
        type: EventType.movie,
        tags: [],
        isImportant: true,
      );

  static List<TimelineEvent> get testEvents => [testEvent1, testEvent2, testEvent3];

  // ============================================================================
  // Timeline Fixtures
  // ============================================================================

  static Timeline get testTimeline1 => Timeline(
        id: 'timeline-1',
        name: 'Test Timeline 1',
        description: 'Description for test timeline 1',
        category: EventType.history,
        events: [testEvent1, testEvent2],
        createdAt: DateTime(2023, 1, 1),
        updatedAt: DateTime(2023, 1, 10),
      );

  static Timeline get testTimeline2 => Timeline(
        id: 'timeline-2',
        name: 'Test Timeline 2',
        description: 'Description for test timeline 2',
        category: EventType.biography,
        events: [testEvent3],
        createdAt: DateTime(2023, 2, 1),
        updatedAt: DateTime(2023, 2, 15),
      );

  static Timeline get emptyTimeline => Timeline(
        id: 'timeline-empty',
        name: 'Empty Timeline',
        description: 'Timeline with no events',
        category: EventType.custom,
        events: [],
        createdAt: DateTime(2023, 3, 1),
        updatedAt: DateTime(2023, 3, 1),
      );

  static List<Timeline> get testTimelines => [testTimeline1, testTimeline2];

  // ============================================================================
  // Model Fixtures
  // ============================================================================

  static TimelineEventModel get testEventModel1 => TimelineEventModel(
        id: 'event-1',
        title: 'Test Event 1',
        description: 'Description for test event 1',
        timestamp: DateTime(2023, 1, 15),
        type: EventType.history,
        tags: ['tag1', 'tag2'],
        isImportant: true,
      );

  static TimelineEventModel get testEventModel2 => TimelineEventModel(
        id: 'event-2',
        title: 'Test Event 2',
        description: 'Description for test event 2',
        timestamp: DateTime(2023, 6, 20),
        type: EventType.biography,
        tags: ['tag3'],
        isImportant: false,
      );

  static TimelineModel get testTimelineModel1 => TimelineModel(
        id: 'timeline-1',
        name: 'Test Timeline 1',
        description: 'Description for test timeline 1',
        category: EventType.history,
        eventModels: [testEventModel1, testEventModel2],
        createdAt: DateTime(2023, 1, 1),
        updatedAt: DateTime(2023, 1, 10),
      );

  static TimelineModel get testTimelineModel2 => TimelineModel(
        id: 'timeline-2',
        name: 'Test Timeline 2',
        description: 'Description for test timeline 2',
        category: EventType.biography,
        eventModels: [],
        createdAt: DateTime(2023, 2, 1),
        updatedAt: DateTime(2023, 2, 15),
      );

  static List<TimelineModel> get testTimelineModels => [testTimelineModel1, testTimelineModel2];
}
