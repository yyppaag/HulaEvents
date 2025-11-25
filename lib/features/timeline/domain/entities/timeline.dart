import 'package:equatable/equatable.dart';
import 'event_type.dart';
import 'timeline_event.dart';

/// Timeline collection entity
class Timeline extends Equatable {
  /// Timeline unique identifier
  final String id;

  /// Timeline name
  final String name;

  /// Timeline description
  final String description;

  /// Timeline category
  final EventType category;

  /// Events in the timeline
  final List<TimelineEvent> events;

  /// Created timestamp
  final DateTime createdAt;

  /// Updated timestamp
  final DateTime updatedAt;

  /// Cover image URL (optional)
  final String? coverImageUrl;

  /// Theme color (optional)
  final int? themeColor;

  const Timeline({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.events,
    required this.createdAt,
    required this.updatedAt,
    this.coverImageUrl,
    this.themeColor,
  });

  /// Copy with modified fields
  Timeline copyWith({
    String? id,
    String? name,
    String? description,
    EventType? category,
    List<TimelineEvent>? events,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? coverImageUrl,
    int? themeColor,
  }) {
    return Timeline(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      category: category ?? this.category,
      events: events ?? this.events,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      coverImageUrl: coverImageUrl ?? this.coverImageUrl,
      themeColor: themeColor ?? this.themeColor,
    );
  }

  /// Get events sorted by timestamp
  List<TimelineEvent> get sortedEvents {
    final sorted = List<TimelineEvent>.from(events);
    sorted.sort((a, b) => a.timestamp.compareTo(b.timestamp));
    return sorted;
  }

  /// Get total event count
  int get eventCount => events.length;

  /// Get duration in days
  int get durationInDays {
    if (events.isEmpty) return 0;
    final sorted = sortedEvents;
    final duration = sorted.last.timestamp.difference(sorted.first.timestamp);
    return duration.inDays;
  }

  /// Get earliest event time
  DateTime? get earliestEventTime {
    if (events.isEmpty) return null;
    return sortedEvents.first.timestamp;
  }

  /// Get latest event time
  DateTime? get latestEventTime {
    if (events.isEmpty) return null;
    return sortedEvents.last.timestamp;
  }

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        category,
        events,
        createdAt,
        updatedAt,
        coverImageUrl,
        themeColor,
      ];

  @override
  String toString() {
    return 'Timeline(id: $id, name: $name, category: $category, events: ${events.length})';
  }
}
