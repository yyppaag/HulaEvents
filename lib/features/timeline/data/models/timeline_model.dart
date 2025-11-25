import 'package:hive/hive.dart';
import '../../domain/entities/event_type.dart';
import '../../domain/entities/timeline.dart';
import 'timeline_event_model.dart';

/// Timeline data model with Hive serialization
class TimelineModel extends Timeline {
  @override
  final String id;

  @override
  final String name;

  @override
  final String description;

  @override
  final EventType category;

  final List<TimelineEventModel> eventModels;

  @override
  final DateTime createdAt;

  @override
  final DateTime updatedAt;

  @override
  final String? coverImageUrl;

  @override
  final int? themeColor;

  TimelineModel({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.eventModels,
    required this.createdAt,
    required this.updatedAt,
    this.coverImageUrl,
    this.themeColor,
  }) : super(
          id: id,
          name: name,
          description: description,
          category: category,
          events: eventModels.map((e) => e.toEntity()).toList(),
          createdAt: createdAt,
          updatedAt: updatedAt,
          coverImageUrl: coverImageUrl,
          themeColor: themeColor,
        );

  /// Create from JSON
  factory TimelineModel.fromJson(Map<String, dynamic> json) {
    return TimelineModel(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      category: EventType.fromString(json['category'] as String),
      eventModels: (json['events'] as List<dynamic>?)
              ?.map((e) => TimelineEventModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      coverImageUrl: json['coverImageUrl'] as String?,
      themeColor: json['themeColor'] as int?,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'category': category.name,
      'events': eventModels.map((e) => e.toJson()).toList(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'coverImageUrl': coverImageUrl,
      'themeColor': themeColor,
    };
  }

  /// Create from entity
  factory TimelineModel.fromEntity(Timeline entity) {
    return TimelineModel(
      id: entity.id,
      name: entity.name,
      description: entity.description,
      category: entity.category,
      eventModels: entity.events
          .map((e) => TimelineEventModel.fromEntity(e))
          .toList(),
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
      coverImageUrl: entity.coverImageUrl,
      themeColor: entity.themeColor,
    );
  }

  /// Convert to entity
  Timeline toEntity() {
    return Timeline(
      id: id,
      name: name,
      description: description,
      category: category,
      events: eventModels.map((e) => e.toEntity()).toList(),
      createdAt: createdAt,
      updatedAt: updatedAt,
      coverImageUrl: coverImageUrl,
      themeColor: themeColor,
    );
  }

  /// Copy with modified fields
  TimelineModel copyWithModel({
    String? id,
    String? name,
    String? description,
    EventType? category,
    List<TimelineEventModel>? eventModels,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? coverImageUrl,
    int? themeColor,
  }) {
    return TimelineModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      category: category ?? this.category,
      eventModels: eventModels ?? this.eventModels,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      coverImageUrl: coverImageUrl ?? this.coverImageUrl,
      themeColor: themeColor ?? this.themeColor,
    );
  }
}

/// Hive adapter for TimelineModel
class TimelineModelAdapter extends TypeAdapter<TimelineModel> {
  @override
  final int typeId = 1;

  @override
  TimelineModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TimelineModel(
      id: fields[0] as String,
      name: fields[1] as String,
      description: fields[2] as String,
      category: fields[3] as EventType,
      eventModels: (fields[4] as List).cast<TimelineEventModel>(),
      createdAt: fields[5] as DateTime,
      updatedAt: fields[6] as DateTime,
      coverImageUrl: fields[7] as String?,
      themeColor: fields[8] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, TimelineModel obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.category)
      ..writeByte(4)
      ..write(obj.eventModels)
      ..writeByte(5)
      ..write(obj.createdAt)
      ..writeByte(6)
      ..write(obj.updatedAt)
      ..writeByte(7)
      ..write(obj.coverImageUrl)
      ..writeByte(8)
      ..write(obj.themeColor);
  }
}
