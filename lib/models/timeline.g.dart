// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'timeline.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TimelineAdapter extends TypeAdapter<Timeline> {
  @override
  final int typeId = 1;

  @override
  Timeline read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Timeline(
      id: fields[0] as String,
      name: fields[1] as String,
      description: fields[2] as String,
      category: fields[3] as EventType,
      events: (fields[4] as List).cast<TimelineEvent>(),
      createdAt: fields[5] as DateTime,
      updatedAt: fields[6] as DateTime,
      coverImageUrl: fields[7] as String?,
      themeColor: fields[8] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, Timeline obj) {
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
      ..write(obj.events)
      ..writeByte(5)
      ..write(obj.createdAt)
      ..writeByte(6)
      ..write(obj.updatedAt)
      ..writeByte(7)
      ..write(obj.coverImageUrl)
      ..writeByte(8)
      ..write(obj.themeColor);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TimelineAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Timeline _$TimelineFromJson(Map<String, dynamic> json) => Timeline(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      category: $enumDecode(_$EventTypeEnumMap, json['category']),
      events: (json['events'] as List<dynamic>)
          .map((e) => TimelineEvent.fromJson(e as Map<String, dynamic>))
          .toList(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      coverImageUrl: json['coverImageUrl'] as String?,
      themeColor: json['themeColor'] as int?,
    );

Map<String, dynamic> _$TimelineToJson(Timeline instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'category': _$EventTypeEnumMap[instance.category]!,
      'events': instance.events.map((e) => e.toJson()).toList(),
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'coverImageUrl': instance.coverImageUrl,
      'themeColor': instance.themeColor,
    };

const _$EventTypeEnumMap = {
  EventType.history: 'history',
  EventType.biography: 'biography',
  EventType.movie: 'movie',
  EventType.project: 'project',
  EventType.custom: 'custom',
};
