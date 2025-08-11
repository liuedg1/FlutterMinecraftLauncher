import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/setting_item.dart';
import '../notifiers/settings_notifier.dart';

///Unified UI implementation of settings item
class SettingTile extends StatelessWidget {
  final SettingItem item;

  const SettingTile({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final settingsNotifier = context.read<SettingsNotifier>();

    switch (item.type) {
      case SettingType.boolean:
        return SwitchListTile(
          title: Text(item.name),
          value: context.watch<SettingsNotifier>().getBool(item.key),
          onChanged: (newValue) {
            settingsNotifier.updateSetting<bool>(item.key, newValue);
          },
        );

      case SettingType.dropdown:
        return ListTile(title: Text('${item.name} Dropdown(not implemented)'));

      case SettingType.text:
        return ListTile(title: Text('${item.name} Text(not implemented)'));

      case SettingType.header:
        return ListTile(title: Text('${item.name} Header(not implemented)'));

      default:
        return const SizedBox.shrink();
    }
  }
}
