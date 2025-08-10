import 'package:flutter/material.dart';
import 'download_page.dart';
import 'settings_page.dart';
import 'versions_page.dart';

import 'launch_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  //List of NavigationRailItems
  final List<NavigationRailItem> _navigationRailItems = [
    const NavigationRailItem(
        page: LaunchPage(),
        destination: NavigationRailDestination(
          icon: Icon(Icons.rocket_launch),
          label: Text('Launch'),
        )),

    const NavigationRailItem(
        page: VersionsPage(),
        destination: NavigationRailDestination(
          icon: Icon(Icons.gamepad),
          label: Text('Versions'),
        )),
    const NavigationRailItem(
        page: DownloadPage(),
        destination: NavigationRailDestination(
          selectedIcon: Icon(Icons.download),
          icon: Icon(Icons.download),
          label: Text('Download'),
        )),
    const NavigationRailItem(
        page: SettingsPage(),
        destination: NavigationRailDestination(
          selectedIcon: Icon(Icons.settings),
          icon: Icon(Icons.settings),
          label: Text('Settings'),
        )),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          //Main NavigationRail
          NavigationRail(
            destinations: _navigationRailItems
                .map((item) => item.destination)
                .toList(),
            selectedIndex: _selectedIndex,
            labelType: NavigationRailLabelType.all,
            backgroundColor: Theme
                .of(context)
                .colorScheme
                .surfaceContainer,
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
              children: _navigationRailItems.map((item) => item.page).toList(),
            ),
          )
        ],
      ),

    );
  }
}

class NavigationRailItem {
  final Widget page;
  final NavigationRailDestination destination;

  const NavigationRailItem({required this.page, required this.destination});
}