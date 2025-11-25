import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/router/app_router.dart';
import '../providers/timeline_providers.dart';
import '../widgets/timeline_card.dart';

/// Home screen displaying list of timelines
class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Load timelines when screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(timelinesProvider.notifier).loadTimelines();
    });
  }

  @override
  Widget build(BuildContext context) {
    final timelinesState = ref.watch(timelinesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppConstants.appName),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // TODO: Implement search functionality
            },
          ),
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {
              // TODO: Show more options
            },
          ),
        ],
      ),
      body: _buildBody(timelinesState),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          context.push(AppRoutes.createTimeline);
        },
        icon: const Icon(Icons.add),
        label: const Text('创建时间线'),
      ),
    );
  }

  Widget _buildBody(timelinesState) {
    if (timelinesState.isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (timelinesState.errorMessage != null) {
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
              timelinesState.errorMessage!,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                ref.read(timelinesProvider.notifier).clearError();
                ref.read(timelinesProvider.notifier).loadTimelines();
              },
              child: const Text('重试'),
            ),
          ],
        ),
      );
    }

    if (timelinesState.timelines.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.timeline,
              size: 80,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 24),
            Text(
              '还没有时间线',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            Text(
              '点击下方按钮创建你的第一条时间线',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () => ref.read(timelinesProvider.notifier).loadTimelines(),
      child: ListView.builder(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        itemCount: timelinesState.timelines.length,
        itemBuilder: (context, index) {
          final timeline = timelinesState.timelines[index];
          return TimelineCard(
            timeline: timeline,
            onTap: () {
              context.push(AppRoutes.timelineDetailPath(timeline.id));
            },
          );
        },
      ),
    );
  }
}
