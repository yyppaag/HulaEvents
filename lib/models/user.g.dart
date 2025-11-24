// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SubscriptionTypeAdapter extends TypeAdapter<SubscriptionType> {
  @override
  final int typeId = 4;

  @override
  SubscriptionType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return SubscriptionType.free;
      case 1:
        return SubscriptionType.premium;
      case 2:
        return SubscriptionType.professional;
      default:
        return SubscriptionType.free;
    }
  }

  @override
  void write(BinaryWriter writer, SubscriptionType obj) {
    switch (obj) {
      case SubscriptionType.free:
        writer.writeByte(0);
        break;
      case SubscriptionType.premium:
        writer.writeByte(1);
        break;
      case SubscriptionType.professional:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SubscriptionTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class UserAdapter extends TypeAdapter<User> {
  @override
  final int typeId = 3;

  @override
  User read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return User(
      id: fields[0] as String,
      username: fields[1] as String,
      email: fields[2] as String,
      displayName: fields[3] as String?,
      avatarUrl: fields[4] as String?,
      subscriptionType: fields[5] as SubscriptionType,
      subscriptionExpiryDate: fields[6] as DateTime?,
      createdAt: fields[7] as DateTime,
      lastLoginAt: fields[8] as DateTime,
      timelineLimit: fields[9] as int?,
      eventLimit: fields[10] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, User obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.username)
      ..writeByte(2)
      ..write(obj.email)
      ..writeByte(3)
      ..write(obj.displayName)
      ..writeByte(4)
      ..write(obj.avatarUrl)
      ..writeByte(5)
      ..write(obj.subscriptionType)
      ..writeByte(6)
      ..write(obj.subscriptionExpiryDate)
      ..writeByte(7)
      ..write(obj.createdAt)
      ..writeByte(8)
      ..write(obj.lastLoginAt)
      ..writeByte(9)
      ..write(obj.timelineLimit)
      ..writeByte(10)
      ..write(obj.eventLimit);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
      id: json['id'] as String,
      username: json['username'] as String,
      email: json['email'] as String,
      displayName: json['displayName'] as String?,
      avatarUrl: json['avatarUrl'] as String?,
      subscriptionType: $enumDecodeNullable(
              _$SubscriptionTypeEnumMap, json['subscriptionType']) ??
          SubscriptionType.free,
      subscriptionExpiryDate: json['subscriptionExpiryDate'] == null
          ? null
          : DateTime.parse(json['subscriptionExpiryDate'] as String),
      createdAt: DateTime.parse(json['createdAt'] as String),
      lastLoginAt: DateTime.parse(json['lastLoginAt'] as String),
      timelineLimit: json['timelineLimit'] as int?,
      eventLimit: json['eventLimit'] as int?,
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'id': instance.id,
      'username': instance.username,
      'email': instance.email,
      'displayName': instance.displayName,
      'avatarUrl': instance.avatarUrl,
      'subscriptionType': _$SubscriptionTypeEnumMap[instance.subscriptionType]!,
      'subscriptionExpiryDate': instance.subscriptionExpiryDate?.toIso8601String(),
      'createdAt': instance.createdAt.toIso8601String(),
      'lastLoginAt': instance.lastLoginAt.toIso8601String(),
      'timelineLimit': instance.timelineLimit,
      'eventLimit': instance.eventLimit,
    };

const _$SubscriptionTypeEnumMap = {
  SubscriptionType.free: 'free',
  SubscriptionType.premium: 'premium',
  SubscriptionType.professional: 'professional',
};
