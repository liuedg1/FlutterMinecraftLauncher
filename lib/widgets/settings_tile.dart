import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:flutter_minecraft_launcher/constants.dart';
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
        return _buildSwitchListTile(context, settingsNotifier);

      case SettingType.dropdown:
        return _buildDropdownTile(context);

      case SettingType.text:
        return ListTile(title: Text('${item.name} Text(not implemented)'));

      case SettingType.header:
        return ListTile(title: Text('${item.name} Header(not implemented)'));

      default:
        return const SizedBox.shrink();
    }
  }

  SwitchListTile _buildSwitchListTile(
    BuildContext context,
    SettingsNotifier settingsNotifier,
  ) {
    return SwitchListTile(
      title: Text(FlutterI18n.translate(context, item.name)),
      value: context.watch<SettingsNotifier>().getBool(item.key),
      onChanged: (newValue) {
        settingsNotifier.updateSetting<bool>(item.key, newValue);
      },
    );
  }

  ListTile _buildDropdownTile(BuildContext context) {
    ///Build menu list
    final dropdownMenuEntries = (item.options as List).map((option) {
      final String label = FlutterI18n.translate(
        context,
        item.optionLabelBuilder?.call(option) ?? option.toString(),
      );
      return DropdownMenuItem(
        ///Raw data
        value: option,

        ///The text displayed to the user
        child: Padding(
          padding: const EdgeInsets.only(left: kDefaultPadding / 2),
          child: Text(label),
        ),
      );
    }).toList();

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(
        horizontal: kDefaultPadding,
        vertical: kDefaultPadding / 2,
      ),

      title: Text(FlutterI18n.translate(context, item.name)),

      trailing: DropdownButton(
        ///Get current value from notifier
        value: context.watch<SettingsNotifier>().getCustom(item.key),
        items: dropdownMenuEntries,

        onChanged: (newValue) {
          if (newValue != null) {
            context.read<SettingsNotifier>().updateSetting(item.key, newValue);
          }
        },
      ),
    );
  }
}
