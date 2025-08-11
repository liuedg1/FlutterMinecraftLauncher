import 'package:flutter/material.dart';
import 'package:flutter_minecraft_launcher/pages/settings/settings_page_about.dart';
import 'package:flutter_minecraft_launcher/pages/settings/settings_page_game.dart';
import 'package:flutter_minecraft_launcher/pages/settings/settings_page_launcher.dart';

import '../../constants.dart';
import '../../models/navigation_item.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<StatefulWidget> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  int _selectedIndex = 0;

  final List<NavigationDrawerItem> _settingsPageSubItems = [
    const NavigationDrawerItem(
      page: SettingsPageLauncher(),
      destination: NavigationDrawerDestination(
        icon: Icon(Icons.rocket_launch),
        label: Text('Launcher'),
      ),
    ),
    const NavigationDrawerItem(
      page: SettingsPageGame(),
      destination: NavigationDrawerDestination(
        icon: Icon(Icons.gamepad),
        label: Text('Game'),
      ),
    ),
    const NavigationDrawerItem(
      page: SettingsPageAbout(),
      destination: NavigationDrawerDestination(
        icon: Icon(Icons.book),
        label: Text('About'),
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          //Divider()
          decoration: BoxDecoration(
            border: Border(
              left: BorderSide(color: theme.dividerColor.withAlpha(100)),
            ),
          ),

          child: NavigationDrawer(
            selectedIndex: _selectedIndex,
            onDestinationSelected: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },

            children: [
              Padding(
                //Align Text with Destination
                padding: const EdgeInsets.fromLTRB(
                  kDefaultPadding * 1.5,
                  kDefaultPadding,
                  kDefaultPadding,
                  kDefaultPadding,
                ),
                child: Text('Settings', style: theme.textTheme.headlineMedium),
              ),

              //Destinations
              for (var item in _settingsPageSubItems) item.destination,
            ],
          ),
        ),

        //Display current page
        Expanded(
          child: IndexedStack(
            index: _selectedIndex,
            children: _settingsPageSubItems.map((item) => item.page).toList(),
          ),
        ),
      ],
    );
  }
}
