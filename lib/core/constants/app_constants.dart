/// Application constants configuration
class AppConstants {
  // Private constructor to prevent instantiation
  AppConstants._();

  /// Application name
  static const String appName = 'Hula Events';

  /// Application version
  static const String appVersion = '1.0.0';

  /// Hive database related
  static const String timelineBoxName = 'timelines';
  static const String eventBoxName = 'events';
  static const String settingsBoxName = 'settings';

  /// Data migration version - increment this when Hive schema changes
  static const int hiveMigrationVersion = 2;

  /// Animation duration (milliseconds)
  static const int animationDurationShort = 200;
  static const int animationDurationMedium = 400;
  static const int animationDurationLong = 600;

  /// UI related constants
  static const double defaultPadding = 16.0;
  static const double smallPadding = 8.0;
  static const double largePadding = 24.0;
  static const double defaultRadius = 12.0;
  static const double smallRadius = 8.0;
  static const double largeRadius = 16.0;

  /// Timeline related
  static const double timelineNodeSize = 20.0;
  static const double timelineLineWidth = 3.0;
  static const double timelineCardWidth = 300.0;

  /// Image related
  static const double maxImageWidth = 1200.0;
  static const double maxImageHeight = 1200.0;
  static const int imageQuality = 85;

  /// Date formats
  static const String dateFormatFull = 'yyyy年MM月dd日 HH:mm';
  static const String dateFormatShort = 'yyyy/MM/dd';
  static const String dateFormatYear = 'yyyy年';
  static const String dateFormatMonthDay = 'MM月dd日';
}
