import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';

class SettingsPageAbout extends StatefulWidget {
  const SettingsPageAbout({super.key});

  @override
  State<SettingsPageAbout> createState() => _SettingsPageAboutState();
}

class _SettingsPageAboutState extends State<SettingsPageAbout> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Text(FlutterI18n.translate(context, 'settings.about'));
  }
}
