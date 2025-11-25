import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';

part 'user.g.dart';

/// 用户订阅类型
@HiveType(typeId: 4)
enum SubscriptionType {
  @HiveField(0)
  free,
  @HiveField(1)
  premium,
  @HiveField(2)
  professional,
}

/// 用户模型
@HiveType(typeId: 3)
@JsonSerializable()
class User extends Equatable {
  /// 用户唯一标识
  @HiveField(0)
  final String id;

  /// 用户名
  @HiveField(1)
  final String username;

  /// 邮箱
  @HiveField(2)
  final String email;

  /// 显示名称
  @HiveField(3)
  final String? displayName;

  /// 头像URL
  @HiveField(4)
  final String? avatarUrl;

  /// 订阅类型
  @HiveField(5)
  final SubscriptionType subscriptionType;

  /// 订阅到期时间
  @HiveField(6)
  final DateTime? subscriptionExpiryDate;

  /// 创建时间
  @HiveField(7)
  final DateTime createdAt;

  /// 最后登录时间
  @HiveField(8)
  final DateTime lastLoginAt;

  /// 时间线数量限制（免费版限制）
  @HiveField(9)
  final int? timelineLimit;

  /// 事件数量限制（每条时间线）
  @HiveField(10)
  final int? eventLimit;

  const User({
    required this.id,
    required this.username,
    required this.email,
    this.displayName,
    this.avatarUrl,
    this.subscriptionType = SubscriptionType.free,
    this.subscriptionExpiryDate,
    required this.createdAt,
    required this.lastLoginAt,
    this.timelineLimit,
    this.eventLimit,
  });

  /// 从JSON创建对象
  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  /// 转换为JSON
  Map<String, dynamic> toJson() => _$UserToJson(this);

  /// 复制对象并修改部分字段
  User copyWith({
    String? id,
    String? username,
    String? email,
    String? displayName,
    String? avatarUrl,
    SubscriptionType? subscriptionType,
    DateTime? subscriptionExpiryDate,
    DateTime? createdAt,
    DateTime? lastLoginAt,
    int? timelineLimit,
    int? eventLimit,
  }) {
    return User(
      id: id ?? this.id,
      username: username ?? this.username,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      subscriptionType: subscriptionType ?? this.subscriptionType,
      subscriptionExpiryDate: subscriptionExpiryDate ?? this.subscriptionExpiryDate,
      createdAt: createdAt ?? this.createdAt,
      lastLoginAt: lastLoginAt ?? this.lastLoginAt,
      timelineLimit: timelineLimit ?? this.timelineLimit,
      eventLimit: eventLimit ?? this.eventLimit,
    );
  }

  /// 是否为高级用户
  bool get isPremium => subscriptionType != SubscriptionType.free;

  /// 是否为专业用户
  bool get isProfessional => subscriptionType == SubscriptionType.professional;

  /// 订阅是否有效
  bool get isSubscriptionValid {
    if (subscriptionType == SubscriptionType.free) return false;
    if (subscriptionExpiryDate == null) return true; // 终身订阅
    return subscriptionExpiryDate!.isAfter(DateTime.now());
  }

  /// 获取时间线数量限制
  int get timelineCreateLimit {
    if (isProfessional) return -1; // 专业会员：无限制
    if (isPremium) return -1; // 高级会员：无限制
    return timelineLimit ?? 3; // 免费用户默认3条
  }

  /// 获取事件数量限制（单条时间线）
  int get eventCreateLimit {
    if (isProfessional) return -1; // 专业会员：无限制
    if (subscriptionType == SubscriptionType.premium) {
      return eventLimit ?? 100; // 高级会员：100个事件
    }
    return eventLimit ?? 10; // 免费用户默认每条时间线10个事件
  }

  @override
  List<Object?> get props => [
        id,
        username,
        email,
        displayName,
        avatarUrl,
        subscriptionType,
        subscriptionExpiryDate,
        createdAt,
        lastLoginAt,
        timelineLimit,
        eventLimit,
      ];

  @override
  String toString() {
    return 'User(id: $id, username: $username, email: $email, subscription: $subscriptionType)';
  }
}
