import 'package:flutter/material.dart';
import 'package:flutter_minecraft_launcher/constants.dart';
import 'package:flutter_minecraft_launcher/pages/main_page.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:window_manager/window_manager.dart';

import 'common/global.dart';
import 'core/service_locator.dart';
import 'notifiers/theme_notifier.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();
  await initializeLocator();

  final info = getIt<PackageInfo>();

  WindowOptions windowOptions = WindowOptions(
    size: Size(1100, 700),
    minimumSize: Size(800, 600),

    //e.g. Flutter Minecraft Launcher 1.0.0+1
    title: '$kAppName ${info.version}+${info.buildNumber}',
    titleBarStyle: TitleBarStyle.normal,
    center: true,
  );

  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
  });

  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeNotifier(),
      child: const FMCLBaseApp(),
    ),
  );
}

class FMCLBaseApp extends StatelessWidget {
  const FMCLBaseApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeNotifier = context.watch<ThemeNotifier>();

    return MaterialApp(
      title: kAppName,

      theme: Global.lightTheme,
      darkTheme: Global.darkTheme,
      themeMode: themeNotifier.getThemeMode,

      home: HomePage(),
    );
  }
}
