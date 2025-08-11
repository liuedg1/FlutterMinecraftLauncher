import 'dart:developer' as developer;

import 'package:flutter/foundation.dart';
import 'package:flutter_minecraft_launcher/constants.dart';

import '../models/setting_item.dart';
import '../models/setting_key.dart';

class SettingsNotifier extends ChangeNotifier {
  ///Default value of setting keys
  final List<SettingItem> _settings = [
    const SettingItem<String>(
      key: SettingKey.language,
      name: 'Language',
      type: SettingType.dropdown,
      category: SettingCategory.launcher,
      options: kSupportLanguage,
      defaultValue: 'en_US',
    ),

    const SettingItem<bool>(
      key: SettingKey.test,
      name: 'Test Boolean',
      type: SettingType.boolean,
      category: SettingCategory.launcher,
      options: kSupportLanguage,
      defaultValue: false,
    ),
  ];

  List<SettingItem> get settingConfigs => _settings;

  ///Fills the values map with default values from the settings
  SettingsNotifier() {
    _values = {for (var item in _settings) item.key: item.defaultValue};
  }

  ///A map that holds the current, runtime values of all settings
  late final Map<SettingKey, dynamic> _values;

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

  bool getBool(SettingKey key) {
    return getCustom<bool>(key) ?? false;
  }

  String getString(SettingKey key) {
    return getCustom<String>(key) ?? '';
  }

  int getInt(SettingKey key) {
    return getCustom<int>(key) ?? 0;
  }

  double getDouble(SettingKey key) {
    return getCustom<double>(key) ?? 0.0;
  }

  void updateSetting<T>(SettingKey key, T newValue) {
    //Return if same value
    if (_values[key] == newValue) {
      return;
    }

    _values[key] = newValue;
    notifyListeners();
  }
}
