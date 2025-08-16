import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';

class DownloadPageModpack extends StatefulWidget {
  const DownloadPageModpack({super.key});

  @override
  State<DownloadPageModpack> createState() => _DownloadPageModpackState();
}

class _DownloadPageModpackState extends State<DownloadPageModpack> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Text(FlutterI18n.translate(context, 'download.modpacks'));
  }
}
