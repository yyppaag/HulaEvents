import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/timeline_provider.dart';
import '../models/models.dart';
import '../constants/app_constants.dart';
import 'timeline_detail_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _searchController = TextEditingController();
  String _searchQuery = '';
  EventType? _selectedType;
  bool _onlyImportant = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('搜索'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(70),
          child: Padding(
            padding: const EdgeInsets.all(AppConstants.defaultPadding),
            child: TextField(
              controller: _searchController,
              autofocus: true,
              decoration: InputDecoration(
                hintText: '搜索时间线或事件...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          setState(() {
                            _searchController.clear();
                            _searchQuery = '';
                          });
                        },
                      )
                    : null,
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value.trim();
                });
              },
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          // 筛选条件
          _buildFilterSection(theme),
          const Divider(height: 1),

          // 搜索结果
          Expanded(
            child: Consumer<TimelineProvider>(
              builder: (context, provider, child) {
                final results = _getSearchResults(provider);

                if (_searchQuery.isEmpty && _selectedType == null && !_onlyImportant) {
                  return _buildEmptyState('输入关键词开始搜索');
                }

                if (results.isEmpty) {
                  return _buildEmptyState('未找到匹配结果');
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(AppConstants.defaultPadding),
                  itemCount: results.length,
                  itemBuilder: (context, index) {
                    final result = results[index];
                    return _SearchResultCard(result: result);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterSection(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      color: theme.cardColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '筛选条件',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              // 事件类型筛选
              ChoiceChip(
                label: const Text('全部类型'),
                selected: _selectedType == null,
                onSelected: (selected) {
                  if (selected) {
                    setState(() {
                      _selectedType = null;
                    });
                  }
                },
              ),
              ...EventType.values.map((type) {
                return ChoiceChip(
                  label: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(type.icon),
                      const SizedBox(width: 4),
                      Text(type.displayName),
                    ],
                  ),
                  selected: _selectedType == type,
                  onSelected: (selected) {
                    setState(() {
                      _selectedType = selected ? type : null;
                    });
                  },
                );
              }),
            ],
          ),
          const SizedBox(height: 8),
          FilterChip(
            label: const Text('仅显示重要事件'),
            selected: _onlyImportant,
            onSelected: (selected) {
              setState(() {
                _onlyImportant = selected;
              });
            },
            avatar: Icon(
              Icons.star,
              size: 18,
              color: _onlyImportant ? Colors.amber : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 80,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Colors.grey.shade600,
                ),
          ),
        ],
      ),
    );
  }

  List<SearchResult> _getSearchResults(TimelineProvider provider) {
    final results = <SearchResult>[];

    for (final timeline in provider.timelines) {
      // 检查时间线是否匹配
      final timelineMatches = _searchQuery.isEmpty ||
          timeline.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          timeline.description.toLowerCase().contains(_searchQuery.toLowerCase());

      // 筛选事件
      for (final event in timeline.events) {
        // 类型筛选
        if (_selectedType != null && event.type != _selectedType) {
          continue;
        }

        // 重要性筛选
        if (_onlyImportant && !event.isImportant) {
          continue;
        }

        // 关键词搜索
        final eventMatches = _searchQuery.isEmpty ||
            event.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            event.description.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            event.tags.any((tag) => tag.toLowerCase().contains(_searchQuery.toLowerCase()));

        if (timelineMatches || eventMatches) {
          results.add(SearchResult(
            timeline: timeline,
            event: event,
          ));
        }
      }
    }

    // 按时间排序
    results.sort((a, b) => b.event.timestamp.compareTo(a.event.timestamp));

    return results;
  }
}

class SearchResult {
  final Timeline timeline;
  final TimelineEvent event;

  SearchResult({
    required this.timeline,
    required this.event,
  });
}

class _SearchResultCard extends StatelessWidget {
  final SearchResult result;

  const _SearchResultCard({required this.result});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final event = result.event;
    final timeline = result.timeline;

    return Card(
      margin: const EdgeInsets.only(bottom: AppConstants.defaultPadding),
      child: InkWell(
        onTap: () {
          // 选择时间线并导航到详情页
          context.read<TimelineProvider>().selectTimeline(timeline);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const TimelineDetailScreen(),
            ),
          );
        },
        borderRadius: BorderRadius.circular(AppConstants.defaultRadius),
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.defaultPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 时间线标签
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _getEventTypeColor(timeline.category).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(timeline.category.icon, style: const TextStyle(fontSize: 12)),
                    const SizedBox(width: 4),
                    Text(
                      timeline.name,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: _getEventTypeColor(timeline.category),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // 事件标题
              Row(
                children: [
                  Expanded(
                    child: Text(
                      event.title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
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

              // 时间
              Row(
                children: [
                  Icon(Icons.access_time, size: 14, color: Colors.grey.shade600),
                  const SizedBox(width: 4),
                  Text(
                    DateFormat(AppConstants.dateFormatFull).format(event.timestamp),
                    style: theme.textTheme.bodySmall,
                  ),
                ],
              ),

              // 描述
              if (event.description.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  event.description,
                  style: theme.textTheme.bodyMedium,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],

              // 标签
              if (event.tags.isNotEmpty) ...[
                const SizedBox(height: 8),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: event.tags.take(3).map((tag) {
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: _getEventTypeColor(event.type).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        tag,
                        style: TextStyle(
                          fontSize: 11,
                          color: _getEventTypeColor(event.type),
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
