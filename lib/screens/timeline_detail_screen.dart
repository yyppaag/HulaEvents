import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:timeline_tile/timeline_tile.dart';
import '../providers/timeline_provider.dart';
import '../models/models.dart';
import '../constants/app_constants.dart';
import 'create_event_screen.dart';

class TimelineDetailScreen extends StatelessWidget {
  const TimelineDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('时间线详情'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              // TODO: 编辑时间线
            },
          ),
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {
              _showMoreOptions(context);
            },
          ),
        ],
      ),
      body: Consumer<TimelineProvider>(
        builder: (context, provider, child) {
          final timeline = provider.selectedTimeline;

          if (timeline == null) {
            return const Center(
              child: Text('未找到时间线'),
            );
          }

          final sortedEvents = timeline.sortedEvents;

          return Column(
            children: [
              // 时间线头部信息
              _TimelineHeader(timeline: timeline),

              // 时间线事件列表
              Expanded(
                child: sortedEvents.isEmpty
                    ? _EmptyTimelineView()
                    : ListView.builder(
                        padding: const EdgeInsets.all(AppConstants.defaultPadding),
                        itemCount: sortedEvents.length,
                        itemBuilder: (context, index) {
                          final event = sortedEvents[index];
                          final isFirst = index == 0;
                          final isLast = index == sortedEvents.length - 1;

                          return _TimelineEventTile(
                            event: event,
                            isFirst: isFirst,
                            isLast: isLast,
                            timelineId: timeline.id,
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          final provider = context.read<TimelineProvider>();
          final timeline = provider.selectedTimeline;
          if (timeline != null) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CreateEventScreen(
                  timelineId: timeline.id,
                ),
              ),
            );
          }
        },
        icon: const Icon(Icons.add),
        label: const Text('添加事件'),
      ),
    );
  }

  void _showMoreOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.share),
                title: const Text('分享时间线'),
                onTap: () {
                  Navigator.pop(context);
                  // TODO: 分享功能
                },
              ),
              ListTile(
                leading: const Icon(Icons.download),
                title: const Text('导出为JSON'),
                onTap: () {
                  Navigator.pop(context);
                  // TODO: 导出功能
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete, color: Colors.red),
                title: const Text('删除时间线', style: TextStyle(color: Colors.red)),
                onTap: () {
                  Navigator.pop(context);
                  _showDeleteConfirmation(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('删除时间线'),
          content: const Text('确定要删除这条时间线吗？此操作无法撤销。'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('取消'),
            ),
            TextButton(
              onPressed: () async {
                final provider = context.read<TimelineProvider>();
                final timeline = provider.selectedTimeline;
                if (timeline != null) {
                  await provider.deleteTimeline(timeline.id);
                  if (context.mounted) {
                    Navigator.pop(context); // 关闭对话框
                    Navigator.pop(context); // 返回主页
                  }
                }
              },
              child: const Text('删除', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }
}

class _TimelineHeader extends StatelessWidget {
  final Timeline timeline;

  const _TimelineHeader({required this.timeline});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppConstants.largePadding),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            _getEventTypeColor(timeline.category).withOpacity(0.2),
            _getEventTypeColor(timeline.category).withOpacity(0.05),
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                timeline.category.icon,
                style: const TextStyle(fontSize: 40),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      timeline.name,
                      style: theme.textTheme.displaySmall,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      timeline.category.displayName,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: _getEventTypeColor(timeline.category),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (timeline.description.isNotEmpty) ...[
            const SizedBox(height: 16),
            Text(
              timeline.description,
              style: theme.textTheme.bodyLarge,
            ),
          ],
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _StatChip(
                icon: Icons.event,
                label: '${timeline.eventCount} 个事件',
              ),
              if (timeline.durationInDays > 0)
                _StatChip(
                  icon: Icons.date_range,
                  label: '${timeline.durationInDays} 天',
                ),
              if (timeline.earliestEventTime != null)
                _StatChip(
                  icon: Icons.calendar_today,
                  label: DateFormat('yyyy/MM/dd').format(timeline.earliestEventTime!),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getEventTypeColor(EventType type) {
    switch (type) {
      case EventType.history:
        return const Color(0xFF3B82F6);
      case EventType.biography:
        return const Color(0xFF10B981);
      case EventType.movie:
        return const Color(0xFFF59E0B);
      case EventType.project:
        return const Color(0xFF8B5CF6);
      case EventType.custom:
        return const Color(0xFF6B7280);
    }
  }
}

class _StatChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _StatChip({
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(fontSize: 13),
          ),
        ],
      ),
    );
  }
}

