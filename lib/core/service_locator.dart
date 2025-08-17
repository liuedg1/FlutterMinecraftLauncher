import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../notifiers/settings_notifier.dart';

final getIt = GetIt.instance;

Future<void> initializeLocator(Box box) async {
  ///PackageInfo
  final packageInfo = await PackageInfo.fromPlatform();
  getIt.registerSingleton<PackageInfo>(packageInfo);

  ///Register Notifier
  getIt.registerLazySingleton(() => SettingsNotifier(box));
}
