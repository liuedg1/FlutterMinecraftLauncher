import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:flutter_minecraft_launcher/constants.dart';

import '../models/setting_item.dart';
import '../models/setting_key.dart';

class SettingsNotifier extends ChangeNotifier {
  ///Default value of setting keys
  final List<SettingItem> _settings = [
    SettingItem<String>(
      key: SettingKey.language,
      name: 'settings.launcher.language.title',
      type: SettingType.dropdown,
      category: SettingCategory.launcher,
      options: kSupportLanguage,
      defaultValue: 'en_US',
      optionLabelBuilder: (option) {
        return 'settings.launcher.language.$option';
      },
    ),

    SettingItem<ThemeMode>(
      key: SettingKey.themeMode,
      name: 'settings.launcher.themeMode.title',
      type: SettingType.dropdown,
      category: SettingCategory.launcher,
      options: const [ThemeMode.system, ThemeMode.dark, ThemeMode.light],
      defaultValue: ThemeMode.system,

      optionLabelBuilder: (option) {
        ThemeMode themeMode = option as ThemeMode;
        return 'settings.launcher.themeMode.${themeMode.name}';
      },
    ),
  ];

  List<SettingItem> get settingConfigs => _settings;

  ///A map that holds the current, runtime values of all settings
  late final Map<SettingKey, dynamic> _values = {
    for (var item in _settings) item.key: item.defaultValue,
  };

  ///Get value from map by key
  T? getCustom<T>(SettingKey key) {
    final dynamic value = _values[key];

    if (value is T) {
      return value;
    } else {
      developer.log(
        "Setting key '$key' was expected to be of type '$T', but found value '$value' of type '${value.runtimeType}'!",
        name: 'SettingsNotifier',
        level: 900,
        error: key,
      );

      return null;
    }
  }

  bool getBool(SettingKey key) => getCustom<bool>(key) ?? false;

  String getString(SettingKey key) => getCustom<String>(key) ?? '';

  int getInt(SettingKey key) => getCustom<int>(key) ?? 0;

  double getDouble(SettingKey key) => getCustom<double>(key) ?? 0.0;

  void updateSetting<T>(SettingKey key, T newValue) {
    ///Return if same value
    if (_values[key] == newValue) {
      return;
    }

    _values[key] = newValue;

    ///Call onUpdate
    final settingItem = _settings.firstWhere((item) => item.key == key);

    if (settingItem.onUpdate != null) {
      settingItem.onUpdate!(newValue);
    }

    notifyListeners();
  }
}
