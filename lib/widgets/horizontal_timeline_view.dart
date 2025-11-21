import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/models.dart';
import '../constants/app_constants.dart';

/// 横向时间线视图组件
class HorizontalTimelineView extends StatefulWidget {
  final Timeline timeline;
  final Function(TimelineEvent)? onEventTap;

  const HorizontalTimelineView({
    super.key,
    required this.timeline,
    this.onEventTap,
  });

  @override
  State<HorizontalTimelineView> createState() => _HorizontalTimelineViewState();
}

class _HorizontalTimelineViewState extends State<HorizontalTimelineView> {
  final ScrollController _scrollController = ScrollController();
  int? _selectedIndex;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final events = widget.timeline.sortedEvents;

    if (events.isEmpty) {
      return const Center(
        child: Text('还没有事件'),
      );
    }

    return Column(
      children: [
        // 时间轴
        Expanded(
          child: ListView.builder(
            controller: _scrollController,
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(
              horizontal: AppConstants.defaultPadding,
              vertical: AppConstants.largePadding,
            ),
            itemCount: events.length,
            itemBuilder: (context, index) {
              final event = events[index];
              final isSelected = _selectedIndex == index;

              return _HorizontalEventCard(
                event: event,
                isFirst: index == 0,
                isLast: index == events.length - 1,
                isSelected: isSelected,
                onTap: () {
                  setState(() {
                    _selectedIndex = index;
                  });
                  widget.onEventTap?.call(event);
                },
              );
            },
          ),
        ),

        // 选中事件的详情预览
        if (_selectedIndex != null && _selectedIndex! < events.length)
          _EventDetailPreview(
            event: events[_selectedIndex!],
            onClose: () {
              setState(() {
                _selectedIndex = null;
              });
            },
          ),
      ],
    );
  }
}

class _HorizontalEventCard extends StatelessWidget {
  final TimelineEvent event;
  final bool isFirst;
  final bool isLast;
  final bool isSelected;
  final VoidCallback onTap;

  const _HorizontalEventCard({
    required this.event,
    required this.isFirst,
    required this.isLast,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final eventColor = _getEventTypeColor(event.type);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 事件卡片
        GestureDetector(
          onTap: onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            width: isSelected ? 280 : 240,
            margin: const EdgeInsets.only(right: 16),
            child: Column(
              children: [
                // 时间点圆圈
                Container(
                  width: isSelected ? 32 : 24,
                  height: isSelected ? 32 : 24,
                  decoration: BoxDecoration(
                    color: eventColor,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white,
                      width: 3,
                    ),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: eventColor.withOpacity(0.5),
                              blurRadius: 12,
                              spreadRadius: 2,
                            )
                          ]
                        : null,
                  ),
                  child: event.isImportant
                      ? Icon(
                          Icons.star,
                          color: Colors.white,
                          size: isSelected ? 16 : 12,
                        )
                      : null,
                ),

                // 连接线
                Container(
                  width: 3,
                  height: 20,
                  color: eventColor.withOpacity(0.3),
                ),

                // 事件卡片
                Expanded(
                  child: AnimatedScale(
                    duration: const Duration(milliseconds: 300),
                    scale: isSelected ? 1.05 : 1.0,
                    child: Card(
                      elevation: isSelected ? 8 : 2,
                      color: isSelected
                          ? eventColor.withOpacity(0.05)
                          : theme.cardColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppConstants.defaultRadius),
                        side: isSelected
                            ? BorderSide(color: eventColor, width: 2)
                            : BorderSide.none,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(AppConstants.defaultPadding),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // 日期
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: eventColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                DateFormat('yyyy/MM/dd').format(event.timestamp),
                                style: TextStyle(
                                  fontSize: 12,
                                  color: eventColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),

                            // 标题
                            Text(
                              event.title,
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 8),

                            // 描述
                            Expanded(
                              child: Text(
                                event.description,
                                style: theme.textTheme.bodySmall,
                                maxLines: isSelected ? 5 : 3,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),

                            // 标签
                            if (event.tags.isNotEmpty) ...[
                              const SizedBox(height: 8),
                              Wrap(
                                spacing: 4,
                                runSpacing: 4,
                                children: event.tags.take(2).map((tag) {
                                  return Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 6,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      color: eventColor.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      tag,
                                      style: TextStyle(
                                        fontSize: 10,
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
              ],
            ),
          ),
        ),

        // 连接线（到下一个事件）
        if (!isLast)
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 3,
            color: eventColor.withOpacity(0.3),
          ),
      ],
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

class _EventDetailPreview extends StatelessWidget {
  final TimelineEvent event;
  final VoidCallback onClose;

  const _EventDetailPreview({
    required this.event,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final eventColor = _getEventTypeColor(event.type);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: 200,
      decoration: BoxDecoration(
        color: theme.cardColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SingleChildScrollView(
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
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: onClose,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.access_time, size: 16, color: Colors.grey.shade600),
                const SizedBox(width: 4),
                Text(
                  DateFormat(AppConstants.dateFormatFull).format(event.timestamp),
                  style: theme.textTheme.bodyMedium,
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              event.description,
              style: theme.textTheme.bodyLarge,
            ),
            if (event.tags.isNotEmpty) ...[
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: event.tags.map((tag) {
                  return Chip(
                    label: Text(tag),
                    backgroundColor: eventColor.withOpacity(0.1),
                    labelStyle: TextStyle(
                      color: eventColor,
                      fontSize: 12,
                    ),
                  );
                }).toList(),
              ),
            ],
          ],
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
}
