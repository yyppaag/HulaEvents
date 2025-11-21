# 🎬 Hula Events - 时间线动画应用

一个优雅的Flutter时间线应用，用于按照时间顺序展示和管理各类事件，支持历史事件、人物生平、电影宣发、项目进度等多种场景。

## ✨ 功能特性

### 核心功能
- 📅 **时间线可视化**: 以美观的时间线形式展示事件
- 🎨 **多种事件类型**: 支持历史事件、人物生平、电影宣发、项目进度、自定义类型
- 📝 **事件管理**: 完整的CRUD操作（创建、读取、更新、删除）
- 🏷️ **标签系统**: 为事件添加标签，方便分类和检索
- ⭐ **重要标记**: 标记重要事件，在时间线上突出显示
- 💾 **本地存储**: 使用Hive数据库实现本地数据持久化

### UI特性
- 🌓 **深色/浅色主题**: 支持系统主题自动切换
- 🎭 **Material Design 3**: 现代化的UI设计
- ✨ **流畅动画**: 精心设计的过渡动画和交互效果
- 📱 **响应式布局**: 适配不同屏幕尺寸

## 📋 技术栈

### 前端框架
- **Flutter**: ^3.0.0
- **Material Design 3**: 现代化UI设计

### 状态管理
- **Provider**: 轻量级状态管理方案

### 数据存储
- **Hive**: 高性能NoSQL本地数据库
- **Hive Flutter**: Hive的Flutter适配

### UI组件
- **timeline_tile**: 时间线UI组件
- **flutter_staggered_animations**: 交错动画效果
- **shimmer**: 加载骨架屏效果

### 工具库
- **uuid**: 生成唯一标识符
- **intl**: 国际化和日期格式化
- **equatable**: 简化对象比较
- **json_annotation**: JSON序列化

## 🏗️ 项目结构

```
lib/
├── main.dart                 # 应用入口
├── constants/                # 常量配置
│   ├── app_constants.dart    # 应用常量
│   └── app_theme.dart        # 主题配置
├── models/                   # 数据模型
│   ├── event_type.dart       # 事件类型枚举
│   ├── timeline_event.dart   # 时间线事件模型
│   ├── timeline.dart         # 时间线集合模型
│   └── models.dart           # 模型导出
├── providers/                # 状态管理
│   └── timeline_provider.dart # 时间线Provider
├── screens/                  # 页面
│   ├── home_screen.dart      # 主页
│   ├── timeline_detail_screen.dart  # 时间线详情页
│   └── create_timeline_screen.dart  # 创建时间线页
├── services/                 # 服务层
│   └── storage_service.dart  # 本地存储服务
├── utils/                    # 工具类
│   └── sample_data.dart      # 示例数据
└── widgets/                  # 自定义组件
```

## 🚀 快速开始

### 环境要求

- Flutter SDK >= 3.0.0
- Dart SDK >= 3.0.0
- Android Studio / VS Code
- iOS: Xcode 14+ (macOS)
- Android: Android SDK 21+

### 安装步骤

1. **克隆项目**
```bash
git clone https://github.com/yyppaag/HulaEvents.git
cd HulaEvents
```

2. **安装依赖**
```bash
flutter pub get
```

3. **生成代码**（用于Hive适配器和JSON序列化）
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

4. **运行应用**
```bash
# 运行在调试模式
flutter run

# 运行在发布模式
flutter run --release

# 指定设备运行
flutter run -d <device_id>
```

### 查看可用设备
```bash
flutter devices
```

## 📱 功能说明

### 1. 创建时间线
1. 在主页点击 "创建时间线" 按钮
2. 填写时间线名称和描述
3. 选择时间线类型（历史事件、人物生平、电影宣发等）
4. 点击 "创建时间线" 完成创建

### 2. 添加事件
1. 进入时间线详情页
2. 点击 "添加事件" 按钮
3. 填写事件信息（标题、描述、时间、标签等）
4. 保存事件

### 3. 查看时间线
- 时间线以垂直方式展示
- 事件按时间顺序排列
- 点击事件可查看详细信息
- 重要事件会以星标突出显示

### 4. 管理事件
- **编辑**: 点击事件详情中的 "编辑" 按钮
- **删除**: 点击事件详情中的 "删除" 按钮
- **标记重要**: 在编辑页面勾选 "重要事件"
- **添加图片**: 输入图片URL，实时预览

