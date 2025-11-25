import 'package:flutter_test/flutter_test.dart';
import 'package:hula_events/features/timeline/domain/entities/event_type.dart';
import 'package:hula_events/core/constants/app_theme.dart';

void main() {
  group('EventType', () {
    group('displayName', () {
      test('should return correct display name for history', () {
        expect(EventType.history.displayName, '历史事件');
      });

      test('should return correct display name for biography', () {
        expect(EventType.biography.displayName, '人物生平');
      });

      test('should return correct display name for movie', () {
        expect(EventType.movie.displayName, '电影宣发');
      });

      test('should return correct display name for project', () {
        expect(EventType.project.displayName, '项目进度');
      });

      test('should return correct display name for custom', () {
        expect(EventType.custom.displayName, '自定义');
      });
    });

    group('icon', () {
      test('should return correct icon for history', () {
        expect(EventType.history.icon, '📚');
      });

      test('should return correct icon for biography', () {
        expect(EventType.biography.icon, '👤');
      });

      test('should return correct icon for movie', () {
        expect(EventType.movie.icon, '🎬');
      });

      test('should return correct icon for project', () {
        expect(EventType.project.icon, '📊');
      });

      test('should return correct icon for custom', () {
        expect(EventType.custom.icon, '⭐');
      });
    });

    group('color', () {
      test('should return correct color for history', () {
        expect(EventType.history.color, AppTheme.historyColor);
      });

      test('should return correct color for biography', () {
        expect(EventType.biography.color, AppTheme.biographyColor);
      });

      test('should return correct color for movie', () {
        expect(EventType.movie.color, AppTheme.movieColor);
      });

      test('should return correct color for project', () {
        expect(EventType.project.color, AppTheme.projectColor);
      });

      test('should return correct color for custom', () {
        expect(EventType.custom.color, AppTheme.customColor);
      });
    });

    group('fromString', () {
      test('should return correct EventType for valid string', () {
        expect(EventType.fromString('history'), EventType.history);
        expect(EventType.fromString('biography'), EventType.biography);
        expect(EventType.fromString('movie'), EventType.movie);
        expect(EventType.fromString('project'), EventType.project);
        expect(EventType.fromString('custom'), EventType.custom);
      });

      test('should return custom for invalid string', () {
        expect(EventType.fromString('invalid'), EventType.custom);
        expect(EventType.fromString(''), EventType.custom);
        expect(EventType.fromString('HISTORY'), EventType.custom);
      });
    });

    group('values', () {
      test('should have exactly 5 event types', () {
        expect(EventType.values.length, 5);
      });

      test('should contain all expected event types', () {
        expect(EventType.values, contains(EventType.history));
        expect(EventType.values, contains(EventType.biography));
        expect(EventType.values, contains(EventType.movie));
        expect(EventType.values, contains(EventType.project));
        expect(EventType.values, contains(EventType.custom));
      });
    });
  });
}
