import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../providers/timeline_provider.dart';
import '../services/import_export_service.dart';
import '../models/models.dart';
import '../constants/app_constants.dart';
import '../utils/sample_data.dart';

class DataManagementScreen extends StatelessWidget {
  const DataManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('数据管理'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        children: [
          // 导出数据部分
          Text(
            '导出数据',
            style: theme.textTheme.headlineMedium,
          ),
          const SizedBox(height: 16),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.upload_file, color: Colors.blue),
                  title: const Text('导出所有时间线'),
                  subtitle: const Text('将所有时间线导出为JSON格式'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => _showExportAllDialog(context),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.file_copy, color: Colors.green),
                  title: const Text('导出单个时间线'),
                  subtitle: const Text('选择一个时间线导出'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => _showExportSingleDialog(context),
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),

          // 导入数据部分
          Text(
            '导入数据',
            style: theme.textTheme.headlineMedium,
          ),
          const SizedBox(height: 16),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.download, color: Colors.orange),
                  title: const Text('从剪贴板导入'),
                  subtitle: const Text('粘贴JSON数据导入时间线'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => _showImportDialog(context),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.system_update_alt, color: Colors.purple),
                  title: const Text('加载示例数据'),
                  subtitle: const Text('加载预设的示例时间线'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => _loadSampleData(context),
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),

          // 危险操作部分
          Text(
            '危险操作',
            style: theme.textTheme.headlineMedium?.copyWith(
              color: Colors.red,
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: ListTile(
              leading: const Icon(Icons.delete_forever, color: Colors.red),
              title: const Text('清空所有数据', style: TextStyle(color: Colors.red)),
              subtitle: const Text('删除所有时间线和事件（不可撤销）'),
              trailing: const Icon(Icons.chevron_right, color: Colors.red),
              onTap: () => _showClearDataDialog(context),
            ),
          ),

          const SizedBox(height: 32),

          // 数据统计
          Consumer<TimelineProvider>(
            builder: (context, provider, child) {
              final stats = _getDataStats(provider);
              return Card(
                color: Colors.blue.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(AppConstants.defaultPadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '数据统计',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      _StatRow(
                        icon: Icons.timeline,
                        label: '时间线总数',
                        value: '${stats['timelineCount']}',
                      ),
                      _StatRow(
                        icon: Icons.event,
                        label: '事件总数',
                        value: '${stats['eventCount']}',
                      ),
                      _StatRow(
                        icon: Icons.star,
                        label: '重要事件',
                        value: '${stats['importantCount']}',
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Map<String, int> _getDataStats(TimelineProvider provider) {
    int eventCount = 0;
    int importantCount = 0;

    for (final timeline in provider.timelines) {
      eventCount += timeline.events.length;
      importantCount += timeline.events.where((e) => e.isImportant).length;
    }

    return {
      'timelineCount': provider.timelines.length,
      'eventCount': eventCount,
      'importantCount': importantCount,
    };
  }

  void _showExportAllDialog(BuildContext context) {
    final provider = context.read<TimelineProvider>();
    final service = ImportExportService();

    if (provider.timelines.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('没有可导出的时间线')),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('导出所有时间线'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('将导出 ${provider.timelines.length} 个时间线'),
              const SizedBox(height: 16),
              const Text('数据将被复制到剪贴板，您可以保存到文件中。'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('取消'),
            ),
            ElevatedButton(
              onPressed: () {
                try {
                  final jsonString = service.exportTimelinesToJson(provider.timelines);
                  Clipboard.setData(ClipboardData(text: jsonString));
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('数据已复制到剪贴板')),
                  );
                } catch (e) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('导出失败: $e')),
                  );
                }
              },
              child: const Text('导出'),
            ),
          ],
        );
      },
    );
  }

  void _showExportSingleDialog(BuildContext context) {
    final provider = context.read<TimelineProvider>();
    final service = ImportExportService();

    if (provider.timelines.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('没有可导出的时间线')),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('选择要导出的时间线'),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: provider.timelines.length,
              itemBuilder: (context, index) {
                final timeline = provider.timelines[index];
                return ListTile(
                  leading: Text(timeline.category.icon, style: const TextStyle(fontSize: 24)),
                  title: Text(timeline.name),
                  subtitle: Text('${timeline.events.length} 个事件'),
                  onTap: () {
                    try {
                      final jsonString = service.exportTimelineToJson(timeline);
                      Clipboard.setData(ClipboardData(text: jsonString));
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('${timeline.name} 已复制到剪贴板')),
                      );
                    } catch (e) {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('导出失败: $e')),
                      );
                    }
                  },
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('取消'),
            ),
          ],
        );
      },
    );
  }

  void _showImportDialog(BuildContext context) {
    final controller = TextEditingController();
    final service = ImportExportService();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('从剪贴板导入'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('粘贴JSON格式的时间线数据：'),
              const SizedBox(height: 16),
              TextField(
                controller: controller,
                decoration: const InputDecoration(
                  hintText: '粘贴JSON数据...',
                  border: OutlineInputBorder(),
                ),
                maxLines: 10,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('取消'),
            ),
            ElevatedButton(
              onPressed: () async {
                final jsonString = controller.text.trim();
                if (jsonString.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('请输入JSON数据')),
                  );
                  return;
                }

                if (!service.validateJsonFormat(jsonString)) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('JSON格式无效')),
                  );
                  return;
                }

                try {
                  final provider = context.read<TimelineProvider>();

                  // 尝试作为数组解析
                  try {
                    final timelines = service.importTimelinesFromJson(jsonString);
                    for (final timeline in timelines) {
                      await provider.addTimeline(timeline);
                    }
                    if (context.mounted) {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('成功导入 ${timelines.length} 个时间线')),
                      );
                    }
                  } catch (_) {
                    // 尝试作为单个对象解析
                    final timeline = service.importTimelineFromJson(jsonString);
                    await provider.addTimeline(timeline);
                    if (context.mounted) {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('时间线导入成功')),
                      );
                    }
                  }
                } catch (e) {
                  if (context.mounted) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('导入失败: $e')),
                    );
                  }
                }
              },
              child: const Text('导入'),
            ),
          ],
        );
      },
    );
  }

  void _loadSampleData(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('加载示例数据'),
          content: const Text('这将加载3个示例时间线（中国改革开放、乔布斯生平、阿凡达2宣发）'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('取消'),
            ),
            ElevatedButton(
              onPressed: () async {
                final provider = context.read<TimelineProvider>();
                final sampleTimelines = SampleData.generateSampleTimelines();

                for (final timeline in sampleTimelines) {
                  await provider.addTimeline(timeline);
                }

                if (context.mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('已加载 ${sampleTimelines.length} 个示例时间线')),
                  );
                }
              },
              child: const Text('加载'),
            ),
          ],
        );
      },
    );
  }

  void _showClearDataDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('清空所有数据'),
          content: const Text('确定要删除所有时间线和事件吗？\n\n此操作无法撤销！建议先导出备份。'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('取消'),
            ),
            TextButton(
              onPressed: () async {
                final provider = context.read<TimelineProvider>();
                final timelines = List.from(provider.timelines);

                for (final timeline in timelines) {
                  await provider.deleteTimeline(timeline.id);
                }

                if (context.mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('所有数据已清空')),
                  );
                }
              },
              child: const Text('确定删除', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }
}

class _StatRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _StatRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.blue.shade700),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(fontSize: 14),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
