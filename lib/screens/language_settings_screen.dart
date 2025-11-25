import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import '../providers/locale_provider.dart';

/// 语言设置页面
/// 允许用户选择应用的显示语言
class LanguageSettingsScreen extends StatelessWidget {
  const LanguageSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final localeProvider = context.watch<LocaleProvider>();

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.settings),
      ),
      body: ListView(
        children: [
          // 中文选项
          RadioListTile<Locale>(
            title: const Text('中文'),
            subtitle: const Text('Chinese'),
            value: const Locale('zh'),
            groupValue: localeProvider.locale,
            onChanged: (Locale? value) {
              if (value != null) {
                localeProvider.setLocale(value);
              }
            },
            secondary: const Icon(Icons.language),
          ),
          const Divider(),

          // 英文选项
          RadioListTile<Locale>(
            title: const Text('English'),
            subtitle: const Text('英语'),
            value: const Locale('en'),
            groupValue: localeProvider.locale,
            onChanged: (Locale? value) {
              if (value != null) {
                localeProvider.setLocale(value);
              }
            },
            secondary: const Icon(Icons.language),
          ),
          const Divider(),

          // 当前选中的语言提示
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              '${l10n.loading} ${localeProvider.currentLanguageName}',
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
