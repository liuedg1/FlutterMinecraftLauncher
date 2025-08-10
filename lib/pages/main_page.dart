import 'package:flutter/material.dart';
import 'package:flutter_minecraft_launcher/constants.dart';
import 'package:provider/provider.dart';

import '../notifiers/theme_notifier.dart';
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

  //List of NavigationRailItems
  final List<NavigationRailItem> _navigationRailItems = [
    const NavigationRailItem(
      page: LaunchPage(),
      destination: NavigationRailDestination(
        icon: Icon(Icons.rocket_launch),
        label: Text('Launch'),
      ),
    ),

    const NavigationRailItem(
      page: VersionsPage(),
      destination: NavigationRailDestination(
        icon: Icon(Icons.gamepad),
        label: Text('Versions'),
      ),
    ),
    const NavigationRailItem(
      page: DownloadPage(),
      destination: NavigationRailDestination(
        selectedIcon: Icon(Icons.download),
        icon: Icon(Icons.download),
        label: Text('Download'),
      ),
    ),
    const NavigationRailItem(
      page: SettingsPage(),
      destination: NavigationRailDestination(
        selectedIcon: Icon(Icons.settings),
        icon: Icon(Icons.settings),
        label: Text('Settings'),
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          //Main NavigationRail
          NavigationRail(
            //Add padding on the top of destinations
            leading: const SizedBox(height: kDefaultPadding / 8),

            destinations: _navigationRailItems
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

            trailing: Expanded(
              child: Align(
                //Make button at bottom
                alignment: Alignment.bottomCenter,

                //Add padding on the bottom
                child: Padding(
                  padding: const EdgeInsets.only(bottom: kDefaultPadding),
                  child: OutlinedButton(
                    //Toggle current theme on pressed
                    onPressed: () {
                      context.read<ThemeNotifier>().toggleTheme();
                    },

                    //Rounded outlined
                    style: OutlinedButton.styleFrom(
                      shape: const CircleBorder(),
                      padding: const EdgeInsets.all(20),
                    ),

                    child: Icon(
                      size: 24,
                      //Get theme from Notifier
                      context.watch<ThemeNotifier>().getThemeMode ==
                              ThemeMode.light
                          ? Icons.dark_mode
                          : Icons.light_mode,
                    ),
                  ),
                ),
              ),
            ),
          ),

          //Display current page
          Expanded(
            child: IndexedStack(
              index: _selectedIndex,
              children: _navigationRailItems.map((item) => item.page).toList(),
            ),
          ),
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
