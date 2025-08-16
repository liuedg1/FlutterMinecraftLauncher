import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:flutter_minecraft_launcher/constants.dart';

import '../models/navigation_item.dart';
import 'download/download_page.dart';
import 'launch_page.dart';
import 'settings/settings_page.dart';
import 'versions_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    //List of NavigationRailItems
    final List<NavigationRailItem> navigationRailItems = [
      NavigationRailItem(
        page: const LaunchPage(),
        destination: NavigationRailDestination(
          icon: const Icon(Icons.rocket_launch),
          label: Text(FlutterI18n.translate(context, "launch.title")),
        ),
      ),

      NavigationRailItem(
        page: const VersionsPage(),
        destination: NavigationRailDestination(
          icon: const Icon(Icons.gamepad),
          label: Text(FlutterI18n.translate(context, "versions.title")),
        ),
      ),
      NavigationRailItem(
        page: const DownloadPage(),
        destination: NavigationRailDestination(
          icon: const Icon(Icons.download),
          label: Text(FlutterI18n.translate(context, "download.title")),
        ),
      ),
      NavigationRailItem(
        page: const SettingsPage(),
        destination: NavigationRailDestination(
          icon: const Icon(Icons.settings),
          label: Text(FlutterI18n.translate(context, "settings.title")),
        ),
      ),
    ];

    return Scaffold(
      body: Row(
        children: [
          //Main NavigationRail
          NavigationRail(
            //Add padding on the top of destinations
            leading: const SizedBox(height: kDefaultPadding / 8),

            destinations: navigationRailItems
                .map((item) => item.destination)
                .toList(),
            selectedIndex: _selectedIndex,
            labelType: NavigationRailLabelType.all,
            backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
            onDestinationSelected: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
          ),

          //Display current page
          Expanded(
            child: IndexedStack(
              index: _selectedIndex,
              children: navigationRailItems.map((item) => item.page).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
