import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';
import 'event_type.dart';

part 'timeline_event.g.dart';

/// 时间线事件模型
@HiveType(typeId: 0)
@JsonSerializable()
class TimelineEvent extends Equatable {
  /// 事件唯一标识
  @HiveField(0)
  final String id;

  /// 事件标题
  @HiveField(1)
  final String title;

  /// 事件描述
  @HiveField(2)
  final String description;

  /// 事件时间戳
  @HiveField(3)
  final DateTime timestamp;

  /// 事件类型
  @HiveField(4)
  final EventType type;

  /// 事件标签
  @HiveField(5)
  final List<String> tags;

  /// 图片URL（可选）
  @HiveField(6)
  final String? imageUrl;

  /// 视频URL（可选）
  @HiveField(7)
  final String? videoUrl;

  /// 额外元数据
  @HiveField(8)
  final Map<String, dynamic>? metadata;

  /// 事件颜色（可选）
  @HiveField(9)
  final int? color;

  /// 是否为重要事件
  @HiveField(10)
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

  /// 从JSON创建对象
  factory TimelineEvent.fromJson(Map<String, dynamic> json) =>
      _$TimelineEventFromJson(json);

  /// 转换为JSON
  Map<String, dynamic> toJson() => _$TimelineEventToJson(this);

  /// 复制对象并修改部分字段
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
