import 'package:flutter/material.dart';

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
        label: const Text('Launch'),
        icon: const Icon(Icons.rocket_launch),
      ),

      body: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(width: kDefaultPadding / 2),
          const Expanded(
            child: Text(kAppNameAbb, style: TextStyle(fontSize: 28)),
          ),
        ],
      ),
    );
  }

  void _launchCurrentMinecraft() {}
}