class _TimelineEventTile extends StatelessWidget {
  final TimelineEvent event;
  final bool isFirst;
  final bool isLast;
  final String timelineId;

  const _TimelineEventTile({
    required this.event,
    required this.isFirst,
    required this.isLast,
    required this.timelineId,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final eventColor = _getEventTypeColor(event.type);

    return TimelineTile(
      isFirst: isFirst,
      isLast: isLast,
      beforeLineStyle: LineStyle(
        color: eventColor.withOpacity(0.3),
        thickness: 3,
      ),
      indicatorStyle: IndicatorStyle(
        width: 30,
        height: 30,
        indicator: Container(
          decoration: BoxDecoration(
            color: eventColor,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 3),
          ),
          child: event.isImportant
              ? const Icon(Icons.star, color: Colors.white, size: 16)
              : null,
        ),
      ),
      endChild: Container(
        margin: const EdgeInsets.only(left: 16, bottom: 24),
        child: Card(
          child: InkWell(
            onTap: () {
              _showEventDetail(context, event, timelineId);
            },
            borderRadius: BorderRadius.circular(AppConstants.defaultRadius),
            child: Padding(
              padding: const EdgeInsets.all(AppConstants.defaultPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          event.title,
                          style: theme.textTheme.headlineSmall,
                        ),
                      ),
                      if (event.isImportant)
                        Icon(
                          Icons.star,
                          color: Colors.amber.shade600,
                          size: 20,
                        ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        size: 14,
                        color: Colors.grey.shade600,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        DateFormat(AppConstants.dateFormatFull).format(event.timestamp),
                        style: theme.textTheme.bodySmall,
                      ),
                    ],
                  ),
                  if (event.description.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    Text(
                      event.description,
                      style: theme.textTheme.bodyMedium,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                  if (event.tags.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: event.tags.map((tag) {
                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: eventColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            tag,
                            style: TextStyle(
                              fontSize: 11,
                              color: eventColor,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Color _getEventTypeColor(EventType type) {
    switch (type) {
      case EventType.history:
        return const Color(0xFF3B82F6);
      case EventType.biography:
        return const Color(0xFF10B981);
      case EventType.movie:
        return const Color(0xFFF59E0B);
      case EventType.project:
        return const Color(0xFF8B5CF6);
      case EventType.custom:
        return const Color(0xFF6B7280);
    }
  }

  void _showEventDetail(BuildContext context, TimelineEvent event, String timelineId) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.7,
          minChildSize: 0.5,
          maxChildSize: 0.95,
          expand: false,
          builder: (context, scrollController) {
            return SingleChildScrollView(
              controller: scrollController,
              padding: const EdgeInsets.all(AppConstants.largePadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    event.title,
                    style: Theme.of(context).textTheme.displaySmall,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Icon(Icons.access_time, size: 16, color: Colors.grey.shade600),
                      const SizedBox(width: 8),
                      Text(
                        DateFormat(AppConstants.dateFormatFull).format(event.timestamp),
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    event.description,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  if (event.tags.isNotEmpty) ...[
                    const SizedBox(height: 24),
                    Text(
                      '标签',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: event.tags.map((tag) {
                        return Chip(
                          label: Text(tag),
                          backgroundColor: _getEventTypeColor(event.type).withOpacity(0.1),
                        );
                      }).toList(),
                    ),
                  ],
                  const SizedBox(height: 32),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CreateEventScreen(
                                  timelineId: timelineId,
                                  event: event,
                                ),
                              ),
                            );
                          },
                          icon: const Icon(Icons.edit),
                          label: const Text('编辑'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () async {
                            Navigator.pop(context);
                            // 显示删除确认对话框
                            final confirmed = await showDialog<bool>(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('删除事件'),
                                content: const Text('确定要删除这个事件吗？此操作无法撤销。'),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context, false),
                                    child: const Text('取消'),
                                  ),
                                  TextButton(
                                    onPressed: () => Navigator.pop(context, true),
                                    child: const Text(
                                      '删除',
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  ),
                                ],
                              ),
                            );
                            if (confirmed == true && context.mounted) {
                              await context.read<TimelineProvider>()
                                  .removeEventFromTimeline(timelineId, event.id);
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('事件已删除')),
                                );
                              }
                            }
                          },
                          icon: const Icon(Icons.delete, color: Colors.red),
                          label: const Text('删除', style: TextStyle(color: Colors.red)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

class _EmptyTimelineView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.event_note,
            size: 80,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 24),
          Text(
            '还没有事件',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 8),
          Text(
            '点击下方按钮添加第一个事件',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}
