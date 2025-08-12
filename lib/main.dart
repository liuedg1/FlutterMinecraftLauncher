import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_minecraft_launcher/constants.dart';
import 'package:flutter_minecraft_launcher/models/setting_key.dart';
import 'package:flutter_minecraft_launcher/notifiers/settings_notifier.dart';
import 'package:flutter_minecraft_launcher/pages/main_page.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:window_manager/window_manager.dart';

import 'common/global.dart';
import 'core/service_locator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();
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
        ChangeNotifierProvider(create: (context) => SettingsNotifier()),
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
        final locale = _parseLocale(languageCode);

        return MaterialApp(
          title: kAppName,

          theme: Global.lightTheme,
          darkTheme: Global.darkTheme,
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
                if (kDebugMode) {
                  print(
                    "--- Missing Key: $key, languageCode: ${locale?.languageCode}",
                  );
                }
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
