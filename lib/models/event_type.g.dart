// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event_type.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class EventTypeAdapter extends TypeAdapter<EventType> {
  @override
  final int typeId = 2;

  @override
  EventType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return EventType.history;
      case 1:
        return EventType.biography;
      case 2:
        return EventType.movie;
      case 3:
        return EventType.project;
      case 4:
        return EventType.custom;
      default:
        return EventType.custom;
    }
  }

  @override
  void write(BinaryWriter writer, EventType obj) {
    switch (obj) {
      case EventType.history:
        writer.writeByte(0);
        break;
      case EventType.biography:
        writer.writeByte(1);
        break;
      case EventType.movie:
        writer.writeByte(2);
        break;
      case EventType.project:
        writer.writeByte(3);
        break;
      case EventType.custom:
        writer.writeByte(4);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EventTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
