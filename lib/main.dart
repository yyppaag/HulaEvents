import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/constants/app_theme.dart';
import 'core/router/app_router.dart';
import 'features/timeline/data/datasources/timeline_local_datasource.dart';

void main() async {
  // Ensure Flutter bindings are initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize local storage
  await TimelineLocalDataSourceImpl().init();

  runApp(
    // Wrap the app with ProviderScope for Riverpod
    const ProviderScope(
      child: HulaEventsApp(),
    ),
  );
}

/// Main application widget
class HulaEventsApp extends StatelessWidget {
  const HulaEventsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Hula Events',
      debugShowCheckedModeBanner: false,

      // Theme configuration
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,

      // GoRouter configuration
      routerConfig: AppRouter.router,
    );
  }
}
