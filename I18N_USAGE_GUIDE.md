# 国际化（I18n）使用指南

## 📚 概述

应用已完整集成国际化支持，支持中文和英文两种语言。

## 🔧 已完成的配置

### 1. 本地化文件
- ✅ `lib/l10n/app_en.arb` - 英文翻译
- ✅ `lib/l10n/app_zh.arb` - 中文翻译
- ✅ `l10n.yaml` - 本地化配置
- ✅ `pubspec.yaml` - 添加 `generate: true`

### 2. Provider
- ✅ `LocaleProvider` - 语言管理Provider
  - 支持语言切换
  - 自动保存用户选择
  - 提供当前语言信息

### 3. UI组件
- ✅ `LanguageSettingsScreen` - 语言设置页面
- ✅ 已集成到main.dart

## 📝 如何使用

### 1. 生成本地化代码

在开始使用前，需要先生成本地化代码：

```bash
# 方式1：Flutter命令（推荐）
flutter gen-l10n

# 方式2：构建时自动生成
flutter build <target>
```

生成的文件位于：`.dart_tool/flutter_gen/gen_l10n/app_localizations.dart`

### 2. 在Widget中使用本地化字符串

```dart
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ExampleWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // 获取本地化对象
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.appName),  // 使用本地化字符串
      ),
      body: Column(
        children: [
          Text(l10n.home),              // "首页" 或 "Home"
          Text(l10n.createTimeline),     // "创建时间线" 或 "Create Timeline"
          Text(l10n.noTimelines),        // "还没有时间线" 或 "No Timelines"

          // 带参数的本地化字符串
          Text(l10n.eventCount(5)),      // "5 个事件" 或 "5 events"
          Text(l10n.durationDays(30)),   // "30 天" 或 "30 days"
        ],
      ),
    );
  }
}
```

### 3. 修改现有代码示例

#### 修改前（硬编码字符串）：
```dart
Text('创建时间线'),
Text('还没有时间线'),
SnackBar(content: Text('时间线创建成功')),
```

#### 修改后（使用本地化）：
```dart
final l10n = AppLocalizations.of(context)!;

Text(l10n.createTimeline),
Text(l10n.noTimelines),
SnackBar(content: Text(l10n.timelineCreateSuccess)),
```

### 4. 添加语言切换功能

#### 方式1：在设置中添加语言选项

```dart
ListTile(
  leading: const Icon(Icons.language),
  title: Text(l10n.settings),
  subtitle: Text(localeProvider.currentLanguageName),
  trailing: const Icon(Icons.chevron_right),
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const LanguageSettingsScreen(),
      ),
    );
  },
),
```

#### 方式2：快速切换按钮

```dart
IconButton(
  icon: const Icon(Icons.language),
  tooltip: localeProvider.currentLanguageName,
  onPressed: () {
    context.read<LocaleProvider>().toggleLocale();
  },
),
```

## 🎯 需要修改的文件清单

为了完全支持多语言，需要修改以下文件的硬编码字符串：

### 高优先级（核心界面）
1. ✅ `lib/screens/home_screen.dart`
   - AppBar标题
   - 搜索提示
   - 空状态提示
   - 菜单项

2. ✅ `lib/screens/create_timeline_screen.dart`
   - 表单标签
   - 验证消息
   - 按钮文本
   - 提示信息

3. ✅ `lib/screens/create_event_screen.dart`
   - 表单标签
   - 日期时间选择器
   - 标签输入提示

4. ✅ `lib/screens/auth_screen.dart`
   - 登录/注册表单
   - 验证消息
   - 按钮文本

5. ✅ `lib/screens/user_profile_screen.dart`
   - 用户信息标签
   - 订阅状态
   - 设置菜单

### 中优先级（详情和搜索）
6. `lib/screens/timeline_detail_screen.dart`
7. `lib/screens/event_detail_screen.dart`
8. `lib/screens/search_screen.dart`
9. `lib/screens/data_management_screen.dart`

### 低优先级（辅助组件）
10. `lib/widgets/horizontal_timeline_view.dart`
11. `lib/widgets/calendar_view.dart`

## 📋 完整修改示例

### home_screen.dart 修改示例

