import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_constants.dart';
import '../../domain/entities/timeline.dart';

/// Timeline header widget for detail screen
class TimelineHeader extends StatelessWidget {
  final Timeline timeline;

  const TimelineHeader({
    super.key,
    required this.timeline,
  });

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
            timeline.category.color.withOpacity(0.2),
            timeline.category.color.withOpacity(0.05),
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
                        color: timeline.category.color,
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
