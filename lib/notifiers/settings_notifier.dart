import 'package:flutter/material.dart';
import 'package:flutter_minecraft_launcher/constants.dart';
import 'package:flutter_minecraft_launcher/core/instances.dart';
import 'package:flutter_minecraft_launcher/core/network/api_urls.dart';
import 'package:hive/hive.dart';

import '../models/setting_item.dart';
import '../models/setting_key.dart';

class SettingsNotifier extends ChangeNotifier {
  late final Box _settingsBox;

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

    SettingItem<ApiProvider>(
      key: SettingKey.apiProvider,
      name: 'settings.launcher.apiProvider.title',
      type: SettingType.dropdown,
      category: SettingCategory.launcher,
      options: const [ApiProvider.mojang, ApiProvider.bmcl],
      defaultValue: ApiProvider.mojang,
      optionLabelBuilder: (option) {
        ApiProvider apiProvider = option as ApiProvider;
        return 'settings.launcher.apiProvider.${apiProvider.name}';
      },
    ),
  ];

  List<SettingItem> get settingConfigs => _settings;

  SettingsNotifier(Box settingsBox) {
    _settingsBox = settingsBox;
    _loadSettings();
  }

  void _loadSettings() {
    final Map<SettingKey, dynamic> loadedValues = {};
    for (var item in _settings) {
      ///Get in Hive
      dynamic storedValue = _settingsBox.get(
        item.key.name,
        defaultValue: item.defaultValue,
      );

      loadedValues[item.key] = storedValue;
    }

    _values = loadedValues;
  }

  ///A map that holds the current, runtime values of all settings
  late Map<SettingKey, dynamic> _values = {
    for (var item in _settings) item.key: item.defaultValue,
  };

  ///Get value from map by key
  T? getCustom<T>(SettingKey key) {
    final dynamic value = _values[key];

    if (value is T) {
      return value;
    } else {
      Instances.log.w(
        "Setting key '$key' was expected to be of type '$T', but found value '$value' of type '${value.runtimeType}'!",
        stackTrace: StackTrace.current,
      );

      return null;
    }
  }

  bool getBool(SettingKey key) => getCustom<bool>(key) ?? false;

  String getString(SettingKey key) => getCustom<String>(key) ?? '';

  int getInt(SettingKey key) => getCustom<int>(key) ?? 0;

  double getDouble(SettingKey key) => getCustom<double>(key) ?? 0.0;

  Future<void> updateSetting<T>(SettingKey key, T newValue) async {
    ///Return if same value
    if (_values[key] == newValue) {
      return;
    }

    _values[key] = newValue;

    ///Write to Hive Box
    await _settingsBox.put(key.name, newValue);

    ///Call onUpdate
    final settingItem = _settings.firstWhere((item) => item.key == key);

    if (settingItem.onUpdate != null) {
      settingItem.onUpdate!(newValue);
    }

    notifyListeners();
  }
}
