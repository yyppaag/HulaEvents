import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/timeline/presentation/screens/home_screen.dart';
import '../../features/timeline/presentation/screens/timeline_detail_screen.dart';
import '../../features/timeline/presentation/screens/create_timeline_screen.dart';
import '../../features/timeline/presentation/screens/create_event_screen.dart';

/// App route paths
abstract class AppRoutes {
  static const String home = '/';
  static const String timelineDetail = '/timeline/:id';
  static const String createTimeline = '/timeline/create';
  static const String createEvent = '/timeline/:id/event/create';

  /// Generate timeline detail path with id
  static String timelineDetailPath(String id) => '/timeline/$id';

  /// Generate create event path with timeline id
  static String createEventPath(String timelineId) =>
      '/timeline/$timelineId/event/create';
}

/// App router configuration
class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: AppRoutes.home,
    debugLogDiagnostics: true,
    routes: [
      GoRoute(
        path: AppRoutes.home,
        name: 'home',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: AppRoutes.createTimeline,
        name: 'createTimeline',
        builder: (context, state) => const CreateTimelineScreen(),
      ),
      GoRoute(
        path: AppRoutes.timelineDetail,
        name: 'timelineDetail',
        builder: (context, state) {
          final timelineId = state.pathParameters['id']!;
          return TimelineDetailScreen(timelineId: timelineId);
        },
      ),
      GoRoute(
        path: AppRoutes.createEvent,
        name: 'createEvent',
        builder: (context, state) {
          final timelineId = state.pathParameters['id']!;
          return CreateEventScreen(timelineId: timelineId);
        },
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
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
              'Page not found',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            Text(
              state.uri.toString(),
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.go(AppRoutes.home),
              child: const Text('Go Home'),
            ),
          ],
        ),
      ),
    ),
  );
}
