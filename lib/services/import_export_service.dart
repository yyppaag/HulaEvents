import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import '../models/models.dart';

/// 数据导入导出服务
class ImportExportService {
  // 单例模式
  static final ImportExportService _instance = ImportExportService._internal();
  factory ImportExportService() => _instance;
  ImportExportService._internal();

  /// 导出单个时间线为JSON字符串
  String exportTimelineToJson(Timeline timeline) {
    try {
      final jsonMap = timeline.toJson();
      final jsonString = const JsonEncoder.withIndent('  ').convert(jsonMap);
      return jsonString;
    } catch (e) {
      throw Exception('导出失败: $e');
    }
  }

  /// 导出多个时间线为JSON字符串
  String exportTimelinesToJson(List<Timeline> timelines) {
    try {
      final jsonList = timelines.map((t) => t.toJson()).toList();
      final jsonString = const JsonEncoder.withIndent('  ').convert(jsonList);
      return jsonString;
    } catch (e) {
      throw Exception('导出失败: $e');
    }
  }

  /// 从JSON字符串导入单个时间线
  Timeline importTimelineFromJson(String jsonString) {
    try {
      final jsonMap = jsonDecode(jsonString) as Map<String, dynamic>;
      return Timeline.fromJson(jsonMap);
    } catch (e) {
      throw Exception('导入失败: $e');
    }
  }

  /// 从JSON字符串导入多个时间线
  List<Timeline> importTimelinesFromJson(String jsonString) {
    try {
      final jsonList = jsonDecode(jsonString) as List<dynamic>;
      return jsonList
          .map((json) => Timeline.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('导入失败: $e');
    }
  }

  /// 验证JSON格式是否有效
  bool validateJsonFormat(String jsonString) {
    try {
      final decoded = jsonDecode(jsonString);
      if (decoded is Map<String, dynamic>) {
        // 单个时间线
        return _validateTimelineJson(decoded);
      } else if (decoded is List) {
        // 多个时间线
        return decoded.every((item) {
          if (item is! Map<String, dynamic>) return false;
          return _validateTimelineJson(item);
        });
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  bool _validateTimelineJson(Map<String, dynamic> json) {
    // 检查必需字段
    final requiredFields = ['id', 'name', 'description', 'category', 'events', 'createdAt', 'updatedAt'];
    for (final field in requiredFields) {
      if (!json.containsKey(field)) {
        return false;
      }
    }
    return true;
  }

  /// 将JSON字符串保存到文件（Web平台不支持）
  Future<void> saveToFile(String jsonString, String filePath) async {
    if (kIsWeb) {
      throw UnsupportedError('Web平台不支持文件系统操作');
    }

    try {
      final file = File(filePath);
      await file.writeAsString(jsonString);
    } catch (e) {
      throw Exception('保存文件失败: $e');
    }
  }

  /// 从文件读取JSON字符串（Web平台不支持）
  Future<String> readFromFile(String filePath) async {
    if (kIsWeb) {
      throw UnsupportedError('Web平台不支持文件系统操作');
    }

    try {
      final file = File(filePath);
      return await file.readAsString();
    } catch (e) {
      throw Exception('读取文件失败: $e');
    }
  }

  /// 生成导出文件名
  String generateExportFileName(Timeline timeline) {
    final now = DateTime.now();
    final dateStr = '${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}';
    final timelineNameSafe = timeline.name.replaceAll(RegExp(r'[^\w\s-]'), '').replaceAll(' ', '_');
    return '${timelineNameSafe}_$dateStr.json';
  }

  /// 生成批量导出文件名
  String generateBatchExportFileName() {
    final now = DateTime.now();
    final dateStr = '${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}';
    final timeStr = '${now.hour.toString().padLeft(2, '0')}${now.minute.toString().padLeft(2, '0')}';
    return 'timelines_export_${dateStr}_$timeStr.json';
  }

  /// 获取导出数据的统计信息
  Map<String, dynamic> getExportStats(List<Timeline> timelines) {
    int totalEvents = 0;
    final typeCount = <EventType, int>{};

    for (final timeline in timelines) {
      totalEvents += timeline.events.length;
      for (final event in timeline.events) {
        typeCount[event.type] = (typeCount[event.type] ?? 0) + 1;
      }
    }

    return {
      'timelineCount': timelines.length,
      'eventCount': totalEvents,
      'typeDistribution': typeCount,
    };
  }
}
