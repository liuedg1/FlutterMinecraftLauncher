import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';

import '../constants.dart';

//TODO:Custom page by user (e.g. display news)
class LaunchPage extends StatefulWidget {
  const LaunchPage({super.key});

  @override
  State<StatefulWidget> createState() => _LaunchPageState();
}

class _LaunchPageState extends State<LaunchPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _launchCurrentMinecraft,
        label: Text(FlutterI18n.translate(context, 'launch.title')),
        icon: const Icon(Icons.rocket_launch),
      ),

      body: Column(
        children: [
          const SizedBox(height: kDefaultPadding / 3),

          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(width: kDefaultPadding),

              Expanded(
                child: Text(
                  kAppNameAbb,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _launchCurrentMinecraft() {}
}
