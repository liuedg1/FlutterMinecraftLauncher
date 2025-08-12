import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';

class SettingsPageGame extends StatefulWidget {
  const SettingsPageGame({super.key});

  @override
  State<SettingsPageGame> createState() => _SettingsPageGameState();
}

class _SettingsPageGameState extends State<SettingsPageGame> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Text(FlutterI18n.translate(context, 'settings.game'));
  }
}
