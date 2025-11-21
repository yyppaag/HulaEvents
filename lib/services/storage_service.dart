import 'package:hive_flutter/hive_flutter.dart';
import '../models/models.dart';
import '../constants/app_constants.dart';

/// 本地存储服务
class StorageService {
  // 单例模式
  static final StorageService _instance = StorageService._internal();
  factory StorageService() => _instance;
  StorageService._internal();

  /// Hive boxes
  late Box<Timeline> _timelineBox;
  late Box _settingsBox;

  /// 初始化Hive数据库
  Future<void> init() async {
    await Hive.initFlutter();

    // 注册适配器（需要在运行build_runner后取消注释）
    // Hive.registerAdapter(TimelineAdapter());
    // Hive.registerAdapter(TimelineEventAdapter());

    // 打开boxes
    _timelineBox = await Hive.openBox<Timeline>(AppConstants.timelineBoxName);
    _settingsBox = await Hive.openBox(AppConstants.settingsBoxName);
  }

  /// 获取所有时间线
  List<Timeline> getAllTimelines() {
    return _timelineBox.values.toList();
  }

  /// 根据ID获取时间线
  Timeline? getTimeline(String id) {
    return _timelineBox.get(id);
  }

  /// 保存时间线
  Future<void> saveTimeline(Timeline timeline) async {
    await _timelineBox.put(timeline.id, timeline);
  }

  /// 删除时间线
  Future<void> deleteTimeline(String id) async {
    await _timelineBox.delete(id);
  }

  /// 更新时间线
  Future<void> updateTimeline(Timeline timeline) async {
    final updatedTimeline = timeline.copyWith(
      updatedAt: DateTime.now(),
    );
    await _timelineBox.put(timeline.id, updatedTimeline);
  }

  /// 清空所有时间线
  Future<void> clearAllTimelines() async {
    await _timelineBox.clear();
  }

  /// 获取设置
  T? getSetting<T>(String key, {T? defaultValue}) {
    return _settingsBox.get(key, defaultValue: defaultValue) as T?;
  }

  /// 保存设置
  Future<void> saveSetting(String key, dynamic value) async {
    await _settingsBox.put(key, value);
  }

  /// 关闭数据库
  Future<void> close() async {
    await _timelineBox.close();
    await _settingsBox.close();
  }
}
