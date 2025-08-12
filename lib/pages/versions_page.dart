import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';

class VersionsPage extends StatelessWidget {
  const VersionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        FlutterI18n.translate(context, 'versions.title'),
        style: TextStyle(fontSize: 24),
      ),
    );
  }
}
