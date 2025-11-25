import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// 语言管理Provider
/// 管理应用的语言设置和切换
class LocaleProvider extends ChangeNotifier {
  static const String _localeKey = 'locale';
  Locale _locale = const Locale('zh'); // 默认中文

  Locale get locale => _locale;

  /// 初始化语言设置
  /// 从SharedPreferences读取用户上次选择的语言
  Future<void> initialize() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final languageCode = prefs.getString(_localeKey);

      if (languageCode != null) {
        _locale = Locale(languageCode);
        notifyListeners();
      }
    } catch (e) {
      // 如果读取失败，使用默认语言
      debugPrint('Failed to load locale: $e');
    }
  }

  /// 设置语言
  /// 参数:
  /// - [locale]: 新的语言设置
  Future<void> setLocale(Locale locale) async {
    if (_locale == locale) return;

    _locale = locale;
    notifyListeners();

    // 保存到SharedPreferences
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_localeKey, locale.languageCode);
    } catch (e) {
      debugPrint('Failed to save locale: $e');
    }
  }

  /// 切换语言（在中英文之间切换）
  Future<void> toggleLocale() async {
    if (_locale.languageCode == 'zh') {
      await setLocale(const Locale('en'));
    } else {
      await setLocale(const Locale('zh'));
    }
  }

  /// 获取当前语言的显示名称
  String get currentLanguageName {
    switch (_locale.languageCode) {
      case 'zh':
        return '中文';
      case 'en':
        return 'English';
      default:
        return '中文';
    }
  }

  /// 检查是否为中文
  bool get isChinese => _locale.languageCode == 'zh';

  /// 检查是否为英文
  bool get isEnglish => _locale.languageCode == 'en';

  /// 获取支持的语言列表
  static const List<Locale> supportedLocales = [
    Locale('zh'),
    Locale('en'),
  ];

  /// 获取语言显示名称
  static String getLanguageName(Locale locale) {
    switch (locale.languageCode) {
      case 'zh':
        return '中文';
      case 'en':
        return 'English';
      default:
        return 'Unknown';
    }
  }
}
