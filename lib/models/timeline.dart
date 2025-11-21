import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';
import 'event_type.dart';
import 'timeline_event.dart';

part 'timeline.g.dart';

/// 时间线集合模型
@HiveType(typeId: 1)
@JsonSerializable()
class Timeline extends Equatable {
  /// 时间线唯一标识
  @HiveField(0)
  final String id;

  /// 时间线名称
  @HiveField(1)
  final String name;

  /// 时间线描述
  @HiveField(2)
  final String description;

  /// 时间线类别
  @HiveField(3)
  final EventType category;

  /// 时间线中的事件列表
  @HiveField(4)
  final List<TimelineEvent> events;

  /// 创建时间
  @HiveField(5)
  final DateTime createdAt;

  /// 更新时间
  @HiveField(6)
  final DateTime updatedAt;

  /// 封面图片URL（可选）
  @HiveField(7)
  final String? coverImageUrl;

  /// 主题颜色（可选）
  @HiveField(8)
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

  /// 从JSON创建对象
  factory Timeline.fromJson(Map<String, dynamic> json) =>
      _$TimelineFromJson(json);

  /// 转换为JSON
  Map<String, dynamic> toJson() => _$TimelineToJson(this);

  /// 复制对象并修改部分字段
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

  /// 获取按时间排序的事件列表
  List<TimelineEvent> get sortedEvents {
    final sorted = List<TimelineEvent>.from(events);
    sorted.sort((a, b) => a.timestamp.compareTo(b.timestamp));
    return sorted;
  }

  /// 获取事件总数
  int get eventCount => events.length;

  /// 获取时间线的时间跨度（天数）
  int get durationInDays {
    if (events.isEmpty) return 0;
    final sorted = sortedEvents;
    final duration = sorted.last.timestamp.difference(sorted.first.timestamp);
    return duration.inDays;
  }

  /// 获取最早的事件时间
  DateTime? get earliestEventTime {
    if (events.isEmpty) return null;
    return sortedEvents.first.timestamp;
  }

  /// 获取最晚的事件时间
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
