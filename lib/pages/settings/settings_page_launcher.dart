import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:flutter_minecraft_launcher/widgets/settings_tile.dart';
import 'package:provider/provider.dart';

import '../../constants.dart';
import '../../models/setting_item.dart';
import '../../notifiers/settings_notifier.dart';

class SettingsPageLauncher extends StatelessWidget {
  const SettingsPageLauncher({super.key});

  @override
  Widget build(BuildContext context) {
    final settingsNotifier = context.read<SettingsNotifier>();
    final copiedAllSettings = settingsNotifier.settingConfigs;

    ///We just need launcher type item here
    final launcherSettingsList = copiedAllSettings
        .where((item) => item.category == SettingCategory.launcher)
        .toList();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Padding(
            padding: const EdgeInsets.only(
              left: kDefaultPadding,
              top: kDefaultPadding,
              bottom: kDefaultPadding,
            ),
            child: Text(
              FlutterI18n.translate(context, 'settings.launcher.pageTitle'),
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ),

          /// Use Expanded to occupy all remaining vertical space.
          Expanded(
            child: ListView.builder(
              itemCount: launcherSettingsList.length,
              itemBuilder: (BuildContext context, int index) {
                final item = launcherSettingsList[index];

                return SettingTile(item: item);
              },
            ),
          ),
        ],
      ),
    );
  }
}
