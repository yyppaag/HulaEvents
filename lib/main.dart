import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'constants/app_theme.dart';
import 'providers/timeline_provider.dart';
import 'providers/user_provider.dart';
import 'services/storage_service.dart';
import 'screens/home_screen.dart';

void main() async {
  // 确保Flutter绑定初始化
  WidgetsFlutterBinding.ensureInitialized();

  // 初始化存储服务
  final storageService = StorageService();
  await storageService.init();

  // 检查是否首次启动
  final isFirstLaunch = storageService.getSetting<bool>('isFirstLaunch', defaultValue: true) ?? true;

  runApp(MyApp(isFirstLaunch: isFirstLaunch));
}

class MyApp extends StatelessWidget {
  final bool isFirstLaunch;

  const MyApp({super.key, required this.isFirstLaunch});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => TimelineProvider()..loadTimelines(),
        ),
        ChangeNotifierProvider(
          create: (_) => UserProvider()..initialize(),
        ),
      ],
      child: MaterialApp(
        title: 'Hula Events',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('en', ''), // English
          Locale('zh', ''), // Chinese
        ],
        home: HomeScreen(isFirstLaunch: isFirstLaunch),
      ),
    );
  }
}
