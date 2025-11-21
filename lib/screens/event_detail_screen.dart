import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/models.dart';
import '../providers/timeline_provider.dart';
import '../constants/app_constants.dart';
import 'create_event_screen.dart';

class EventDetailScreen extends StatelessWidget {
  final TimelineEvent event;
  final String timelineId;

  const EventDetailScreen({
    super.key,
    required this.event,
    required this.timelineId,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final eventColor = _getEventTypeColor(event.type);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // 可折叠的AppBar
          SliverAppBar(
            expandedHeight: event.imageUrl != null ? 300 : 150,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                event.title,
                style: const TextStyle(
                  shadows: [
                    Shadow(
                      offset: Offset(0, 1),
                      blurRadius: 3.0,
                      color: Color.fromARGB(128, 0, 0, 0),
                    ),
                  ],
                ),
              ),
              background: event.imageUrl != null
                  ? Stack(
                      fit: StackFit.expand,
                      children: [
                        Hero(
                          tag: 'event-image-${event.id}',
                          child: CachedNetworkImage(
                            imageUrl: event.imageUrl!,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Container(
                              color: Colors.grey.shade200,
                              child: const Center(
                                child: CircularProgressIndicator(),
                              ),
                            ),
                            errorWidget: (context, url, error) => Container(
                              color: Colors.grey.shade300,
                              child: const Icon(Icons.broken_image, size: 64),
                            ),
                          ),
                        ),
                        // 渐变遮罩
                        const DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                Colors.black54,
                              ],
                            ),
                          ),
                        ),
                      ],
                    )
                  : Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            eventColor.withOpacity(0.7),
                            eventColor.withOpacity(0.3),
                          ],
                        ),
                      ),
                    ),
            ),
          ),

          // 内容部分
          SliverPadding(
            padding: const EdgeInsets.all(AppConstants.defaultPadding),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // 时间和类型信息
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(AppConstants.defaultPadding),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: eventColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(
                                Icons.access_time,
                                color: eventColor,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '时间',
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    DateFormat(AppConstants.dateFormatFull)
                                        .format(event.timestamp),
                                    style: theme.textTheme.bodyLarge?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (event.isImportant)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.amber.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.star,
                                      size: 16,
                                      color: Colors.amber.shade700,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      '重要',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.amber.shade700,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: eventColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                event.type.icon,
                                style: const TextStyle(fontSize: 20),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '类型',
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  event.type.displayName,
                                  style: theme.textTheme.bodyLarge?.copyWith(
                                    color: eventColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // 描述部分
                Text(
                  '描述',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(AppConstants.defaultPadding),
                    child: Text(
                      event.description,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        height: 1.6,
                      ),
                    ),
                  ),
                ),

                // 标签部分
                if (event.tags.isNotEmpty) ...[
                  const SizedBox(height: 24),
                  Text(
                    '标签',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: event.tags.map((tag) {
                      return Hero(
                        tag: 'tag-$tag-${event.id}',
                        child: Material(
                          color: Colors.transparent,
                          child: Chip(
                            label: Text(tag),
                            backgroundColor: eventColor.withOpacity(0.1),
                            labelStyle: TextStyle(
                              color: eventColor,
                              fontWeight: FontWeight.w500,
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],

                // 视频链接
                if (event.videoUrl != null && event.videoUrl!.isNotEmpty) ...[
                  const SizedBox(height: 24),
                  Text(
                    '视频',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Card(
                    child: ListTile(
                      leading: Icon(Icons.play_circle_outline, color: eventColor),
                      title: const Text('查看视频'),
                      subtitle: Text(
                        event.videoUrl!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      trailing: const Icon(Icons.open_in_new),
                      onTap: () {
                        // TODO: 打开视频链接
                      },
                    ),
                  ),
                ],

                const SizedBox(height: 80), // 为FAB留出空间
              ]),
            ),
          ),
        ],
      ),

      // 操作按钮
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: 'edit-fab',
            onPressed: () {
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
            child: const Icon(Icons.edit),
          ),
          const SizedBox(height: 12),
          FloatingActionButton(
            heroTag: 'delete-fab',
            backgroundColor: Colors.red,
            onPressed: () => _showDeleteConfirmation(context),
            child: const Icon(Icons.delete),
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

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('删除事件'),
          content: const Text('确定要删除这个事件吗？此操作无法撤销。'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('取消'),
            ),
            TextButton(
              onPressed: () async {
                await context
                    .read<TimelineProvider>()
                    .removeEventFromTimeline(timelineId, event.id);
                if (context.mounted) {
                  Navigator.pop(context); // 关闭对话框
                  Navigator.pop(context); // 返回时间线页面
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('事件已删除')),
                  );
                }
              },
              child: const Text(
                '删除',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }
}
