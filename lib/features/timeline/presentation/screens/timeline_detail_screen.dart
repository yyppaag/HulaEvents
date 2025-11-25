import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/router/app_router.dart';
import '../providers/timeline_providers.dart';
import '../widgets/timeline_header.dart';
import '../widgets/timeline_event_tile.dart';
import '../widgets/event_detail_sheet.dart';

/// Screen for displaying timeline details
class TimelineDetailScreen extends ConsumerStatefulWidget {
  final String timelineId;

  const TimelineDetailScreen({
    super.key,
    required this.timelineId,
  });

  @override
  ConsumerState<TimelineDetailScreen> createState() => _TimelineDetailScreenState();
}

class _TimelineDetailScreenState extends ConsumerState<TimelineDetailScreen> {
  @override
  void initState() {
    super.initState();
    // Load timeline details when screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(timelineDetailProvider(widget.timelineId).notifier).loadTimeline();
    });
  }

  @override
  Widget build(BuildContext context) {
    final timelineState = ref.watch(timelineDetailProvider(widget.timelineId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('时间线详情'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              // TODO: Edit timeline
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
      body: _buildBody(timelineState),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          context.push(AppRoutes.createEventPath(widget.timelineId));
        },
        icon: const Icon(Icons.add),
        label: const Text('添加事件'),
      ),
    );
  }

  Widget _buildBody(timelineState) {
    if (timelineState.isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (timelineState.errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red,
            ),
            const SizedBox(height: 16),
            Text(
              timelineState.errorMessage!,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                ref.read(timelineDetailProvider(widget.timelineId).notifier).clearError();
                ref.read(timelineDetailProvider(widget.timelineId).notifier).loadTimeline();
              },
              child: const Text('重试'),
            ),
          ],
        ),
      );
    }

    final timeline = timelineState.timeline;

    if (timeline == null) {
      return const Center(
        child: Text('未找到时间线'),
      );
    }

    final sortedEvents = timeline.sortedEvents;

    return Column(
      children: [
        // Timeline header
        TimelineHeader(timeline: timeline),

        // Timeline events list
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

                    return TimelineEventTile(
                      event: event,
                      isFirst: isFirst,
                      isLast: isLast,
                      onTap: () {
                        EventDetailSheet.show(
                          context,
                          event: event,
                          onEdit: () {
                            // TODO: Edit event
                          },
                          onDelete: () {
                            _showDeleteEventConfirmation(context, event.id);
                          },
                        );
                      },
                    );
                  },
                ),
        ),
      ],
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
                  // TODO: Share functionality
                },
              ),
              ListTile(
                leading: const Icon(Icons.download),
                title: const Text('导出为JSON'),
                onTap: () {
                  Navigator.pop(context);
                  // TODO: Export functionality
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete, color: Colors.red),
                title: const Text('删除时间线', style: TextStyle(color: Colors.red)),
                onTap: () {
                  Navigator.pop(context);
                  _showDeleteTimelineConfirmation(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showDeleteTimelineConfirmation(BuildContext context) {
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
                Navigator.pop(context); // Close dialog

                final success = await ref
                    .read(timelinesProvider.notifier)
                    .removeTimeline(widget.timelineId);

                if (mounted && success) {
                  context.go(AppRoutes.home);
                }
              },
              child: const Text('删除', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  void _showDeleteEventConfirmation(BuildContext context, String eventId) {
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
                Navigator.pop(context); // Close dialog

                final success = await ref
                    .read(timelineDetailProvider(widget.timelineId).notifier)
                    .deleteEvent(eventId);

                if (mounted && success) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('事件已删除')),
                  );
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
