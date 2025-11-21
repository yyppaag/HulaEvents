import 'package:flutter/foundation.dart';
import '../models/models.dart';
import '../services/storage_service.dart';
import '../utils/sample_data.dart';

/// 时间线状态管理Provider
class TimelineProvider extends ChangeNotifier {
  final StorageService _storageService = StorageService();

  List<Timeline> _timelines = [];
  Timeline? _selectedTimeline;
  bool _isLoading = false;
  String? _errorMessage;

  /// 获取所有时间线
  List<Timeline> get timelines => _timelines;

  /// 获取当前选中的时间线
  Timeline? get selectedTimeline => _selectedTimeline;

  /// 获取加载状态
  bool get isLoading => _isLoading;

  /// 获取错误信息
  String? get errorMessage => _errorMessage;

  /// 加载所有时间线
  Future<void> loadTimelines() async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      _timelines = _storageService.getAllTimelines();

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = '加载时间线失败: $e';
      notifyListeners();
    }
  }

  /// 加载示例数据（首次启动时）
  Future<void> loadSampleData() async {
    try {
      _isLoading = true;
      notifyListeners();

      final sampleTimelines = SampleData.generateSampleTimelines();
      for (final timeline in sampleTimelines) {
        await _storageService.saveTimeline(timeline);
      }

      await loadTimelines();

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = '加载示例数据失败: $e';
      notifyListeners();
    }
  }

  /// 选择时间线
  void selectTimeline(Timeline timeline) {
    _selectedTimeline = timeline;
    notifyListeners();
  }

  /// 取消选择时间线
  void clearSelection() {
    _selectedTimeline = null;
    notifyListeners();
  }

  /// 添加时间线
  Future<void> addTimeline(Timeline timeline) async {
    try {
      await _storageService.saveTimeline(timeline);
      _timelines.add(timeline);
      notifyListeners();
    } catch (e) {
      _errorMessage = '添加时间线失败: $e';
      notifyListeners();
    }
  }

  /// 更新时间线
  Future<void> updateTimeline(Timeline timeline) async {
    try {
      await _storageService.updateTimeline(timeline);
      final index = _timelines.indexWhere((t) => t.id == timeline.id);
      if (index != -1) {
        _timelines[index] = timeline;
        if (_selectedTimeline?.id == timeline.id) {
          _selectedTimeline = timeline;
        }
        notifyListeners();
      }
    } catch (e) {
      _errorMessage = '更新时间线失败: $e';
      notifyListeners();
    }
  }

  /// 删除时间线
  Future<void> deleteTimeline(String id) async {
    try {
      await _storageService.deleteTimeline(id);
      _timelines.removeWhere((t) => t.id == id);
      if (_selectedTimeline?.id == id) {
        _selectedTimeline = null;
      }
      notifyListeners();
    } catch (e) {
      _errorMessage = '删除时间线失败: $e';
      notifyListeners();
    }
  }

  /// 添加事件到时间线
  Future<void> addEventToTimeline(String timelineId, TimelineEvent event) async {
    try {
      final timeline = _timelines.firstWhere((t) => t.id == timelineId);
      final updatedEvents = List<TimelineEvent>.from(timeline.events)..add(event);
      final updatedTimeline = timeline.copyWith(
        events: updatedEvents,
        updatedAt: DateTime.now(),
      );
      await updateTimeline(updatedTimeline);
    } catch (e) {
      _errorMessage = '添加事件失败: $e';
      notifyListeners();
    }
  }

  /// 从时间线删除事件
  Future<void> removeEventFromTimeline(String timelineId, String eventId) async {
    try {
      final timeline = _timelines.firstWhere((t) => t.id == timelineId);
      final updatedEvents = timeline.events.where((e) => e.id != eventId).toList();
      final updatedTimeline = timeline.copyWith(
        events: updatedEvents,
        updatedAt: DateTime.now(),
      );
      await updateTimeline(updatedTimeline);
    } catch (e) {
      _errorMessage = '删除事件失败: $e';
      notifyListeners();
    }
  }

  /// 更新时间线中的事件
  Future<void> updateEventInTimeline(String timelineId, TimelineEvent event) async {
    try {
      final timeline = _timelines.firstWhere((t) => t.id == timelineId);
      final updatedEvents = timeline.events.map((e) {
        return e.id == event.id ? event : e;
      }).toList();
      final updatedTimeline = timeline.copyWith(
        events: updatedEvents,
        updatedAt: DateTime.now(),
      );
      await updateTimeline(updatedTimeline);
    } catch (e) {
      _errorMessage = '更新事件失败: $e';
      notifyListeners();
    }
  }

  /// 清除错误信息
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