### 5. 搜索和筛选
1. 点击主页搜索图标
2. 输入关键词搜索时间线或事件
3. 使用筛选条件：
   - 按事件类型筛选
   - 仅显示重要事件
4. 点击搜索结果直接跳转

### 6. 数据管理
1. 点击主页更多选项 → 数据管理
2. **导出数据**:
   - 导出所有时间线为JSON
   - 导出单个时间线
   - 数据自动复制到剪贴板
3. **导入数据**:
   - 粘贴JSON数据导入
   - 加载预设示例数据
4. **数据统计**: 查看时间线、事件统计

### 7. 视图模式切换 ⭐
1. 在时间线详情页点击视图图标
2. 选择不同的视图模式：
   - **垂直时间线**: 经典的上下滚动视图
   - **横向时间线**: 左右滚动，卡片式展示
   - **日历视图**: 按月份查看事件分布
3. 点击事件查看详情
4. 日历视图可以：
   - 切换月份浏览
   - 查看每天的事件列表
   - 快速跳转到今天

### 8. 事件详情页
1. 点击任意事件打开详情
2. 全屏沉浸式展示
3. 图片展示（如果有）
4. 完整描述和标签
5. 快速编辑/删除操作

## 🎨 主题定制

应用支持浅色和深色两种主题，会自动跟随系统设置。主题配置位于 `lib/constants/app_theme.dart`。

### 主色调
- **Primary**: Indigo (#6366F1)
- **Secondary**: Pink (#EC4899)
- **Accent**: Purple (#8B5CF6)

### 事件类型颜色
- **历史事件**: Blue (#3B82F6)
- **人物生平**: Green (#10B981)
- **电影宣发**: Amber (#F59E0B)
- **项目进度**: Purple (#8B5CF6)
- **自定义**: Gray (#6B7280)

## 📊 数据模型

### Timeline（时间线）
```dart
{
  id: String,              // 唯一标识
  name: String,            // 名称
  description: String,     // 描述
  category: EventType,     // 类别
  events: List<TimelineEvent>, // 事件列表
  createdAt: DateTime,     // 创建时间
  updatedAt: DateTime      // 更新时间
}
```

### TimelineEvent（时间线事件）
```dart
{
  id: String,              // 唯一标识
  title: String,           // 标题
  description: String,     // 描述
  timestamp: DateTime,     // 时间戳
  type: EventType,         // 类型
  tags: List<String>,      // 标签
  isImportant: bool        // 是否重要
}
```

## 🔧 开发计划

### Phase 1: 基础功能 ✅
- [x] 项目初始化
- [x] 数据模型设计
- [x] 基础UI框架
- [x] 时间线展示
- [x] 本地存储

### Phase 2: 核心功能 ✅
- [x] 事件CRUD完整实现（添加、编辑、删除）
- [x] 搜索和筛选（按类型、关键词、重要性）
- [x] 数据导入导出（JSON格式）
- [x] 图片展示（URL预览）
- [x] 交错动画效果

### Phase 3: 增强功能 ✅
- [x] 横向时间线视图（可横向滚动浏览）
- [x] 日历视图（月历展示事件）
- [x] 视图模式切换（垂直/横向/日历）
- [x] 事件详情全屏页面（Hero动画）
- [x] 动画过渡优化

### Phase 4: 高级功能
- [ ] 云端同步（Firebase/Supabase）
- [ ] 多用户支持
- [ ] 协作编辑
- [ ] 数据统计和可视化

## 🤝 贡献指南

欢迎提交Issue和Pull Request！

1. Fork本项目
2. 创建新分支 (`git checkout -b feature/AmazingFeature`)
3. 提交更改 (`git commit -m 'Add some AmazingFeature'`)
4. 推送到分支 (`git push origin feature/AmazingFeature`)
5. 创建Pull Request

## 📄 许可证

本项目采用 MIT 许可证。详见 [LICENSE](LICENSE) 文件。

## 📧 联系方式

如有问题或建议，欢迎通过以下方式联系：

- 提交 [Issue](https://github.com/yyppaag/HulaEvents/issues)
- 发送邮件至项目维护者

## 🙏 致谢

感谢以下开源项目：
- [Flutter](https://flutter.dev)
- [Hive](https://pub.dev/packages/hive)
- [Provider](https://pub.dev/packages/provider)
- [timeline_tile](https://pub.dev/packages/timeline_tile)

---

**Made with ❤️ by Flutter**
