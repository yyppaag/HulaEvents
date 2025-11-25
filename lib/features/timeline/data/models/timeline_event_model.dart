import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/event_type.dart';
import '../../domain/entities/timeline_event.dart';

part 'timeline_event_model.g.dart';

/// Timeline event data model with Hive and JSON serialization
@HiveType(typeId: 0)
@JsonSerializable()
class TimelineEventModel extends TimelineEvent {
  @override
  @HiveField(0)
  final String id;

  @override
  @HiveField(1)
  final String title;

  @override
  @HiveField(2)
  final String description;

  @override
  @HiveField(3)
  final DateTime timestamp;

  @override
  @HiveField(4)
  final EventType type;

  @override
  @HiveField(5)
  final List<String> tags;

  @override
  @HiveField(6)
  final String? imageUrl;

  @override
  @HiveField(7)
  final String? videoUrl;

  @override
  @HiveField(8)
  final Map<String, dynamic>? metadata;

  @override
  @HiveField(9)
  final int? color;

  @override
  @HiveField(10)
  final bool isImportant;

  const TimelineEventModel({
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
  }) : super(
          id: id,
          title: title,
          description: description,
          timestamp: timestamp,
          type: type,
          tags: tags,
          imageUrl: imageUrl,
          videoUrl: videoUrl,
          metadata: metadata,
          color: color,
          isImportant: isImportant,
        );

  /// Create from JSON
  factory TimelineEventModel.fromJson(Map<String, dynamic> json) =>
      _$TimelineEventModelFromJson(json);

  /// Convert to JSON
  Map<String, dynamic> toJson() => _$TimelineEventModelToJson(this);

  /// Create from entity
  factory TimelineEventModel.fromEntity(TimelineEvent entity) {
    return TimelineEventModel(
      id: entity.id,
      title: entity.title,
      description: entity.description,
      timestamp: entity.timestamp,
      type: entity.type,
      tags: entity.tags,
      imageUrl: entity.imageUrl,
      videoUrl: entity.videoUrl,
      metadata: entity.metadata,
      color: entity.color,
      isImportant: entity.isImportant,
    );
  }

  /// Convert to entity
  TimelineEvent toEntity() {
    return TimelineEvent(
      id: id,
      title: title,
      description: description,
      timestamp: timestamp,
      type: type,
      tags: tags,
      imageUrl: imageUrl,
      videoUrl: videoUrl,
      metadata: metadata,
      color: color,
      isImportant: isImportant,
    );
  }
}
