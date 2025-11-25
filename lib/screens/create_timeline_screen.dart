import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../providers/timeline_provider.dart';
import '../providers/user_provider.dart';
import '../models/models.dart';
import '../constants/app_constants.dart';
import 'user_profile_screen.dart';

class CreateTimelineScreen extends StatefulWidget {
  const CreateTimelineScreen({super.key});

  @override
  State<CreateTimelineScreen> createState() => _CreateTimelineScreenState();
}

class _CreateTimelineScreenState extends State<CreateTimelineScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  EventType _selectedType = EventType.history;
  bool _isCreating = false;

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _createTimeline() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // 检查用户权限
    final userProvider = context.read<UserProvider>();
    final timelineProvider = context.read<TimelineProvider>();
    final currentTimelineCount = timelineProvider.timelines.length;

    // 如果用户已登录，检查是否超出限制
    if (userProvider.isLoggedIn) {
      if (!userProvider.canCreateTimeline(currentTimelineCount)) {
        _showUpgradeDialog();
        return;
      }
    } else {
      // 未登录用户限制为3个时间线
      if (currentTimelineCount >= 3) {
        _showLoginDialog();
        return;
      }
    }

    setState(() {
      _isCreating = true;
    });

    try {
      final timeline = Timeline(
        id: const Uuid().v4(),
        name: _nameController.text.trim(),
        description: _descriptionController.text.trim(),
        category: _selectedType,
        events: [],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await timelineProvider.addTimeline(timeline);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('时间线创建成功')),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('创建失败: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isCreating = false;
        });
      }
    }
  }

  void _showUpgradeDialog() {
    final userProvider = context.read<UserProvider>();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('达到时间线创建上限'),
        content: Text(
          '您当前是${userProvider.isPremium ? "高级会员" : "免费用户"}，'
          '已达到时间线创建上限（${userProvider.timelineCreateLimit}个）。\n\n'
          '升级为专业会员即可创建无限个时间线！',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('取消'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const UserProfileScreen(),
                ),
              );
            },
            child: const Text('查看会员'),
          ),
        ],
      ),
    );
  }

  void _showLoginDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('达到创建上限'),
        content: const Text(
          '游客模式下最多只能创建3个时间线。\n\n'
          '登录或注册后即可享受更多权限！',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('取消'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const UserProfileScreen(),
                ),
              );
            },
            child: const Text('去登录'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('创建时间线'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '基本信息',
                style: theme.textTheme.headlineMedium,
              ),
              const SizedBox(height: 24),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: '时间线名称',
                  hintText: '例如：中国近代史',
                  prefixIcon: Icon(Icons.title),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return '请输入时间线名称';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: '时间线描述',
                  hintText: '简要描述这条时间线的内容',
                  prefixIcon: Icon(Icons.description),
                ),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return '请输入时间线描述';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32),
              Text(
                '选择类型',
                style: theme.textTheme.headlineMedium,
              ),
              const SizedBox(height: 16),
              _buildEventTypeSelector(),
              const SizedBox(height: 48),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isCreating ? null : _createTimeline,
                  child: _isCreating
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : const Text('创建时间线', style: TextStyle(fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEventTypeSelector() {
    return Column(
      children: EventType.values.map((type) {
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: InkWell(
            onTap: () {
              setState(() {
                _selectedType = type;
              });
            },
            borderRadius: BorderRadius.circular(AppConstants.defaultRadius),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: _getEventTypeColor(type).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      type.icon,
                      style: const TextStyle(fontSize: 24),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      type.displayName,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                  Radio<EventType>(
                    value: type,
                    groupValue: _selectedType,
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          _selectedType = value;
                        });
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
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
