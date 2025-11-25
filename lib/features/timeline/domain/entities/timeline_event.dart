import 'package:equatable/equatable.dart';
import 'event_type.dart';

/// Timeline event entity
class TimelineEvent extends Equatable {
  /// Event unique identifier
  final String id;

  /// Event title
  final String title;

  /// Event description
  final String description;

  /// Event timestamp
  final DateTime timestamp;

  /// Event type
  final EventType type;

  /// Event tags
  final List<String> tags;

  /// Image URL (optional)
  final String? imageUrl;

  /// Video URL (optional)
  final String? videoUrl;

  /// Extra metadata
  final Map<String, dynamic>? metadata;

  /// Event color (optional)
  final int? color;

  /// Whether this is an important event
  final bool isImportant;

  const TimelineEvent({
    required this.id,
    required this.title,
    required this.description,
    required this.timestamp,
    required this.type,
    this.tags = const [],
    this.imageUrl,
    this.videoUrl,
    this.metadata,
    this.color,
    this.isImportant = false,
  });

  /// Copy with modified fields
  TimelineEvent copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? timestamp,
    EventType? type,
    List<String>? tags,
    String? imageUrl,
    String? videoUrl,
    Map<String, dynamic>? metadata,
    int? color,
    bool? isImportant,
  }) {
    return TimelineEvent(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      timestamp: timestamp ?? this.timestamp,
      type: type ?? this.type,
      tags: tags ?? this.tags,
      imageUrl: imageUrl ?? this.imageUrl,
      videoUrl: videoUrl ?? this.videoUrl,
      metadata: metadata ?? this.metadata,
      color: color ?? this.color,
      isImportant: isImportant ?? this.isImportant,
    );
  }

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        timestamp,
        type,
        tags,
        imageUrl,
        videoUrl,
        metadata,
        color,
        isImportant,
      ];

  @override
  String toString() {
    return 'TimelineEvent(id: $id, title: $title, timestamp: $timestamp, type: $type)';
  }
}
