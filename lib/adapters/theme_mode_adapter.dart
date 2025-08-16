import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

///Adapt ThemeMode for Hive
class ThemeModeAdapter extends TypeAdapter<ThemeMode> {
  @override
  final int typeId = 1;

  @override
  ThemeMode read(BinaryReader reader) {
    final int index = reader.readByte();
    return ThemeMode.values[index];
  }

  @override
  void write(BinaryWriter writer, ThemeMode obj) {
    writer.writeByte(obj.index);
  }
}
