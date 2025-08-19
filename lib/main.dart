import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_minecraft_launcher/adapters/api_provider_adapter.dart';
import 'package:flutter_minecraft_launcher/constants.dart';
import 'package:flutter_minecraft_launcher/core/instances.dart';
import 'package:flutter_minecraft_launcher/models/setting_key.dart';
import 'package:flutter_minecraft_launcher/notifiers/settings_notifier.dart';
import 'package:flutter_minecraft_launcher/pages/main_page.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:window_manager/window_manager.dart';

import 'adapters/theme_mode_adapter.dart';
import 'core/service_locator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();

  ///Get customPath to avoid path like this: C:\Users\Example\AppData\Roaming\com.example\flutter_minecraft_launcher, we don't need com.example
  final Directory appSupportDir = await getApplicationSupportDirectory();
  final String parentPath = path.dirname(appSupportDir.path);
  final String rootPath = path.dirname(parentPath);
  final String customPath = path.join(rootPath, kAppNameAbb);

  ///Check if customPath is exists
  final Directory customDir = Directory(customPath);
  if (!await customDir.exists()) {
    await customDir.create(recursive: true);
  }

  ///Hive
  Hive.init(customPath);
  //Register adapters
  Hive.registerAdapter(ThemeModeAdapter());
  Hive.registerAdapter(ApiProviderAdapter());
  await Hive.openBox('settings');

  await initializeLocator();
  final info = getIt<PackageInfo>();
  WindowOptions windowOptions = WindowOptions(
    size: Size(1100, 700),
    minimumSize: Size(800, 600),

    ///e.g. Flutter Minecraft Launcher 1.0.0+1
    title: '$kAppName ${info.version}+${info.buildNumber}',
    titleBarStyle: TitleBarStyle.normal,
    center: true,
  );

  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
  });

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: getIt<SettingsNotifier>()),
      ],
      child: const FMCLBaseApp(),
    ),
  );
}

class FMCLBaseApp extends StatelessWidget {
  const FMCLBaseApp({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Locale> supportedLocales = kSupportLanguage
        .map((code) => _parseLocale(code))
        .toList();

    return Consumer<SettingsNotifier>(
      builder: (context, settingsNotifier, child) {
        final languageCode = settingsNotifier.getString(SettingKey.language);
        //        final themeColor = settingsNotifier.getCustom(SettingKey.themeColor);
        final locale = _parseLocale(languageCode);

        // Use NotoSans
        //TODO: Custom seedColor
        final ThemeData lightTheme = ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.deepPurple,
            brightness: Brightness.light,
          ),
          fontFamily: 'Noto Sans SC',
          brightness: Brightness.light,
        );
        final ThemeData darkTheme = ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.deepPurple,
            brightness: Brightness.dark,
          ),
          fontFamily: 'Noto Sans SC',
          brightness: Brightness.dark,
        );

        return MaterialApp(
          title: kAppName,

          theme: lightTheme,
          darkTheme: darkTheme,
          themeMode: settingsNotifier.getCustom<ThemeMode>(
            SettingKey.themeMode,
          ),

          home: HomePage(),

          ///I18n
          locale: locale,
          localizationsDelegates: [
            FlutterI18nDelegate(
              translationLoader: FileTranslationLoader(
                useCountryCode: true,
                fallbackFile: 'en_US.json',
              ),
              missingTranslationHandler: (key, locale) {
                Instances.log.w(
                  "Missing Key: $key, languageCode: ${locale?.languageCode}",
                );
              },
            ),
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],

          ///Support RTL
          builder: FlutterI18n.rootAppBuilder(),

          supportedLocales: supportedLocales,
        );
      },
    );
  }

  Locale _parseLocale(String languageCode) {
    final parts = languageCode.split('_');
    return Locale(parts[0], parts.length > 1 ? parts[1] : null);
  }
}
