import 'package:get_it/get_it.dart';
import 'package:package_info_plus/package_info_plus.dart';

final getIt = GetIt.instance;

Future<void> initializeLocator() async {
  final packageInfo = await PackageInfo.fromPlatform();

  getIt.registerSingleton<PackageInfo>(packageInfo);
}
