import 'package:hive/hive.dart';
import '../../domain/entities/event_type.dart';
import '../../domain/entities/timeline_event.dart';

/// Timeline event data model with Hive serialization
class TimelineEventModel extends TimelineEvent {
  @override
  final String id;

  @override
  final String title;

  @override
  final String description;

  @override
  final DateTime timestamp;

  @override
  final EventType type;

  @override
  final List<String> tags;

  @override
  final String? imageUrl;

  @override
  final String? videoUrl;

  @override
  final Map<String, dynamic>? metadata;

  @override
  final int? color;

  @override
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
  factory TimelineEventModel.fromJson(Map<String, dynamic> json) {
    return TimelineEventModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      type: EventType.fromString(json['type'] as String),
      tags: (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ?? [],
      imageUrl: json['imageUrl'] as String?,
      videoUrl: json['videoUrl'] as String?,
      metadata: json['metadata'] as Map<String, dynamic>?,
      color: json['color'] as int?,
      isImportant: json['isImportant'] as bool? ?? false,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'timestamp': timestamp.toIso8601String(),
      'type': type.name,
      'tags': tags,
      'imageUrl': imageUrl,
      'videoUrl': videoUrl,
      'metadata': metadata,
      'color': color,
      'isImportant': isImportant,
    };
  }

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

/// Hive adapter for TimelineEventModel
class TimelineEventModelAdapter extends TypeAdapter<TimelineEventModel> {
  @override
  final int typeId = 0;

  @override
  TimelineEventModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TimelineEventModel(
      id: fields[0] as String,
      title: fields[1] as String,
      description: fields[2] as String,
      timestamp: fields[3] as DateTime,
      type: fields[4] as EventType,
      tags: (fields[5] as List).cast<String>(),
      imageUrl: fields[6] as String?,
      videoUrl: fields[7] as String?,
      metadata: (fields[8] as Map?)?.cast<String, dynamic>(),
      color: fields[9] as int?,
      isImportant: fields[10] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, TimelineEventModel obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.timestamp)
      ..writeByte(4)
      ..write(obj.type)
      ..writeByte(5)
      ..write(obj.tags)
      ..writeByte(6)
      ..write(obj.imageUrl)
      ..writeByte(7)
      ..write(obj.videoUrl)
      ..writeByte(8)
      ..write(obj.metadata)
      ..writeByte(9)
      ..write(obj.color)
      ..writeByte(10)
      ..write(obj.isImportant);
  }
}
