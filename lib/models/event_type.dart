/// 事件类型枚举
enum EventType {
  /// 历史事件
  history,

  /// 人物生平
  biography,

  /// 电影宣发
  movie,

  /// 项目进度
  project,

  /// 自定义类型
  custom;

  /// 获取事件类型的显示名称
  String get displayName {
    switch (this) {
      case EventType.history:
        return '历史事件';
      case EventType.biography:
        return '人物生平';
      case EventType.movie:
        return '电影宣发';
      case EventType.project:
        return '项目进度';
      case EventType.custom:
        return '自定义';
    }
  }

  /// 获取事件类型的图标
  String get icon {
    switch (this) {
      case EventType.history:
        return '📚';
      case EventType.biography:
        return '👤';
      case EventType.movie:
        return '🎬';
      case EventType.project:
        return '📊';
      case EventType.custom:
        return '⭐';
    }
  }

  /// 从字符串转换为事件类型
  static EventType fromString(String value) {
    return EventType.values.firstWhere(
      (e) => e.name == value,
      orElse: () => EventType.custom,
    );
  }
}
