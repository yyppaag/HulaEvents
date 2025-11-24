/// 应用常量配置
class AppConstants {
  // 私有构造函数，防止实例化
  AppConstants._();

  /// 应用名称
  static const String appName = 'Hula Events';

  /// 应用版本
  static const String appVersion = '1.0.0';

  /// Hive数据库相关
  static const String timelineBoxName = 'timelines';
  static const String eventBoxName = 'events';
  static const String userBoxName = 'users';
  static const String settingsBoxName = 'settings';

  /// 动画持续时间（毫秒）
  static const int animationDurationShort = 200;
  static const int animationDurationMedium = 400;
  static const int animationDurationLong = 600;

  /// UI相关常量
  static const double defaultPadding = 16.0;
  static const double smallPadding = 8.0;
  static const double largePadding = 24.0;
  static const double defaultRadius = 12.0;
  static const double smallRadius = 8.0;
  static const double largeRadius = 16.0;

  /// 时间线相关
  static const double timelineNodeSize = 20.0;
  static const double timelineLineWidth = 3.0;
  static const double timelineCardWidth = 300.0;

  /// 图片相关
  static const double maxImageWidth = 1200.0;
  static const double maxImageHeight = 1200.0;
  static const int imageQuality = 85;

  /// 日期格式
  static const String dateFormatFull = 'yyyy年MM月dd日 HH:mm';
  static const String dateFormatShort = 'yyyy/MM/dd';
  static const String dateFormatYear = 'yyyy年';
  static const String dateFormatMonthDay = 'MM月dd日';
}
