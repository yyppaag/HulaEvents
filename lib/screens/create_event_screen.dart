import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';
import '../providers/timeline_provider.dart';
import '../providers/user_provider.dart';
import '../models/models.dart';
import '../constants/app_constants.dart';
import 'user_profile_screen.dart';

class CreateEventScreen extends StatefulWidget {
  final String timelineId;
  final TimelineEvent? event; // 如果是编辑模式，传入现有事件

  const CreateEventScreen({
    super.key,
    required this.timelineId,
    this.event,
  });

  @override
  State<CreateEventScreen> createState() => _CreateEventScreenState();
}

class _CreateEventScreenState extends State<CreateEventScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _tagsController = TextEditingController();
  final _imageUrlController = TextEditingController();
  final _videoUrlController = TextEditingController();

  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();
  EventType _selectedType = EventType.history;
  bool _isImportant = false;
  bool _isSaving = false;
  List<String> _tags = [];

  bool get isEditMode => widget.event != null;

  @override
  void initState() {
    super.initState();
    if (isEditMode) {
      _loadEventData();
    }
  }

  void _loadEventData() {
    final event = widget.event!;
    _titleController.text = event.title;
    _descriptionController.text = event.description;
    _selectedDate = event.timestamp;
    _selectedTime = TimeOfDay.fromDateTime(event.timestamp);
    _selectedType = event.type;
    _isImportant = event.isImportant;
    _tags = List.from(event.tags);
    _imageUrlController.text = event.imageUrl ?? '';
    _videoUrlController.text = event.videoUrl ?? '';
    _tagsController.text = event.tags.join(', ');
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _tagsController.dispose();
    _imageUrlController.dispose();
    _videoUrlController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
      locale: const Locale('zh', 'CN'),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  void _updateTags(String value) {
    setState(() {
      _tags = value
          .split(',')
          .map((tag) => tag.trim())
          .where((tag) => tag.isNotEmpty)
          .toList();
    });
  }

  Future<void> _saveEvent() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // 如果是新增事件，检查权限
    if (!isEditMode) {
      final userProvider = context.read<UserProvider>();
      final timelineProvider = context.read<TimelineProvider>();
      final timeline = timelineProvider.timelines
          .firstWhere((t) => t.id == widget.timelineId);
      final currentEventCount = timeline.events.length;

      // 如果用户已登录，检查是否超出限制
      if (userProvider.isLoggedIn) {
        if (!userProvider.canCreateEvent(currentEventCount)) {
          _showUpgradeDialog();
          return;
        }
      } else {
        // 未登录用户限制为每条时间线10个事件
        if (currentEventCount >= 10) {
          _showLoginDialog();
          return;
        }
      }
    }

    setState(() {
      _isSaving = true;
    });

    try {
      final timestamp = DateTime(
        _selectedDate.year,
        _selectedDate.month,
        _selectedDate.day,
        _selectedTime.hour,
        _selectedTime.minute,
      );

      final event = TimelineEvent(
        id: isEditMode ? widget.event!.id : const Uuid().v4(),
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        timestamp: timestamp,
        type: _selectedType,
        tags: _tags,
        imageUrl: _imageUrlController.text.trim().isEmpty
            ? null
            : _imageUrlController.text.trim(),
        videoUrl: _videoUrlController.text.trim().isEmpty
            ? null
            : _videoUrlController.text.trim(),
        isImportant: _isImportant,
      );

      final provider = context.read<TimelineProvider>();
      if (isEditMode) {
        await provider.updateEventInTimeline(widget.timelineId, event);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('事件更新成功')),
          );
        }
      } else {
        await provider.addEventToTimeline(widget.timelineId, event);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('事件添加成功')),
          );
        }
      }

      if (mounted) {
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('保存失败: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  void _showUpgradeDialog() {
    final userProvider = context.read<UserProvider>();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('达到事件创建上限'),
        content: Text(
          '您当前是${userProvider.isPremium ? "高级会员" : "免费用户"}，'
          '单条时间线已达到事件创建上限（${userProvider.eventCreateLimit}个）。\n\n'
          '升级为专业会员即可添加无限个事件！',
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
          '游客模式下每条时间线最多只能添加10个事件。\n\n'
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
        title: Text(isEditMode ? '编辑事件' : '添加事件'),
        actions: [
          if (isEditMode)
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: _showDeleteConfirmation,
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 基本信息
              Text(
                '基本信息',
                style: theme.textTheme.headlineMedium,
              ),
              const SizedBox(height: 16),

              // 标题
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: '事件标题 *',
                  hintText: '例如：公司成立',
                  prefixIcon: Icon(Icons.title),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return '请输入事件标题';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // 描述
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: '事件描述 *',
                  hintText: '详细描述这个事件...',
                  prefixIcon: Icon(Icons.description),
                  alignLabelWithHint: true,
                ),
                maxLines: 5,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return '请输入事件描述';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              // 时间设置
              Text(
                '时间设置',
                style: theme.textTheme.headlineMedium,
              ),
              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: _selectDate,
                      borderRadius: BorderRadius.circular(8),
                      child: InputDecorator(
                        decoration: const InputDecoration(
                          labelText: '日期',
                          prefixIcon: Icon(Icons.calendar_today),
                        ),
                        child: Text(
                          DateFormat('yyyy年MM月dd日').format(_selectedDate),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: InkWell(
                      onTap: _selectTime,
                      borderRadius: BorderRadius.circular(8),
                      child: InputDecorator(
                        decoration: const InputDecoration(
                          labelText: '时间',
                          prefixIcon: Icon(Icons.access_time),
                        ),
                        child: Text(
                          _selectedTime.format(context),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // 事件类型
              Text(
                '事件类型',
                style: theme.textTheme.headlineMedium,
              ),
              const SizedBox(height: 16),
              _buildEventTypeSelector(),
              const SizedBox(height: 24),

              // 标签
              Text(
                '标签',
                style: theme.textTheme.headlineMedium,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _tagsController,
                decoration: const InputDecoration(
                  labelText: '标签（用逗号分隔）',
                  hintText: '例如：重要, 里程碑, 转折点',
                  prefixIcon: Icon(Icons.label),
                ),
                onChanged: _updateTags,
              ),
              if (_tags.isNotEmpty) ...[
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _tags.map((tag) {
                    return Chip(
                      label: Text(tag),
                      onDeleted: () {
                        setState(() {
                          _tags.remove(tag);
                          _tagsController.text = _tags.join(', ');
                        });
                      },
                      backgroundColor:
                          _getEventTypeColor(_selectedType).withOpacity(0.1),
                    );
                  }).toList(),
                ),
              ],
              const SizedBox(height: 24),

              // 多媒体
              Text(
                '多媒体（可选）',
                style: theme.textTheme.headlineMedium,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _imageUrlController,
                decoration: const InputDecoration(
                  labelText: '图片URL',
                  hintText: 'https://example.com/image.jpg',
                  prefixIcon: Icon(Icons.image),
                ),
                keyboardType: TextInputType.url,
                onChanged: (value) {
                  // 触发重新渲染以显示图片预览
                  setState(() {});
                },
              ),
              if (_imageUrlController.text.trim().isNotEmpty) ...[
                const SizedBox(height: 16),
                ClipRRect(
                  borderRadius: BorderRadius.circular(AppConstants.defaultRadius),
                  child: Image.network(
                    _imageUrlController.text.trim(),
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 200,
                        color: Colors.grey.shade200,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.broken_image, size: 48, color: Colors.grey.shade400),
                            const SizedBox(height: 8),
                            Text(
                              '无法加载图片',
                              style: TextStyle(color: Colors.grey.shade600),
                            ),
                          ],
                        ),
                      );
                    },
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                        height: 200,
                        color: Colors.grey.shade100,
                        child: Center(
                          child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes!
                                : null,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
              const SizedBox(height: 16),
              TextFormField(
                controller: _videoUrlController,
                decoration: const InputDecoration(
                  labelText: '视频URL',
                  hintText: 'https://example.com/video.mp4',
                  prefixIcon: Icon(Icons.video_library),
                ),
                keyboardType: TextInputType.url,
              ),
              const SizedBox(height: 24),

              // 重要事件标记
              Card(
                child: SwitchListTile(
                  title: const Text('标记为重要事件'),
                  subtitle: const Text('重要事件会在时间线上以星标突出显示'),
                  value: _isImportant,
                  onChanged: (value) {
                    setState(() {
                      _isImportant = value;
                    });
                  },
                  secondary: Icon(
                    Icons.star,
                    color: _isImportant ? Colors.amber : Colors.grey,
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // 保存按钮
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isSaving ? null : _saveEvent,
                  child: _isSaving
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : Text(
                          isEditMode ? '保存更改' : '添加事件',
                          style: const TextStyle(fontSize: 16),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEventTypeSelector() {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: EventType.values.map((type) {
        final isSelected = _selectedType == type;
        return ChoiceChip(
          label: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(type.icon),
              const SizedBox(width: 6),
              Text(type.displayName),
            ],
          ),
          selected: isSelected,
          onSelected: (selected) {
            if (selected) {
              setState(() {
                _selectedType = type;
              });
            }
          },
          selectedColor: _getEventTypeColor(type).withOpacity(0.2),
          backgroundColor: Colors.grey.shade100,
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

  void _showDeleteConfirmation() {
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
                final provider = context.read<TimelineProvider>();
                await provider.removeEventFromTimeline(
                  widget.timelineId,
                  widget.event!.id,
                );
                if (mounted) {
                  Navigator.pop(context); // 关闭对话框
                  Navigator.pop(context); // 返回到详情页
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
