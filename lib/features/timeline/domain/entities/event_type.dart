import 'package:flutter/material.dart';
import '../../../../core/constants/app_theme.dart';

/// Event type enumeration
enum EventType {
  /// Historical event
  history,

  /// Biography
  biography,

  /// Movie promotion
  movie,

  /// Project progress
  project,

  /// Custom type
  custom;

  /// Get display name of the event type
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

  /// Get icon of the event type
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

  /// Get color of the event type
  Color get color {
    switch (this) {
      case EventType.history:
        return AppTheme.historyColor;
      case EventType.biography:
        return AppTheme.biographyColor;
      case EventType.movie:
        return AppTheme.movieColor;
      case EventType.project:
        return AppTheme.projectColor;
      case EventType.custom:
        return AppTheme.customColor;
    }
  }

  /// Convert from string to event type
  static EventType fromString(String value) {
    return EventType.values.firstWhere(
      (e) => e.name == value,
      orElse: () => EventType.custom,
    );
  }
}