```dart
// 在build方法开始处添加
final l10n = AppLocalizations.of(context)!;

// AppBar
AppBar(
  title: Text(l10n.appName),  // 替代 'Hula Events'
  actions: [
    // ... 用户头像/登录按钮 ...
    IconButton(
      icon: const Icon(Icons.search),
      tooltip: l10n.search,
      onPressed: () {
        // ...
      },
    ),
    // 添加语言切换按钮
    Consumer<LocaleProvider>(
      builder: (context, localeProvider, _) {
        return IconButton(
          icon: const Icon(Icons.language),
          tooltip: localeProvider.currentLanguageName,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const LanguageSettingsScreen(),
              ),
            );
          },
        );
      },
    ),
  ],
),

// 空状态
if (provider.timelines.isEmpty)
  Center(
    child: Column(
      children: [
        Text(
          l10n.noTimelines,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        Text(l10n.noTimelinesDesc),
      ],
    ),
  ),

// FloatingActionButton
FloatingActionButton.extended(
  onPressed: () { /* ... */ },
  icon: const Icon(Icons.add),
  label: Text(l10n.createTimeline),
),
```

## 🔑 常用本地化字符串

### 通用
- `l10n.appName` - 应用名称
- `l10n.home` - 首页
- `l10n.search` - 搜索
- `l10n.settings` - 设置
- `l10n.cancel` - 取消
- `l10n.save` - 保存
- `l10n.delete` - 删除
- `l10n.edit` - 编辑
- `l10n.confirm` - 确定

### 时间线
- `l10n.timeline` - 时间线
- `l10n.createTimeline` - 创建时间线
- `l10n.timelineName` - 时间线名称
- `l10n.timelineDescription` - 时间线描述
- `l10n.timelineCreateSuccess` - 时间线创建成功
- `l10n.noTimelines` - 还没有时间线

### 事件
- `l10n.event` - 事件
- `l10n.addEvent` - 添加事件
- `l10n.eventTitle` - 事件标题
- `l10n.eventDescription` - 事件描述
- `l10n.eventAddSuccess` - 事件添加成功

### 用户
- `l10n.login` - 登录
- `l10n.register` - 注册
- `l10n.username` - 用户名
- `l10n.email` - 邮箱
- `l10n.password` - 密码
- `l10n.loginSuccess` - 登录成功
- `l10n.userProfile` - 用户中心

### 验证消息
- `l10n.validationUsernameRequired` - 请输入用户名
- `l10n.validationEmailRequired` - 请输入邮箱
- `l10n.validationPasswordRequired` - 请输入密码
- `l10n.validationPasswordLength` - 密码至少6个字符

## 🎨 最佳实践

1. **始终使用l10n对象**
   ```dart
   // ❌ 错误
   Text('创建时间线')

   // ✅ 正确
   Text(l10n.createTimeline)
   ```

2. **处理null值**
   ```dart
   // 使用 ! 操作符（确保context有效时）
   final l10n = AppLocalizations.of(context)!;

   // 或使用条件判断
   final l10n = AppLocalizations.of(context);
   if (l10n != null) {
     Text(l10n.appName);
   }
   ```

3. **带参数的字符串**
   ```dart
   // ARB文件定义
   "eventCount": "{count} 个事件"

   // 使用
   Text(l10n.eventCount(timeline.eventCount))
   ```

4. **日期格式化**
   ```dart
   import 'package:intl/intl.dart';

   // 已有的DateFormat仍然可用
   DateFormat('yyyy年MM月dd日').format(date)  // 中文
   DateFormat('yyyy-MM-dd').format(date)      // 通用
   ```

## 🚀 快速开始步骤

1. **生成本地化代码**
   ```bash
   flutter gen-l10n
   ```

2. **在需要的文件中导入**
   ```dart
   import 'package:flutter_gen/gen_l10n/app_localizations.dart';
   ```

3. **在Widget中使用**
   ```dart
   final l10n = AppLocalizations.of(context)!;
   Text(l10n.appName);
   ```

4. **添加语言切换入口**（在用户设置中）
   ```dart
   Navigator.push(
     context,
     MaterialPageRoute(
       builder: (context) => const LanguageSettingsScreen(),
     ),
   );
   ```

## 📦 已包含的语言

- 🇨🇳 中文 (zh)
- 🇬🇧 English (en)

## ➕ 添加新语言

1. 创建新的ARB文件 `lib/l10n/app_<locale>.arb`
2. 复制现有翻译并修改为新语言
3. 在`LocaleProvider`中添加新语言支持
4. 运行 `flutter gen-l10n` 重新生成

## 🐛 常见问题

**Q: 找不到 AppLocalizations 类**
A: 运行 `flutter gen-l10n` 生成本地化代码

**Q: 语言切换后没有反应**
A: 确保 MaterialApp 包裹在 Consumer<LocaleProvider> 中

**Q: 编译错误：Undefined name 'AppLocalizations'**
A: 在 pubspec.yaml 中添加 `generate: true`，然后运行 flutter gen-l10n

**Q: 如何测试不同语言？**
A:
1. 使用应用内的语言切换功能
2. 或在模拟器中更改系统语言

---

🎉 国际化系统已完全配置好！现在可以开始修改界面使用本地化字符串了。
