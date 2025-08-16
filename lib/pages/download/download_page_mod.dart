import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';

class DownloadPageMod extends StatefulWidget {
  const DownloadPageMod({super.key});

  @override
  State<DownloadPageMod> createState() => _DownloadPageModState();
}

class _DownloadPageModState extends State<DownloadPageMod> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Text(FlutterI18n.translate(context, 'download.mods'));
  }
}
