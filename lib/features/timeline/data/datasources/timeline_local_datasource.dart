import 'package:hive_flutter/hive_flutter.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/error/exceptions.dart';
import '../../domain/entities/event_type.dart';
import '../models/timeline_model.dart';
import '../models/timeline_event_model.dart';

/// Local data source interface for timeline operations
abstract class TimelineLocalDataSource {
  /// Initialize the data source
  Future<void> init();

  /// Get all timelines
  List<TimelineModel> getTimelines();

  /// Get a single timeline by id
  TimelineModel? getTimeline(String id);

  /// Save a timeline
  Future<void> saveTimeline(TimelineModel timeline);

  /// Update a timeline
  Future<void> updateTimeline(TimelineModel timeline);

  /// Delete a timeline
  Future<void> deleteTimeline(String id);

  /// Clear all timelines
  Future<void> clearAllTimelines();

  /// Close the data source
  Future<void> close();
}

/// Implementation of TimelineLocalDataSource using Hive
class TimelineLocalDataSourceImpl implements TimelineLocalDataSource {
  // Singleton pattern
  static final TimelineLocalDataSourceImpl _instance =
      TimelineLocalDataSourceImpl._internal();
  factory TimelineLocalDataSourceImpl() => _instance;
  TimelineLocalDataSourceImpl._internal();

  late Box<TimelineModel> _timelineBox;
  late Box _settingsBox;
  bool _isInitialized = false;

  @override
  Future<void> init() async {
    if (_isInitialized) return;

    try {
      await Hive.initFlutter();

      // Register adapters
      if (!Hive.isAdapterRegistered(0)) {
        Hive.registerAdapter(TimelineEventModelAdapter());
      }
      if (!Hive.isAdapterRegistered(1)) {
        Hive.registerAdapter(TimelineModelAdapter());
      }
      if (!Hive.isAdapterRegistered(2)) {
        Hive.registerAdapter(EventTypeAdapter());
      }

      // Try to open boxes, handle corrupted data
      try {
        _timelineBox = await Hive.openBox<TimelineModel>(AppConstants.timelineBoxName);
      } catch (e) {
        // If box is corrupted (e.g., incompatible typeIds), delete and recreate
        await Hive.deleteBoxFromDisk(AppConstants.timelineBoxName);
        _timelineBox = await Hive.openBox<TimelineModel>(AppConstants.timelineBoxName);
      }

      try {
        _settingsBox = await Hive.openBox(AppConstants.settingsBoxName);
      } catch (e) {
        await Hive.deleteBoxFromDisk(AppConstants.settingsBoxName);
        _settingsBox = await Hive.openBox(AppConstants.settingsBoxName);
      }

      _isInitialized = true;
    } catch (e) {
      throw StorageException('Failed to initialize storage: $e');
    }
  }

  @override
  List<TimelineModel> getTimelines() {
    try {
      return _timelineBox.values.toList();
    } catch (e) {
      throw CacheException('Failed to get timelines: $e');
    }
  }

  @override
  TimelineModel? getTimeline(String id) {
    try {
      return _timelineBox.get(id);
    } catch (e) {
      throw CacheException('Failed to get timeline: $e');
    }
  }

  @override
  Future<void> saveTimeline(TimelineModel timeline) async {
    try {
      await _timelineBox.put(timeline.id, timeline);
    } catch (e) {
      throw CacheException('Failed to save timeline: $e');
    }
  }

  @override
  Future<void> updateTimeline(TimelineModel timeline) async {
    try {
      final updatedTimeline = timeline.copyWithModel(
        updatedAt: DateTime.now(),
      );
      await _timelineBox.put(timeline.id, updatedTimeline);
    } catch (e) {
      throw CacheException('Failed to update timeline: $e');
    }
  }

  @override
  Future<void> deleteTimeline(String id) async {
    try {
      await _timelineBox.delete(id);
    } catch (e) {
      throw CacheException('Failed to delete timeline: $e');
    }
  }

  @override
  Future<void> clearAllTimelines() async {
    try {
      await _timelineBox.clear();
    } catch (e) {
      throw CacheException('Failed to clear timelines: $e');
    }
  }

  @override
  Future<void> close() async {
    try {
      await _timelineBox.close();
      await _settingsBox.close();
      _isInitialized = false;
    } catch (e) {
      throw StorageException('Failed to close storage: $e');
    }
  }
}

/// Hive adapter for EventType enum
class EventTypeAdapter extends TypeAdapter<EventType> {
  @override
  final int typeId = 2;

  @override
  EventType read(BinaryReader reader) {
    return EventType.values[reader.readInt()];
  }

  @override
  void write(BinaryWriter writer, EventType obj) {
    writer.writeInt(obj.index);
  }
}
