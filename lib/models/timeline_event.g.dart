// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'timeline_event.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TimelineEventAdapter extends TypeAdapter<TimelineEvent> {
  @override
  final int typeId = 0;

  @override
  TimelineEvent read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TimelineEvent(
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
  void write(BinaryWriter writer, TimelineEvent obj) {
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

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TimelineEventAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TimelineEvent _$TimelineEventFromJson(Map<String, dynamic> json) =>
    TimelineEvent(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      type: $enumDecode(_$EventTypeEnumMap, json['type']),
      tags: (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ??
          const [],
      imageUrl: json['imageUrl'] as String?,
      videoUrl: json['videoUrl'] as String?,
      metadata: json['metadata'] as Map<String, dynamic>?,
      color: json['color'] as int?,
      isImportant: json['isImportant'] as bool? ?? false,
    );

Map<String, dynamic> _$TimelineEventToJson(TimelineEvent instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'timestamp': instance.timestamp.toIso8601String(),
      'type': _$EventTypeEnumMap[instance.type]!,
      'tags': instance.tags,
      'imageUrl': instance.imageUrl,
      'videoUrl': instance.videoUrl,
      'metadata': instance.metadata,
      'color': instance.color,
      'isImportant': instance.isImportant,
    };

const _$EventTypeEnumMap = {
  EventType.history: 'history',
  EventType.biography: 'biography',
  EventType.movie: 'movie',
  EventType.project: 'project',
  EventType.custom: 'custom',
};
