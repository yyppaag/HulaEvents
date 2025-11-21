import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/models.dart';
import '../constants/app_constants.dart';

/// 日历视图组件
class CalendarView extends StatefulWidget {
  final Timeline timeline;
  final Function(TimelineEvent)? onEventTap;

  const CalendarView({
    super.key,
    required this.timeline,
    this.onEventTap,
  });

  @override
  State<CalendarView> createState() => _CalendarViewState();
}

class _CalendarViewState extends State<CalendarView> {
  late DateTime _focusedMonth;
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    // 初始化为第一个事件的月份，如果没有事件则为当前月份
    final events = widget.timeline.sortedEvents;
    _focusedMonth = events.isNotEmpty
        ? DateTime(events.first.timestamp.year, events.first.timestamp.month)
        : DateTime.now();
  }

  void _previousMonth() {
    setState(() {
      _focusedMonth = DateTime(_focusedMonth.year, _focusedMonth.month - 1);
    });
  }

  void _nextMonth() {
    setState(() {
      _focusedMonth = DateTime(_focusedMonth.year, _focusedMonth.month + 1);
    });
  }

  void _goToToday() {
    setState(() {
      _focusedMonth = DateTime(DateTime.now().year, DateTime.now().month);
      _selectedDate = DateTime.now();
    });
  }

  List<TimelineEvent> _getEventsForDate(DateTime date) {
    return widget.timeline.events.where((event) {
      return event.timestamp.year == date.year &&
          event.timestamp.month == date.month &&
          event.timestamp.day == date.day;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        // 月份导航
        Container(
          padding: const EdgeInsets.all(AppConstants.defaultPadding),
          decoration: BoxDecoration(
            color: theme.cardColor,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.chevron_left),
                onPressed: _previousMonth,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Center(
                  child: Text(
                    DateFormat('yyyy年 MM月').format(_focusedMonth),
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                icon: const Icon(Icons.chevron_right),
                onPressed: _nextMonth,
              ),
              const SizedBox(width: 8),
              TextButton.icon(
                onPressed: _goToToday,
                icon: const Icon(Icons.today, size: 18),
                label: const Text('今天'),
              ),
            ],
          ),
        ),

        // 星期标题
        Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: ['日', '一', '二', '三', '四', '五', '六'].map((day) {
              return Expanded(
                child: Center(
                  child: Text(
                    day,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),

        // 日历网格
        Expanded(
          child: _buildCalendarGrid(theme),
        ),

        // 选中日期的事件列表
        if (_selectedDate != null) _buildSelectedDateEvents(theme),
      ],
    );
  }

  Widget _buildCalendarGrid(ThemeData theme) {
    final firstDayOfMonth = DateTime(_focusedMonth.year, _focusedMonth.month, 1);
    final lastDayOfMonth = DateTime(_focusedMonth.year, _focusedMonth.month + 1, 0);
    final daysInMonth = lastDayOfMonth.day;
    final firstWeekday = firstDayOfMonth.weekday % 7; // 0 = 周日

    final days = <Widget>[];

    // 添加空白占位
    for (int i = 0; i < firstWeekday; i++) {
      days.add(const SizedBox());
    }

    // 添加日期
    for (int day = 1; day <= daysInMonth; day++) {
      final date = DateTime(_focusedMonth.year, _focusedMonth.month, day);
      final events = _getEventsForDate(date);
      final isSelected = _selectedDate != null &&
          _selectedDate!.year == date.year &&
          _selectedDate!.month == date.month &&
          _selectedDate!.day == date.day;
      final isToday = DateTime.now().year == date.year &&
          DateTime.now().month == date.month &&
          DateTime.now().day == date.day;

      days.add(_CalendarDayCell(
        date: date,
        events: events,
        isSelected: isSelected,
        isToday: isToday,
        onTap: () {
          setState(() {
            _selectedDate = date;
          });
        },
      ));
    }

    return GridView.count(
      crossAxisCount: 7,
      padding: const EdgeInsets.all(AppConstants.smallPadding),
      mainAxisSpacing: 4,
      crossAxisSpacing: 4,
      children: days,
    );
  }

  Widget _buildSelectedDateEvents(ThemeData theme) {
    final events = _getEventsForDate(_selectedDate!);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: 250,
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(AppConstants.defaultPadding),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    DateFormat('yyyy年MM月dd日').format(_selectedDate!),
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Text(
                  '${events.length} 个事件',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.grey.shade600,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    setState(() {
                      _selectedDate = null;
                    });
                  },
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: events.isEmpty
                ? const Center(
                    child: Text('这一天没有事件'),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(AppConstants.smallPadding),
                    itemCount: events.length,
                    itemBuilder: (context, index) {
                      final event = events[index];
                      return _EventListItem(
                        event: event,
                        onTap: () {
                          widget.onEventTap?.call(event);
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class _CalendarDayCell extends StatelessWidget {
  final DateTime date;
  final List<TimelineEvent> events;
  final bool isSelected;
  final bool isToday;
  final VoidCallback onTap;

  const _CalendarDayCell({
    required this.date,
    required this.events,
    required this.isSelected,
    required this.isToday,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasEvents = events.isNotEmpty;
    final importantEvents = events.where((e) => e.isImportant).length;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        decoration: BoxDecoration(
          color: isSelected
              ? theme.colorScheme.primary.withOpacity(0.1)
              : null,
          border: isToday
              ? Border.all(color: theme.colorScheme.primary, width: 2)
              : null,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Stack(
          children: [
            // 日期数字
            Center(
              child: Text(
                '${date.day}',
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: isToday || hasEvents
                      ? FontWeight.bold
                      : FontWeight.normal,
                  color: isSelected
                      ? theme.colorScheme.primary
                      : null,
                ),
              ),
            ),

            // 事件指示器
            if (hasEvents)
              Positioned(
                bottom: 4,
                left: 0,
                right: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ...List.generate(
                      events.length.clamp(0, 3),
                      (index) {
                        final event = events[index];
                        return Container(
                          width: 6,
                          height: 6,
                          margin: const EdgeInsets.symmetric(horizontal: 1),
                          decoration: BoxDecoration(
                            color: _getEventTypeColor(event.type),
                            shape: BoxShape.circle,
                          ),
                        );
                      },
                    ),
                    if (events.length > 3)
                      Container(
                        margin: const EdgeInsets.only(left: 2),
                        child: Text(
                          '+${events.length - 3}',
                          style: const TextStyle(fontSize: 8),
                        ),
                      ),
                  ],
                ),
              ),

            // 重要事件标记
            if (importantEvents > 0)
              Positioned(
                top: 2,
                right: 2,
                child: Icon(
                  Icons.star,
                  size: 12,
                  color: Colors.amber.shade600,
                ),
              ),
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

class _EventListItem extends StatelessWidget {
  final TimelineEvent event;
  final VoidCallback onTap;

  const _EventListItem({
    required this.event,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final eventColor = _getEventTypeColor(event.type);

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppConstants.smallRadius),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Container(
                width: 4,
                height: 40,
                decoration: BoxDecoration(
                  color: eventColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            event.title,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (event.isImportant)
                          Icon(
                            Icons.star,
                            size: 16,
                            color: Colors.amber.shade600,
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      DateFormat('HH:mm').format(event.timestamp),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: eventColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
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
}
