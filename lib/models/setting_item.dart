import 'package:flutter/material.dart';
import 'package:flutter_minecraft_launcher/models/setting_key.dart';

enum SettingType { boolean, text, dropdown, header, valueOnly }

enum SettingCategory { launcher, game }

/// A class that represents a setting item.
///
/// Each setting has a key [key], a name [name], a , a generic default value[defaultValue], and a [SettingCategory] [category].
///
/// For settings of type [SettingType.dropdown], a list of [options] must be provided.
class SettingItem<T> {
  final SettingKey key;
  final String name;
  final T defaultValue;
  final SettingType type;
  final SettingCategory category;
  final IconData? icon;
  final List<String>? options;

  const SettingItem({
    required this.key,
    required this.name,
    required this.defaultValue,
    required this.type,
    required this.category,
    this.icon,
    this.options,
  }) : assert(
         type != SettingType.dropdown || options != null,
         'options must be provided when type is SettingType.dropdown',
       );
}
