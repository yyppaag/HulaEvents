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
  late Box<User> _userBox;
  late Box _settingsBox;

  /// 初始化Hive数据库
  Future<void> init() async {
    await Hive.initFlutter();

    // 注册适配器
    Hive.registerAdapter(EventTypeAdapter());
    Hive.registerAdapter(TimelineEventAdapter());
    Hive.registerAdapter(TimelineAdapter());
    Hive.registerAdapter(SubscriptionTypeAdapter());
    Hive.registerAdapter(UserAdapter());

    // 打开boxes
    _timelineBox = await Hive.openBox<Timeline>(AppConstants.timelineBoxName);
    _userBox = await Hive.openBox<User>(AppConstants.userBoxName);
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

  // ============ 用户相关方法 ============

  /// 获取所有用户
  List<User> getAllUsers() {
    return _userBox.values.toList();
  }

  /// 根据ID获取用户
  User? getUser(String id) {
    return _userBox.get(id);
  }

  /// 保存用户
  Future<void> saveUser(User user) async {
    await _userBox.put(user.id, user);
  }

  /// 删除用户
  Future<void> deleteUser(String id) async {
    await _userBox.delete(id);
  }

  /// 更新用户
  Future<void> updateUser(User user) async {
    await _userBox.put(user.id, user);
  }

  /// 清空所有用户
  Future<void> clearAllUsers() async {
    await _userBox.clear();
  }

  // ============ 设置相关方法 ============

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
    await _userBox.close();
    await _settingsBox.close();
  }
}
