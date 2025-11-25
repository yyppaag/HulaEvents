import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/event_type.dart';
import '../../domain/entities/timeline.dart';
import '../../domain/entities/timeline_event.dart';
import 'timeline_event_model.dart';

part 'timeline_model.g.dart';

/// Timeline data model with Hive and JSON serialization
@HiveType(typeId: 1)
@JsonSerializable()
class TimelineModel extends Timeline {
  @override
  @HiveField(0)
  final String id;

  @override
  @HiveField(1)
  final String name;

  @override
  @HiveField(2)
  final String description;

  @override
  @HiveField(3)
  final EventType category;

  @HiveField(4)
  final List<TimelineEventModel> eventModels;

  @override
  @HiveField(5)
  final DateTime createdAt;

  @override
  @HiveField(6)
  final DateTime updatedAt;

  @override
  @HiveField(7)
  final String? coverImageUrl;

  @override
  @HiveField(8)
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
  factory TimelineModel.fromJson(Map<String, dynamic> json) =>
      _$TimelineModelFromJson(json);

  /// Convert to JSON
  Map<String, dynamic> toJson() => _$TimelineModelToJson(this);

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
